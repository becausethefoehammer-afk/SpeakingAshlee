import http from "http";
import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

const SYSTEM_PROMPT = `You are a Gen Z translator (targeting people currently around age 26-30 in 2026). \
Your job is to rewrite normal, formal, or "old" sounding sentences into authentic Gen Z slang.

Core vocab to draw from naturally (don't force all of them):
no cap / cap (lie), slay, bussin, lowkey / highkey, it's giving, rent free, main character,
understood the assignment, ate and left no crumbs, periodt, on god, bet, fr fr, ngl,
I'm dead / I'm deceased (finding something hilarious), I'm not about to, I'm not tryna,
listen listen, okay but actually though, the way that, not me [doing something],
hits different, vibe check, that ain't it, it's the [X] for me,
rizz / rizzed up, delulu, touch grass, based, mid,
W / L (win/loss), era (in my [x] era), so real, real for that, the audacity,
sending me, living rent free, do it for the plot, main character energy, NPC,
caught in 4K, lowkey obsessed, bestie/besties, fam, sheesh,
no thoughts head empty, ate THAT up, the bar is in hell, bffr (be fr fr), be so fr, ick,
red flag / green flag, that's unhinged, iconic, the villain era.

Rules:
- Output ONLY the translated sentence(s). No explanations, no labels, no quotes.
- Keep the same core meaning but rephrase with Gen Z cadence, rhythm, and slang.
- Add natural fillers like "okay but", "literally", "not me", "I'm sorry but" where they fit.
- Use lowercase except for emphasis (ALL CAPS on a single word is fine).
- 2-4 slang terms per sentence max — don't overload.
- Match the emotional tone: frustrated = frustrated Gen Z style; excited = amp it up.`;

const PORT = parseInt(process.env.PORT ?? "3000", 10);

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

function sendJSON(res, status, body) {
  const payload = JSON.stringify(body);
  res.writeHead(status, { "Content-Type": "application/json", ...CORS_HEADERS });
  res.end(payload);
}

async function readBody(req) {
  return new Promise((resolve, reject) => {
    let data = "";
    req.on("data", (chunk) => { data += chunk; });
    req.on("end", () => resolve(data));
    req.on("error", reject);
  });
}

const server = http.createServer(async (req, res) => {
  if (req.method === "OPTIONS") {
    res.writeHead(204, CORS_HEADERS);
    res.end();
    return;
  }

  const url = new URL(req.url, `http://localhost:${PORT}`);

  if (req.method === "GET" && url.pathname === "/") {
    return sendJSON(res, 200, { status: "ok" });
  }

  if (req.method === "POST" && url.pathname === "/translate") {
    let body;
    try {
      body = JSON.parse(await readBody(req));
    } catch {
      return sendJSON(res, 400, { error: "invalid json" });
    }

    const input = (body.input ?? "").trim();
    if (!input) return sendJSON(res, 400, { error: "input is required" });
    if (input.length > 1000) return sendJSON(res, 400, { error: "input too long (max 1000 chars)" });

    try {
      const message = await client.messages.create({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 300,
        system: SYSTEM_PROMPT,
        messages: [{ role: "user", content: `Translate this: ${input}` }],
      });
      const translation = message.content[0]?.text ?? "";
      return sendJSON(res, 200, { translation });
    } catch (err) {
      console.error("Anthropic error:", err.message);
      return sendJSON(res, 502, { error: "translation failed" });
    }
  }

  sendJSON(res, 404, { error: "not found" });
});

server.listen(PORT, () => console.log(`proxy listening on :${PORT}`));
