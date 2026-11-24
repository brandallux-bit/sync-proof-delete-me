# Proof result 2

## Reply to "Hello"

```
Hello. I couldn't reach your chart just now, so I haven't read your summary and I can't log or look anything up yet. Nothing was saved. Say hello again in a moment and I'll try again.
```

## 1. Start-up message

```
BioAI coach folder: updated to version b58012393405. This copy writes its own reviewers.
Read .bioai/rules.md now, all of it, before you reply.
```

## 2. Command output

```
$ uname -a
Linux vm 6.18.44-fc-v819 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux

$ ls -la /bin/sh
lrwxrwxrwx 1 root root 4 Mar 31  2024 /bin/sh -> dash

$ ls -la .claude/agents
total 32
drwxr-xr-x 2 root root 4096 Nov 24 17:57 .
drwxr-xr-x 5 root root 4096 Nov 24 17:57 ..
-rw-r--r-- 1 root root 1397 Nov 24 17:57 adherence.md
-rw-r--r-- 1 root root 1486 Nov 24 17:57 nutrition.md
-rw-r--r-- 1 root root 1351 Nov 24 17:57 recovery.md
-rw-r--r-- 1 root root 1566 Nov 24 17:57 red-team.md
-rw-r--r-- 1 root root 1459 Nov 24 17:57 specialist.md
-rw-r--r-- 1 root root 1533 Nov 24 17:57 strength.md

$ git ls-files .claude/agents

$ ls -la .bioai
total 72
drwxr-xr-x 3 root root  4096 Nov 24 17:57 .
drwxr-xr-x 7 root root  4096 Nov 24 17:57 ..
-rw-r--r-- 1 root root   586 Nov 24 17:57 AGENTS
-rw-r--r-- 1 root root  1371 Nov 24 17:57 MANIFEST
-rw-r--r-- 1 root root    13 Nov 24 17:57 VERSION
drwxr-xr-x 2 root root  4096 Nov 24 17:57 reviewers
-rw-r--r-- 1 root root 12673 Nov 24 17:57 rules.md
-rw-r--r-- 1 root root    65 Nov 24 17:57 settings.sha256
-rw-r--r-- 1 root root 27671 Nov 24 17:57 update.sh

$ cat .bioai/VERSION
b58012393405

$ cat .bioai/AGENTS
format 1
version b58012393405
b3c6e27795ef5971d692f3f0d6fa8a354383ba5f505386eb424b3f46dce4a4d6  agent-specs/adherence.txt
22abd6ace6a677afe3b85d3df9f991266d92cb00c752542981bf1f8f9cefd514  agent-specs/nutrition.txt
fea9036657702bad93dec191a586853947954db7a09b2d52f8db27482c406af0  agent-specs/recovery.txt
a431d0f1e05aff7a4203b2d3c2a12958529aa9e2a6e79c2a12db59b1dd843f5a  agent-specs/red-team.txt
42019eefffd5a5406a25ec4a358af6aab7064cfcb53cfb315730d55f4a13c546  agent-specs/specialist.txt
51d642f39f90091567b7df2f91749396dc9e2b3187beb69b19a62737da67d58b  agent-specs/strength.txt
end 6

$ git status --short
?? .proof/

```

## 3. Files in .claude/agents/

### adherence.md

```
---
name: adherence
description: Reviews a staged plan change when completion is low, instead of the domain specialists. Asks what is in the way and whether the change makes the plan simpler. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/adherence.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The adherence reviewer's instructions are missing." Do nothing else.
```

### nutrition.md

```
---
name: nutrition
description: Reviews a staged plan change that touches calories, macros, meal structure or the rate of weight change, and helps the coach design a nutrition target before it is proposed. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_target_figures, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_target_figures, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/nutrition.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The nutrition reviewer's instructions are missing." Do nothing else.
```

### recovery.md

```
---
name: recovery
description: Reviews a staged plan change that touches training load, rest, deloads, sleep or anything around an injury or pain. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/recovery.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The recovery reviewer's instructions are missing." Do nothing else.
```

### red-team.md

```
---
name: red-team
description: The last reviewer of a staged plan change, run after the others and before it reaches the person. Argues the strongest case against the change and can veto it. Reviews the coach's work, not the person.
model: inherit
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_progressions, mcp__claude_ai_BioAI__report_lifts, mcp__claude_ai_BioAI__get_target_figures, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_progressions, mcp__BioAI__report_lifts, mcp__BioAI__get_target_figures, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/red-team.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The red-team reviewer's instructions are missing." Do nothing else.
```

