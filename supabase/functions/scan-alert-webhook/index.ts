// Supabase Edge Function: scan-alert-webhook
// Triggered by a Database Webhook on INSERT into the `scans` table.
// If the new scan detected a disease (not healthy), sends the farmer a
// push notification via the `send-push` function.
//
// ASSUMPTION: the scans table has columns `user_id`, `disease_name`, and
// `severity`. Adjust the field names below if yours differ.

import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

Deno.serve(async (req: Request) => {
  try {
    const payload = await req.json();
    const record = payload.record;

    if (!record || !record.user_id || !record.disease_name) {
      return new Response("ignored: missing record fields", { status: 200 });
    }

    const disease = String(record.disease_name);
    if (disease.toLowerCase() === "healthy") {
      return new Response("ignored: healthy scan", { status: 200 });
    }

    const severity = record.severity ? String(record.severity) : "Unknown";

    await fetch(`${SUPABASE_URL}/functions/v1/send-push`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
      },
      body: JSON.stringify({
        user_id: record.user_id,
        title: `${disease} detected`,
        body: `Your recent scan found ${disease} (${severity} severity). Tap to see treatment steps.`,
        type: "disease_alerts",
        data: { disease, severity, screen: "diagnosis" },
      }),
    });

    return new Response("ok", { status: 200 });
  } catch (e) {
    return new Response(String(e), { status: 500 });
  }
});