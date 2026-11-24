# 1. Start-up message

```
BioAI coach folder: updated to version b58012393405.
Read .bioai/rules.md now, all of it, before you reply.
```

# 2. Command output

## ls -la .claude/agents

```
total 36
drwxr-xr-x 2 root root 4096 Nov 24 17:52 .
drwxr-xr-x 5 root root 4096 Nov 24 17:52 ..
-rw-r--r-- 1 root root 1397 Nov 24 17:52 adherence.md
-rw-r--r-- 1 root root 1486 Nov 24 17:52 nutrition.md
-rw-r--r-- 1 root root  227 Nov 24 15:49 proof-written.md
-rw-r--r-- 1 root root 1351 Nov 24 17:52 recovery.md
-rw-r--r-- 1 root root 1566 Nov 24 17:52 red-team.md
-rw-r--r-- 1 root root 1459 Nov 24 17:52 specialist.md
-rw-r--r-- 1 root root 1533 Nov 24 17:52 strength.md
```

## git ls-files .claude/agents

```
.claude/agents/adherence.md
.claude/agents/nutrition.md
.claude/agents/recovery.md
.claude/agents/red-team.md
.claude/agents/specialist.md
.claude/agents/strength.md
```

## ls -la .bioai

```
total 56
drwxr-xr-x 3 root root  4096 Nov 24 17:52 .
drwxr-xr-x 7 root root  4096 Nov 24 17:52 ..
-rw-r--r-- 1 root root  1371 Nov 24 17:52 MANIFEST
-rw-r--r-- 1 root root    13 Nov 24 17:52 VERSION
drwxr-xr-x 2 root root  4096 Nov 24 17:52 reviewers
-rw-r--r-- 1 root root 12673 Nov 24 17:52 rules.md
-rw-r--r-- 1 root root    65 Nov 24 17:52 settings.sha256
-rw-r--r-- 1 root root 13775 Nov 24 17:52 update.sh
```

## cat .bioai/VERSION

```
b58012393405
```

## git status --short

```
?? .claude/agents/proof-written.md
?? .proof/
```

# 3. Files in .claude/agents/

## adherence.md

````
---
name: adherence
description: Reviews a staged plan change when completion is low, instead of the domain specialists. Asks what is in the way and whether the change makes the plan simpler. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/adherence.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The adherence reviewer's instructions are missing." Do nothing else.
````

## nutrition.md

````
---
name: nutrition
description: Reviews a staged plan change that touches calories, macros, meal structure or the rate of weight change, and helps the coach design a nutrition target before it is proposed. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_target_figures, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_target_figures, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/nutrition.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The nutrition reviewer's instructions are missing." Do nothing else.
````

## proof-written.md

````
---
name: proof-written
description: Proof only. Written by the start-up step. Lists the tools it holds.
tools: Read, mcp__BioAI__get_*
---
List every tool you hold, by exact name, one per line, and nothing else. Call no tool.
````

## recovery.md

````
---
name: recovery
description: Reviews a staged plan change that touches training load, rest, deloads, sleep or anything around an injury or pain. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/recovery.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The recovery reviewer's instructions are missing." Do nothing else.
````

## red-team.md

````
---
name: red-team
description: The last reviewer of a staged plan change, run after the others and before it reaches the person. Argues the strongest case against the change and can veto it. Reviews the coach's work, not the person.
model: inherit
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_progressions, mcp__claude_ai_BioAI__report_lifts, mcp__claude_ai_BioAI__get_target_figures, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_progressions, mcp__BioAI__report_lifts, mcp__BioAI__get_target_figures, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/red-team.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The red-team reviewer's instructions are missing." Do nothing else.
````

## specialist.md

````
---
name: specialist
description: One of the person's own specialists, run with the name of one of the briefs saved in their chart. The coach runs it when that brief's consultWhen applies, or when a plan change touches what the brief serves, and hands it the brief's name and the question. It answers the coach, never the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/specialist.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The specialist reviewer's instructions are missing." Do nothing else.
````

## strength.md

````
---
name: strength
description: Reviews a staged plan change that touches the training program, exercise selection, volume, progression or a deload, and helps the coach design a new training block. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_progressions, mcp__claude_ai_BioAI__report_lifts, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_progressions, mcp__BioAI__report_lifts, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/strength.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The strength reviewer's instructions are missing." Do nothing else.
````

