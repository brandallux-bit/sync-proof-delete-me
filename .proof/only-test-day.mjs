// Proof only. Lets ONE connector call through: get_photos, view "pictures", for the test day. Blocks every other.
let text = "";
process.stdin.on("data", (c) => { text += c; });
process.stdin.on("end", () => {
  let call = {};
  try { call = JSON.parse(text); } catch { /* blocked below */ }
  const name = String(call.tool_name ?? "");
  const input = call.tool_input ?? {};
  const day = input.day && typeof input.day === "object" ? input.day.date : input.day;
  const ok = /^mcp__(claude_ai_)?BioAI__get_photos$/.test(name) && input.view === "pictures" && day === "2020-01-01" && input.poses === undefined && input.before === undefined;
  if (ok) process.exit(0);
  process.stderr.write("Blocked for the proof: only get_photos with view pictures and day 2020-01-01 is allowed here.\n");
  process.exit(2);
});
