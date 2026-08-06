// Supabase Edge Function: send-push
// Sends a push notification (via Firebase Cloud Messaging, HTTP v1 API) to
// all of a user's registered devices.
//
// Body: { user_id: string, title: string, body: string, data?: object, type?: string }
//
// "type" should match one of the notification preference keys
// (disease_alerts, scan_reminders, treatment_reminders, weekly_reports,
// app_updates) — if provided, the function checks the user's saved
// preference and skips sending if they've turned that type off.
//
// Requires these Supabase secrets:
//   FCM_PROJECT_ID           — your Firebase project ID
//   FCM_SERVICE_ACCOUNT_JSON — the full JSON of a Firebase service account
//                               key with "Firebase Cloud Messaging API" access

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FCM_PROJECT_ID = Deno.env.get("FCM_PROJECT_ID");
const FCM_SERVICE_ACCOUNT_JSON = Deno.env.get("FCM_SERVICE_ACCOUNT_JSON");

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    if (!FCM_PROJECT_ID || !FCM_SERVICE_ACCOUNT_JSON) {
      return json({ error: "Server misconfigured: missing FCM secrets." }, 500);
    }

    const { user_id, title, body, data, type } = await req.json();
    if (!user_id || !title || !body) {
      return json({ error: "user_id, title, and body are required." }, 400);
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Respect the user's notification preferences, if a type was given.
    // NOTE: adjust the table/column name below to match how prefs are
    // actually stored in your schema.
    if (type) {
      const { data: profile } = await supabase
        .from("profiles")
        .select("notification_prefs")
        .eq("id", user_id)
        .single();

      const prefs = profile?.notification_prefs ?? {};
      if (prefs[type] === false) {
        return json({ skipped: true, reason: "User disabled this notification type." });
      }
    }

    const { data: tokens, error: tokensError } = await supabase
      .from("device_tokens")
      .select("fcm_token")
      .eq("user_id", user_id);

    if (tokensError) throw tokensError;
    if (!tokens || tokens.length === 0) {
      return json({ sent: 0, reason: "No registered devices for this user." });
    }

    const accessToken = await getAccessToken();
    let sent = 0;
    const errors: string[] = [];

    for (const { fcm_token } of tokens) {
      try {
        await sendFcm(accessToken, fcm_token, title, body, data ?? {});
        sent++;
      } catch (e) {
        errors.push(String(e));
        // Clean up tokens FCM reports as no-longer-valid
        if (String(e).includes("UNREGISTERED") || String(e).includes("NOT_FOUND")) {
          await supabase.from("device_tokens").delete().eq("fcm_token", fcm_token);
        }
      }
    }

    return json({ sent, errors: errors.length ? errors : undefined });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

async function sendFcm(
  accessToken: string,
  token: string,
  title: string,
  body: string,
  data: Record<string, unknown>,
) {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${FCM_PROJECT_ID}/messages:send`,
    {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          data: Object.fromEntries(
            Object.entries(data).map(([k, v]) => [k, String(v)]),
          ),
        },
      }),
    },
  );

  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`FCM error (${res.status}): ${errText}`);
  }
}

// Exchanges the service account JSON for a short-lived OAuth2 access token,
// since FCM's HTTP v1 API requires a Google OAuth2 bearer token rather than
// the old server-key scheme.
async function getAccessToken(): Promise<string> {
  const serviceAccount = JSON.parse(FCM_SERVICE_ACCOUNT_JSON!);

  const jwtHeader = { alg: "RS256", typ: "JWT" };
  const now = Math.floor(Date.now() / 1000);
  const jwtClaimSet = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    exp: now + 3600,
    iat: now,
  };

  const encoder = new TextEncoder();
  const base64url = (obj: unknown) =>
    btoa(JSON.stringify(obj)).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");

  const unsigned = `${base64url(jwtHeader)}.${base64url(jwtClaimSet)}`;

  const keyData = serviceAccount.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s/g, "");
  const binaryKey = Uint8Array.from(atob(keyData), (c) => c.charCodeAt(0));

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryKey,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    cryptoKey,
    encoder.encode(unsigned),
  );
  const encodedSig = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");

  const jwt = `${unsigned}.${encodedSig}`;

  const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!tokenRes.ok) {
    throw new Error(`Failed to get access token: ${await tokenRes.text()}`);
  }

  const tokenData = await tokenRes.json();
  return tokenData.access_token;
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}