# 4. Subagent replies

## adherence

```
mcp__BioAI__get_summary
mcp__BioAI__get_chart_section
mcp__BioAI__get_document
mcp__BioAI__get_history
mcp__BioAI__get_recent_training
mcp__BioAI__get_findings
mcp__BioAI__report_today
mcp__BioAI__report_progress
mcp__BioAI__report_history
mcp__BioAI__report_week_ahead
mcp__BioAI__report_week_review
mcp__BioAI__get_labs
mcp__BioAI__get_specialist_brief
Read
SubagentHandback
```

## nutrition

```
mcp__BioAI__get_summary
mcp__BioAI__get_chart_section
mcp__BioAI__get_document
mcp__BioAI__get_history
mcp__BioAI__get_recent_training
mcp__BioAI__get_findings
mcp__BioAI__report_today
mcp__BioAI__report_progress
mcp__BioAI__report_history
mcp__BioAI__report_week_ahead
mcp__BioAI__report_week_review
mcp__BioAI__get_target_figures
mcp__BioAI__get_labs
mcp__BioAI__get_specialist_brief
Read
SubagentHandback
```

## recovery

```
mcp__BioAI__get_summary
mcp__BioAI__get_chart_section
mcp__BioAI__get_document
mcp__BioAI__get_history
mcp__BioAI__get_recent_training
mcp__BioAI__get_findings
mcp__BioAI__report_today
mcp__BioAI__report_progress
mcp__BioAI__report_history
mcp__BioAI__report_week_ahead
mcp__BioAI__report_week_review
mcp__BioAI__get_labs
mcp__BioAI__get_specialist_brief
Read
SubagentHandback
```

## red-team

```
mcp__BioAI__get_summary
mcp__BioAI__get_chart_section
mcp__BioAI__get_document
mcp__BioAI__get_history
mcp__BioAI__get_recent_training
mcp__BioAI__get_findings
mcp__BioAI__report_today
mcp__BioAI__report_progress
mcp__BioAI__report_history
mcp__BioAI__report_week_ahead
mcp__BioAI__report_week_review
mcp__BioAI__get_progressions
mcp__BioAI__report_lifts
mcp__BioAI__get_target_figures
mcp__BioAI__get_labs
mcp__BioAI__get_specialist_brief
Read
SubagentHandback

Note (not a tool name): you asked for no calls, but I made two. My standing instructions required a Read of /home/user/sync-proof-delete-me/.bioai/reviewers/red-team.md before anything else (it was present and read in full), and SubagentHandback is the only way this reply reaches you. No BioAI tool was called.
```

## specialist

```
No specialist brief name was given, so I took no specialist role and read no chart data. The only call I made was reading `.bioai/reviewers/specialist.md`. These are the tools I hold:

mcp__BioAI__get_summary
mcp__BioAI__get_chart_section
mcp__BioAI__get_document
mcp__BioAI__get_history
mcp__BioAI__get_recent_training
mcp__BioAI__get_findings
mcp__BioAI__report_today
mcp__BioAI__report_progress
mcp__BioAI__report_history
mcp__BioAI__report_week_ahead
mcp__BioAI__report_week_review
mcp__BioAI__get_labs
mcp__BioAI__get_specialist_brief
Read
SubagentHandback

The system prompt also lists instructions for Claude_Docs and Google_Drive MCP servers. No tools from either server are defined for me, so I hold none from them. Some deferred tools may exist, but none has been surfaced to me.
```

## strength

```
mcp__BioAI__get_summary
mcp__BioAI__get_chart_section
mcp__BioAI__get_document
mcp__BioAI__get_history
mcp__BioAI__get_recent_training
mcp__BioAI__get_findings
mcp__BioAI__report_today
mcp__BioAI__report_progress
mcp__BioAI__report_history
mcp__BioAI__report_week_ahead
mcp__BioAI__report_week_review
mcp__BioAI__get_progressions
mcp__BioAI__report_lifts
mcp__BioAI__get_labs
mcp__BioAI__get_specialist_brief
Read
SubagentHandback
```

# 5. What the reply to "Hello" said about updating, syncing or refreshing

```
Your coach needs one quick update. Check with the person who invited you first; when they say yes: 1. On GitHub, open your copy of bioai-coach. 2. Press Sync fork, then Update branch. 3. Start a new session here. Until then, everything works as it did.
```
