// SessionStart hook: prints a fresh call-key prefix and the reminder to read the chart summary first.
// A new prefix on every run (startup, resume, clear, compact, fork), so write numbering never carries
// over from a context Claude no longer holds. Node only, no packages. It reads nothing from stdin and
// never fails the session: whatever goes wrong, it exits 0.
import { randomBytes } from "node:crypto";

const ALPHABET = "abcdefghijklmnopqrstuvwxyz0123456789";
const LENGTH = 12;
// The largest multiple of the alphabet's size below 256: bytes from it up are skipped, so every
// character is equally likely.
const LIMIT = 256 - (256 % ALPHABET.length);

/** Twelve random lowercase letters and digits. */
function prefix() {
  let out = "";
  while (out.length < LENGTH) {
    for (const byte of randomBytes(LENGTH * 2)) {
      if (byte < LIMIT && out.length < LENGTH) {
        out += ALPHABET[byte % ALPHABET.length];
      }
    }
  }
  return out;
}

process.stdout.on("error", () => {});
const lines = [];
try {
  lines.push(`Session key prefix: ${prefix()}`);
} catch {
  // No prefix: CLAUDE.md says to make one when none was printed.
}
lines.push("Call get_summary before anything else.");
try {
  process.stdout.write(`${lines.join("\n")}\n`);
} catch {
  // Nothing to do: the session goes on without the lines.
}
process.exitCode = 0;
