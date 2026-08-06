// Supabase Edge Function: cashew-ai (Groq version)
// Handles two request types from the Flutter app:
//   1. { mode: "insight", disease, severity, confidence, infectedArea }
//      -> returns a short, specific AI-generated insight about this diagnosis
//   2. { mode: "chat", disease, severity, message, history }
//      -> returns an AI response to a farmer's question/complaint about
//         their crop issue, with the diagnosis as context
//
// The Groq API key is read from Supabase secrets (GROQ_API_KEY),
// never exposed to the client. Groq's endpoint is OpenAI-compatible.

import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const GROQ_API_KEY = Deno.env.get("GROQ_API_KEY");
const MODEL = "openai/gpt-oss-20b";
const GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";

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
    const body = await req.json();
    const mode = body.mode;

    if (!GROQ_API_KEY) {
      return jsonResponse({ error: "Server misconfigured: missing API key." }, 500);
    }

    if (mode === "insight") {
      const { disease, severity, confidence, infectedArea } = body;
      const hasScanNumbers = confidence != null && infectedArea != null;

      const prompt = hasScanNumbers
        ? `You are an agricultural assistant helping a Nigerian cashew farmer understand their leaf scan result. ` +
          `Diagnosis: ${disease}. Severity: ${severity}. AI confidence: ${confidence}%. Infected leaf area: ${infectedArea}%. ` +
          `Write a short, specific, encouraging insight (2-3 sentences max) about what this particular result means practically for the farmer right now — not generic disease facts, but something tailored to these exact numbers. Keep it simple and plain-spoken, avoid jargon.`
        : `You are an agricultural assistant helping a Nigerian cashew farmer learn about a disease before or without a specific scan. ` +
          `Disease: ${disease}. Typical severity level being viewed: ${severity}. ` +
          `Write a short, practical insight (2-3 sentences max) about this disease that helps the farmer recognize it early and act on it — not a dry definition, but something useful and plain-spoken. Avoid jargon.`;

      const text = await callGroq([{ role: "user", content: prompt }]);
      return jsonResponse({ insight: text });
    }

    if (mode === "chat") {
      const { disease, severity, message, history, confidence, infectedArea } = body;
      const hasScanNumbers = confidence != null && infectedArea != null;

      const scanContext = hasScanNumbers
        ? `Their most recent scan result: ${disease} detected, severity ${severity}, AI confidence ${confidence}%, infected leaf area ${infectedArea}%. `
        : `Their most recent leaf diagnosis was: ${disease} (severity: ${severity}). `;

      const systemPrompt =
        `You are a friendly, knowledgeable assistant built into the CashewGuard AI app, helping a Nigerian cashew farmer. ` +
        scanContext +
        `Answer their questions or concerns with practical, safe, actionable advice. ` +
        `You can discuss anything related to farming, agriculture, crops, soil, pests, weather, or rural livelihoods generally — not just cashew — since farmers often have related questions. ` +
        `You can also explain how to use the CashewGuard AI app itself (scanning leaves, reading diagnosis results, the treatment guide, etc.) if asked. ` +
        `Keep answers concise (3-5 sentences), plain language, and practical for a smallholder farmer. ` +
        `Do NOT use markdown formatting — no asterisks, no bold text, no headers. Write in plain sentences. If you need a list, use simple numbers like "1)" "2)" on new lines, nothing fancier. ` +
        `If the question is clearly unrelated to farming, agriculture, or the app (e.g. entertainment, politics, coding, unrelated trivia), gently redirect them back to farming or app-related topics.`;

      const messages = buildMessages(history, systemPrompt, message);
      const text = await callGroq(messages);
      return jsonResponse({ reply: text });
    }

    if (mode === "assistant") {
      const { message, history } = body;

      const systemPrompt =
        `You are a helpful, friendly AI assistant built into the CashewGuard AI app. ` +
        `Answer the user's questions on any topic — not just farming — the same way a general-purpose ` +
        `assistant would. Be warm, clear, and reasonably concise. If it's a farming or cashew-related ` +
        `question, feel free to draw on that knowledge too, but don't limit yourself to it. ` +
        `Do NOT use markdown formatting — no asterisks, no bold text, no headers. Write in plain sentences. If you need a list, use simple numbers like "1)" "2)" on new lines, nothing fancier.`;

      const messages = buildMessages(history, systemPrompt, message);
      const text = await callGroq(messages);
      return jsonResponse({ reply: text });
    }

    return jsonResponse({ error: "Unknown mode." }, 400);
  } catch (e) {
    return jsonResponse({ error: String(e) }, 500);
  }
});

function buildMessages(
  history: { role: string; content: string }[] | undefined,
  systemPrompt: string,
  newMessage: string,
) {
  const messages: { role: string; content: string }[] = [
    { role: "system", content: systemPrompt },
  ];

  for (const m of history ?? []) {
    messages.push({
      role: m.role === "user" ? "user" : "assistant",
      content: m.content,
    });
  }

  messages.push({ role: "user", content: newMessage });
  return messages;
}

async function callGroq(
  messages: { role: string; content: string }[],
): Promise<string> {
  const res = await fetch(GROQ_URL, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "authorization": `Bearer ${GROQ_API_KEY}`,
    },
    body: JSON.stringify({
      model: MODEL,
      messages,
      max_tokens: 400,
      temperature: 0.7,
    }),
  });

  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`Groq API error (${res.status}): ${errText}`);
  }

  const data = await res.json();
  const text = data.choices?.[0]?.message?.content?.trim();
  return text ?? "Sorry, I could not generate a response right now.";
}

function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}