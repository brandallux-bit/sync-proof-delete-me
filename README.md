# bioai-coach

The coach's rules for Claude Code. Start a Claude Code session on your own copy of this repository and talk to your coach: it logs and answers through the BioAI platform's tools, signed in as you.

**It keeps itself up to date.** Each time a session starts, a small script fetches the coach's current rules, skills and reviewers from this repository. You never update it yourself.

**It holds no data and no platform code.** Your chart lives on the platform (bioaicoach.com). This repository holds only:

- `CLAUDE.md`: a few lines that never change. They tell the coach to read its rules before anything else.
- `.bioai/update.sh`: the start-up script. It writes only inside this folder, only the files listed below, and it pre-approves only BioAI's own tools. It never changes itself.
- `bundle/`: the current coach, file by file, which the script fetches. `bundle/MANIFEST` lists each file with its checksum, and the script takes nothing that doesn't match.
- `.claude/settings.json`: the platform's tools pre-allowed, file and shell tools denied, and the two start-of-session hooks: the start-up script and the session key.
- `.claude/hooks/session-key.mjs`: prints a fresh key prefix at the start of each session, so a resent save is never saved twice.
- `.claude/agents/`: read-only reviewers the coach runs on a plan change: the five standing ones, `nutrition`, `strength`, `recovery`, `adherence` and `red-team`, and one `specialist` that takes on any brief saved in your chart. They read your chart and save nothing. Each one reads its current instructions from `.bioai/reviewers/` when it runs.
- `.gitignore`: keeps what the script writes out of git, so a session never has anything to commit.

What the script writes at the start of a session, never committed:

- `.bioai/rules.md`: the coach's rules, read before anything else.
- `.bioai/reviewers/`: each reviewer's instructions.
- `.claude/skills/today/`: how to log a day, save what you tell it, and answer questions about it.
- `.claude/skills/train-today/`: what to train today, from what you actually did lately.
- `.claude/skills/program-design/`: the next block, whether you're ready to go up, and how your lifts are doing.
- `.claude/skills/weekly-review/`: how your last finished week went: the facts, one verdict, one thing for next week.
- `.claude/skills/nutrition-targets/`: should you eat more or less: maintenance from what you ate and what your weight did, your floor, and the calories and protein a rate comes to.
- `.claude/skills/intake/`: setting up a new person: what you want, how you live, what is safe for you, and your first plan, saved as you say it and adopted only on your yes.
- `.claude/skills/plan-change/`: changing a day or the plan: draft, stage, review, show, and save only on your yes.
- `.claude/settings.local.json`: BioAI's tools pre-allowed, as of the current coach.
- `.bioai/VERSION`: which version of the coach it holds.

## Before the first session

You need to have been invited. Start at `https://www.bioaicoach.com/start`: sign in, press Start, and follow the steps it shows you.

1. Connect the coach once: in a web browser go to claude.ai/plugins, press Add, then Add custom connector, named `BioAI`, with the URL `https://www.bioaicoach.com/api/mcp`. Sign in by the emailed link if asked, and press Allow.
2. Connect GitHub once (needs a free GitHub account): in a web browser, go to claude.ai/code and connect GitHub when it asks.
3. Make your own copy, once: on GitHub, fork `brandallux-bit/bioai-coach` once (Claude lists only your own repositories). Your copy keeps itself up to date: you never go back to GitHub for it.

## Opening it

The coach always runs in a cloud session on your copy, on a computer or a phone. At claude.ai/code, or in the Claude app's Code tab, start a session on your copy. Nothing is put on your machine and there is nothing to install. If the session can't reach the platform, add `bioaicoach.com` to that environment's allowed domains.

Then say hello. Its first step is always to read your chart summary. After that, tell it a meal, a weight, a workout, or ask "what's left today?".

## Changing it

Don't edit this repository directly. It's published from the platform repository's `workspace/` folder, where it's tested: make the change there, run `pnpm workspace:publish <this folder>` from the platform repository, then commit everything it changed here, removals included (`git add -A`), and push. Everyone has it at their next session.