### specialist.md

```
---
name: specialist
description: One of the person's own specialists, run with the name of one of the briefs saved in their chart. The coach runs it when that brief's consultWhen applies, or when a plan change touches what the brief serves, and hands it the brief's name and the question. It answers the coach, never the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/specialist.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The specialist reviewer's instructions are missing." Do nothing else.
```

### strength.md

```
---
name: strength
description: Reviews a staged plan change that touches the training program, exercise selection, volume, progression or a deload, and helps the coach design a new training block. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_progressions, mcp__claude_ai_BioAI__report_lifts, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_progressions, mcp__BioAI__report_lifts, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/strength.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The strength reviewer's instructions are missing." Do nothing else.
```

## 4. Subagent replies

### adherence

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

### nutrition

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

### recovery

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

### red-team

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

Note: despite "Call none", I made two calls: one Read of /home/user/sync-proof-delete-me/.bioai/reviewers/red-team.md (my start-up instructions require it before anything else; the file is present) and this SubagentHandback, the only way a reply reaches you. No BioAI tool was called. The Claude_Docs and Google_Drive servers are connected, but their tools are deferred and I hold no names for them.
```

### specialist

```
No specialist brief name was given, so I can't act as a specialist. I read nothing from the chart and answered no clinical question.

Tools I hold, as you asked, with none called:
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

### strength

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

## 5. What the reply to "Hello" said about updating, syncing or refreshing

nothing

## 6.

```
$ BIOAI_COACH_BASE=https://raw.githubusercontent.com/brandallux-bit/sync-proof-delete-me/source-b/bundle sh .bioai/update.sh; echo "exit $?"
BioAI coach folder: updated to version b58012393405. This copy writes its own reviewers.
Read .bioai/rules.md now, all of it, before you reply.
exit 0

$ ls .claude/agents
adherence.md
nutrition.md
recovery.md
red-team.md
strength.md

$ cat .claude/agents/nutrition.md
---
name: nutrition
description: Reviews a staged plan change that touches calories, macros, meal structure or the rate of weight change, and helps the coach design a nutrition target before it is proposed. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_target_figures, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_target_figures, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read, mcp__BioAI__get_day, mcp__claude_ai_BioAI__get_day
---

Before anything else, read `.bioai/reviewers/nutrition.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The nutrition reviewer's instructions are missing." Do nothing else.

$ git status --short
?? .proof/

```

## 7.

```
$ BIOAI_COACH_BASE=https://raw.githubusercontent.com/brandallux-bit/sync-proof-delete-me/source-c/bundle sh .bioai/update.sh; echo "exit $?"
BioAI coach folder: couldn't be updated (a reviewer asks for more than it may), so nothing was changed; still using version b58012393405. This copy writes its own reviewers.
Read .bioai/rules.md now, all of it, before you reply.
exit 0

$ ls .claude/agents
adherence.md
nutrition.md
recovery.md
red-team.md
strength.md

