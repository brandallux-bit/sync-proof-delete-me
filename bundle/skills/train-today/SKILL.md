---
name: train-today
description: What to train today. Use when the person asks what they should train, what today's session is, whether to train today, whether to keep, change or skip a planned session, or says they feel tired, sore or slept badly before a session.
---

# Train today: keep, adapt or replace

The coach's rules hold throughout, and so does the `today` skill's way of logging. This skill is the method for one question: what should they train today, given what they actually did lately.

## The evidence

1. **`get_recent_training`** (3 days by default): the last days' sessions and sets, the loading streak, and each of today's planned sessions' overlap with that recent work.
2. **`get_day`** for `{ "relative": "today" }`: today's planned sessions, and last night's sleep if it's logged.
3. **The summary's safety part** (injuries, constraints, conditions): it's already in context from `get_summary`; read it again only if it may have changed.

- **Set rows are the evidence of what was done.** A planned session is not evidence: a day planned and not logged tells you nothing about the work.
- **Quote the figures as returned.** The overlap and the streak are software's: never count, compare or compute them yourself.

## One verdict

Give exactly one, and say what it was built against (which days, which overlap, which injury or night):

- **Keep:** no repeat of recent work, and they're recovered. Do today's session as planned.
- **Adapt:** a partial repeat, or fatigue. Swap the repeated items and say which, and for what.
- **Replace:** a full repeat, or the recent days went somewhere else entirely. Say what goes in its place.

"Nothing today" is a legitimate answer when it's the right one.

## What changes the verdict, in this order

1. **An injury or a constraint** outranks everything. Work around it and say why.
2. **Repeating work done in the last two days.**
3. **Several loading days in a row** (the streak, as returned).
4. **A hard marker set yesterday on the same movement pattern.**
5. **A bad night:** choose the easiest option on offer. Don't cancel the day.
6. **What they want today.** Last, and still counted: a worse session they'll do beats a better one they won't.

## After the verdict

- **An adapted or replaced session is written, not just advised:** `change_planned_day` (the `plan-change` skill says how), so Today on the dashboard shows it. Say it back from the result. "Move today's session to tomorrow" and "swap Friday's run for a walk" go the same way. A day change runs no review. Keep, with nothing to write, is advice in words.
- **When they've trained, log what they did** with `log_session` (and `replaces` or `plannedWorkout`, as the `today` skill says), so the chart holds what happened, not what was advised.
- **Name the domain the session serves** when it isn't obvious (the rules): which of their goals, in their words.
