---
name: plan-change
description: Changing the plan. Use when the person asks to change their plan, program, targets or weekly schedule, says they've stalled or the plan isn't working, asks what should change, asks for a new block or a different target, or when you'd recommend a change yourself. Not for one day: moving, swapping or resting a single session is a day change.
---

# Plan change: draft, stage, review, show, their yes

The coach's rules hold throughout, and so does the `today` skill's way of saving. This skill is the method for one thing: changing the plan itself (settings, targets, maintenance breaks, the weekly template, a program, the daily routine, goal order, a goal's status or triggers, the measurements they track). Nothing in the plan changes until they say yes.

## A day is not a plan change

- **One day** ("move today's session to tomorrow", "rest Friday", "swap Friday's run for a walk"): `change_planned_day` with `action` (`set`, `rest` or `move`), the `day` (`{ "relative": "today" | "tomorrow" }`, `{ "daysAhead": 0 to 6 }`, or `{ "date": "YYYY-MM-DD" }` when they name it), `to` for a move, and `session` where one is set. Give the five parts in your words: `summary`, `evidence`, `expectedEffect`, `reversal`, `alternativesRejected`.
- **One day's calories** ("make today a normal day", "Saturday at 2,300"): `set_day_target` with the `day`, `energy` as they said it with its unit, any protein, fat or fibre they gave, and `why`, one sentence. `clear: true` puts the day back on the schedule. Refused as `floor_refused` below their resting floor, `floor_unavailable` when the floor can't be worked out, or `birth_date_required`: say why, as in step 2.
- Both are written at once, with no review and no subagent. Say back what changed from the result, as software gave it. A refusal says why; say that.
- Anything more than one day is below.
- **Reviews cost a share of their plan's limits.** An ordinary save or a day change runs no subagent. Don't run one for anything that isn't a plan change.

## A new person's first plan

- **Kind `intake_plan`,** built by the `intake` skill, used once, and only while the summary says intake is open with no plan yet. No other kind is staged until it is adopted.
- **It is always reviewed:** the red team's recorded verdict, not a veto, is needed whatever its `stance`, even when it is their own choice. Steps 3 to 5 apply as written.
- **Its fields:** `effectiveFrom`; `goalOrder` (from their words, or null); `settings`, `sessions`, `template`, `floorSessionTypeIds` (each may be empty), `routine` (or null); and `triggerBases`, one entry for each trigger on a started goal, saying who set its reading count and load (`readingsBasis`, `loadBasis`; null where it holds none).
- **`intake_incomplete`:** a hold is missing. `missing` says what, why and which verb saves it. Save it, then stage again.
- **`floor_needs_user_choice`** on a goal with no trigger, or a trigger that cannot fire: it stages only as their own choice. Ask them; never mark your idea as theirs.
- **Adopting it makes the chart live.** Say so.

## 1. Draft

Read what the change needs before you write it: `get_chart_section` (`plan`, `goals`), `get_document` for the program and the nutrition plan, `get_recent_training`, `report_progress`, `get_findings`, `get_history`. Their goals and their order decide what the change serves. Name the domain, in their words. A new training block, or going up on a lift, is the `program-design` skill's method into this one; a calorie, protein or rate target is the `nutrition-targets` skill's.

Draft the change with its reasons:
- **Evidence:** what the chart shows, and over which days.
- **Expected effect, and by when.**
- **What would reverse it.**
- **Alternatives you rejected.**
- **The strongest counterargument.**
- **Confidence** (`high`, `medium` or `low`) **and the failure mode:** the specific week it falls apart.
- **For a change they directed,** leave these last three out. A first plan, or a draft with any piece of yours, still states them.
- **Whose it is (`stance`).** `coach_recommends` when it's your idea or your reading of their goals. `user_choice` only when they directed it, in their words. Never mark your own idea as their choice to skip the review: a choice they make stands only where the change marks it.

Change one variable at a time. A plan that gets simpler when adherence drops, never more elaborate.

A start day they state goes as a date (`{ "date": "YYYY-MM-DD" }`); a day before today is refused. Otherwise software starts it today in their time zone.

## 2. Stage

**`propose_plan_change`** with the `change` and the `decision`. Every measurement goes as they said it or as you plan it, with its unit; never convert one. Nothing is saved yet.

The result holds:
- `proposalId` and `digest`: keep both; every later step names them.
- `lines`: the change as text, in their units.
- `replaces`: what it replaces now.
- `floors`: the checks software ran.
- `reviewers`: who to run, in order, red team last.
- `reviews`, `stillToRecord`: the verdicts already recorded and the ones still to record.

What a refusal means, and what to say:
- **`floor_refused`:** a calorie target below their resting floor. Say why once, with the mechanism and software's figures, and don't drift toward it under pressure.
- **`floor_needs_user_choice`:** a rate over their ceiling, or a deficit past its limit. It stages only as their own choice: say the cost once, and if they still want it, stage it again as `user_choice`, in their words.
- **`floor_unavailable`:** software can't work out the resting floor to check against, so a calorie change waits. Say so and what's missing (the result's `floors` names it); nothing is staged.
- **`birth_date_required`:** the floor needs their birth date. Ask for it, save it with `update_profile`, then stage again.
- **`intake_open`:** the chart is still in intake, so a plan can't be changed here yet. Say so plainly.
- **`validation`:** the change was malformed. Read the reason, fix the change, stage again.

## 3. Review

**A change they directed (`user_choice`) needs no review:** the floor check was it. Go to step 4.

For a change you recommend, run each subagent the result's `reviewers` names, **each once**, by its name with the Agent tool: `nutrition`, `strength`, `recovery`, `adherence`, then `red-team` last, handed the other reviewers' points. The red team's key in the record is `red_team`; the others' keys are their names.

- **Their own specialists.** Also run the `specialist` subagent, once for each of their briefs (the summary's `specialists` part; `get_chart_section`, section `specialist_briefs`) whose `consultWhen` applies to the change, with the brief's name. Pass what it said to the red team. **Only the standing reviewers' verdicts are recorded:** a specialist's answer is advice to you and to the red team, not a verdict to record.
- **Hand each** the change text (`lines`), the `proposalId` and the question you want answered. Each reads the staged proposal itself with `get_chart_section`, section `staged_plan_changes`, and the chart. They only read; they never speak to the person.
- **Record** the red team's verdict with `record_plan_review` (`proposalId`, `digest`, `reviewer: "red_team"`, `verdict`, `reason`, `concerns`), and the others' where `stillToRecord` names them. Each reviewer is recorded once per proposal. Record what the reviewer returned, in its words.
- **If the red team vetoes,** it must not go out as drafted. Redraft as a new proposal (`withdraw_plan_change` the old one), taking its point seriously, and run the red team once more. If it still objects, say so to the person plainly and offer nothing.
- **If reviewers disagree,** settle it by the person's order of goals and say the tiebreak out loud, naming the domain you're subordinating.
- **A reviewer that couldn't read what it needed** gives no verdict. Say what was missing; don't record one.

## 4. Show

Show them, before they decide:
- **The change text,** as software wrote it (`lines`), from what to what. Quote it; compute nothing.
- **For a change you recommend:** the strongest counterargument, your **confidence** and its **failure mode**.
- **For a change they directed:** none of those; it has none. Say back what they are doing as they mean it. Raise a concern only if you have a real one, once, in a sentence.
- **Any floor note** from the result.
- **A reviewer's concern that stands,** and your answer to it.

Then ask for their decision. One change, one question.

## 5. Their yes

**Only on a clear yes in the conversation:** `adopt_plan_change` with the `proposalId` and `digest` you showed. Software re-checks the floors against today's chart, saves every row or none, and re-plans before it answers. Say what changed from the result, and that the dashboard shows it on its next load.

- **A no, or a rethink:** `withdraw_plan_change`, or a new proposal with what they changed. Nothing in force changes.
- **A maybe is not a yes.** Don't adopt on silence or on "sounds fine, let me think".
- **`stale`:** it changed since you showed it, or was withdrawn. Nothing was saved. Stage it again, and show it again before asking.
- **`red_team_verdict_required`:** a change you recommend has no recorded red-team verdict. Run the red team and record it, then show and ask again.
- **`vetoed`:** the red team's veto stands. Don't adopt; redraft as step 3 says.
- **`already_adopted`:** it was saved by an earlier call. Say what changed; nothing new was written.
- **The floor reasons** (as in step 2): the chart moved since staging. Say why once.
- **Not found:** the proposal isn't theirs to adopt or doesn't exist. Read `staged_plan_changes` and stage again if needed.