$ grep -c log_meal .claude/agents/*.md
.claude/agents/adherence.md:0
.claude/agents/nutrition.md:0
.claude/agents/recovery.md:0
.claude/agents/red-team.md:0
.claude/agents/strength.md:0

$ cat .claude/agents/strength.md
---
name: strength
description: Reviews a staged plan change that touches the training program, exercise selection, volume, progression or a deload, and helps the coach design a new training block. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_progressions, mcp__claude_ai_BioAI__report_lifts, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_progressions, mcp__BioAI__report_lifts, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/strength.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The strength reviewer's instructions are missing." Do nothing else.

```

## 8.

```
$ BIOAI_COACH_BASE=https://raw.githubusercontent.com/brandallux-bit/sync-proof-delete-me/source-d/bundle sh .bioai/update.sh; echo "exit $?"
BioAI coach folder: version b58012393405, already current. The reviewers' list is newer than this copy, so its reviewers were left as they are.
Read .bioai/rules.md now, all of it, before you reply.
exit 0

$ ls .claude/agents
adherence.md
nutrition.md
recovery.md
red-team.md
strength.md

$ cat .bioai/AGENTS
format 1
version b58012393405
b3c6e27795ef5971d692f3f0d6fa8a354383ba5f505386eb424b3f46dce4a4d6  agent-specs/adherence.txt
6a62c96ca8cdb3774530ad298972897a62e2cf382a4580c9cf978a58d3ef750c  agent-specs/nutrition.txt
fea9036657702bad93dec191a586853947954db7a09b2d52f8db27482c406af0  agent-specs/recovery.txt
a431d0f1e05aff7a4203b2d3c2a12958529aa9e2a6e79c2a12db59b1dd843f5a  agent-specs/red-team.txt
51d642f39f90091567b7df2f91749396dc9e2b3187beb69b19a62737da67d58b  agent-specs/strength.txt
end 5

```

## 9.

```
$ rm -rf .claude/agents

$ BIOAI_COACH_BASE=https://raw.githubusercontent.com/brandallux-bit/sync-proof-delete-me/source-d/bundle sh .bioai/update.sh; echo "exit $?"
BioAI coach folder: version b58012393405, already current. The reviewers' list is newer than this copy, so its reviewers came from the copy that came with the folder.
Read .bioai/rules.md now, all of it, before you reply.
exit 0

$ ls .claude/agents
adherence.md
nutrition.md
recovery.md
red-team.md
specialist.md
strength.md

$ cat .claude/agents/nutrition.md
---
name: nutrition
description: Reviews a staged plan change that touches calories, macros, meal structure or the rate of weight change, and helps the coach design a nutrition target before it is proposed. The coach runs it once per proposal, before showing the change to the person.
model: sonnet
tools: mcp__claude_ai_BioAI__get_summary, mcp__claude_ai_BioAI__get_chart_section, mcp__claude_ai_BioAI__get_document, mcp__claude_ai_BioAI__get_history, mcp__claude_ai_BioAI__get_recent_training, mcp__claude_ai_BioAI__get_findings, mcp__claude_ai_BioAI__report_today, mcp__claude_ai_BioAI__report_progress, mcp__claude_ai_BioAI__report_history, mcp__claude_ai_BioAI__report_week_ahead, mcp__claude_ai_BioAI__report_week_review, mcp__claude_ai_BioAI__get_target_figures, mcp__claude_ai_BioAI__get_labs, mcp__claude_ai_BioAI__get_specialist_brief, mcp__BioAI__get_summary, mcp__BioAI__get_chart_section, mcp__BioAI__get_document, mcp__BioAI__get_history, mcp__BioAI__get_recent_training, mcp__BioAI__get_findings, mcp__BioAI__report_today, mcp__BioAI__report_progress, mcp__BioAI__report_history, mcp__BioAI__report_week_ahead, mcp__BioAI__report_week_review, mcp__BioAI__get_target_figures, mcp__BioAI__get_labs, mcp__BioAI__get_specialist_brief, Read
---

Before anything else, read `.bioai/reviewers/nutrition.md` in this folder, all of it, and follow it as your instructions.

If that file is missing, reply only: "The nutrition reviewer's instructions are missing." Do nothing else.

```

## 10.

```
$ sh .bioai/update.sh; echo "exit $?"
BioAI coach folder: updated to version b58012393405. This copy writes its own reviewers.
Read .bioai/rules.md now, all of it, before you reply.
exit 0

$ ls .claude/agents
adherence.md
nutrition.md
recovery.md
red-team.md
specialist.md
strength.md

$ cat .bioai/AGENTS
format 1
version b58012393405
b3c6e27795ef5971d692f3f0d6fa8a354383ba5f505386eb424b3f46dce4a4d6  agent-specs/adherence.txt
22abd6ace6a677afe3b85d3df9f991266d92cb00c752542981bf1f8f9cefd514  agent-specs/nutrition.txt
fea9036657702bad93dec191a586853947954db7a09b2d52f8db27482c406af0  agent-specs/recovery.txt
a431d0f1e05aff7a4203b2d3c2a12958529aa9e2a6e79c2a12db59b1dd843f5a  agent-specs/red-team.txt
42019eefffd5a5406a25ec4a358af6aab7064cfcb53cfb315730d55f4a13c546  agent-specs/specialist.txt
51d642f39f90091567b7df2f91749396dc9e2b3187beb69b19a62737da67d58b  agent-specs/strength.txt
end 6

$ git status --short
?? .proof/

```

