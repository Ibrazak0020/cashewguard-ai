// Supabase Edge Function: delete-account
//
// Deploy with:  supabase functions deploy delete-account
//
// This function must never run with a client-supplied service role key —
// it uses Deno.env.get('SUPABASE_SERVICE_ROLE_KEY'), which Supabase injects
// automatically into every Edge Function's environment for your project.
// You do not need to manually set this secret.
//
// Flow:
//   1. Read the caller's own access token from the Authorization header.
//   2. Use a client scoped to that token to find out WHO is calling
//      (never trust a user_id passed in the request body).
//   3. Use a separate admin client (service role) to delete their data
//      and finally their auth user record.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return json({ error: "Missing Authorization header" }, 401);
    }

    // Scoped to the caller's own JWT — used only to confirm who they are.
    const userClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );

    const {
      data: { user },
      error: userError,
    } = await userClient.auth.getUser();

    if (userError || !user) {
      return json({ error: "Invalid or expired session" }, 401);
    }

    // Holds the service role key — only ever used here, never sent to the client.
    const adminClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // Clean up related data first. Adjust table/column names if yours differ.
    const { error: scansError } = await adminClient
      .from("scans")
      .delete()
      .eq("user_id", user.id);

    if (scansError) {
      // Not fatal — log and continue, since an orphaned scans row is
      // recoverable, but a half-deleted auth user is worse.
      console.error("Failed to delete scans:", scansError.message);
    }

    // Best-effort avatar cleanup — ignore failures (file may not exist).
    try {
      await adminClient.storage.from("avatars").remove([`${user.id}.jpg`]);
    } catch (_) {
      // no-op
    }

    const { error: deleteError } = await adminClient.auth.admin.deleteUser(
      user.id,
    );

    if (deleteError) {
      return json({ error: deleteError.message }, 500);
    }

    return json({ success: true }, 200);
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : "Unknown error" }, 500);
  }
});