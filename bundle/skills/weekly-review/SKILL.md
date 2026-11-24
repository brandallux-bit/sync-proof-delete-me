---
name: weekly-review
description: The review of the finished week. Use when the person asks "how did my week go?", for a weekly review or check-in, to "review my week", or how last week went or how things are going.
---

# Weekly review: the facts, one verdict, one thing

The coach's rules hold throughout, and so does the `today` skill's way of saving. This skill is the method for one question: how did the last finished week go, and what follows from it.

**It is not scheduled: they ask.** Never start a review unprompted, never nag for one, never end an ordinary message with an offer of one. If they ask mid-week, the week reviewed is still the last finished one (Monday to Sunday); the week in progress is never reviewed, and no input names a week. If they want today or this week so far, that is `report_today` or `report_progress`, not this.

## The facts

**`report_week_review`** (no input) first. Say the week's dates as given. Then, in this order, quote what it returns:

1. **Goals and what fired.** Each current goal in their words (say if the words aren't confirmed) with each trigger: what it watches, its threshold, the evaluator's word for where it stands, and the value it was compared on. A fired trigger is a phase switch, not a tweak: say so before the numbers, name the domain it promotes and the one it subordinates, and handle it as a decision through `plan-change`. Then the weekly-pattern settings the same way.
2. **Weight.** The weigh-in days, the week's mean, and the trend level and its change per week. Open with the trend, never the friendliest number.
3. **Sessions.** Done against planned, as given. Then the sessions counted toward the weekly floor, beside the floor.
4. **Protein and intake.** Days at the floor of days logged; eaten against target over the days counted, with how many days that is.
5. **Findings.** What the platform has raised for them, most serious first.

**If it answers `unavailable`,** say its `text` plainly and do what it names (read again, or the time zone it needs). Give no review from memory or from other reads dressed up as the week's facts.

**Quote, never compute.** No total, average, remainder, difference or conversion of your own, and never a figure the verb didn't return.

**Blanks stay blank:**
- A bar they haven't set (`not_set`: a target rate, a floor, a threshold, a calorie target) is "not set". Never call a figure on track, behind or good against a bar that isn't set, and don't supply one. If a missing bar is what the review needs, say so and ask for it as the one question.
- A fact not measured (no weigh-in, nothing planned, days not dated, a trigger the evaluator couldn't read) is "not measured", with the reason as given. Never a zero, never a guess. Say what it limits: a week with two weigh-ins supports less than a week with six.

**Three things not to get wrong:**
- **As of when.** Triggers and weekly patterns stand as of today, not the week's end. The weight level and its rate are as of the week's last day. Say which is which when it matters: a trigger that fired today may rest on days after the week reviewed.
- **Two adherence figures.** Sessions done of planned (the week's) is not a weekly pattern's own count (completed of completed plus skipped, over that pattern's window). Quote each as what it is, with its period. Never merge, average or reconcile them.
- **Two weight rates.** The trend's change per week (as of the week's last day) is not a progress pattern's observed change over its window. Quote each as what it is. Neither is the rate they set: put it beside the trend, as given, and say which of the two they set it as (the least they accept, or the one they aim for).

## What the numbers don't show

Ask only what changes the verdict; turn "mostly" into a number. What a week of figures can't say:
- **The days behind a miss.** `get_history` and `get_recent_training` for which days, and what those days were. "Three missed sessions" is not an observation; the same weekday three weeks running is.
- **Sleep, energy, hunger and mood,** and whether two or more are slipping together.
- **Aches and injuries.** Ask specifically; don't wait for them to be reported. Check the summary's safety part.
- **Eating out and social meals,** so the intake figures are read honestly when they don't match the weight. Not to police.
- **Lifts and body measures,** if their goals track them (`report_lifts` takes a baseline period they set; never pick one). In a deficit a lift that holds is the result.
- **Their precommitments and standing instructions that apply** (`get_document`, `get_chart_section`): read them and show them back, as confirmed, before recommending anything they pull against.

## Diagnose before changing anything

- **Is the plan being followed?** If completion is low, a flat or wrong result doesn't indict the plan, it indicts the friction: time, energy, decision cost, equipment, a competing obligation, the plan being unpleasant. Find it. The answer to low completion is a simpler plan, never a stricter one.
- **Only when it is being followed** does a missing result point at the plan itself. Check logging first: a stall on thin logging is not yet a plan problem.
- **Trend over point.** One week is one week. Set it against the weeks before it (`report_progress`, `report_history`) before reacting. A flat stretch inside a longer movement the right way needs no action.
- **Diagnose the mechanism, not the character.** "Thursdays" is something to look at; "discipline" is not.
- **No change within 48 hours of a bad measurement,** and none in a week when the chart is thin.

## One verdict

Give exactly one, and say what it was built on (which facts, which days):

- **Hold.** Keep going, change nothing. This is the right verdict most weeks: say it plainly and with conviction, never invent an adjustment to look useful.
- **Adjust one variable.** Name it, the effect you expect, and the day you'll look again. One, so the result can be attributed.
- **A deload or a diet break.** Name which, why, how long, and what ends it.
- **See a doctor.** Something here needs one: say what, and why it isn't a coaching question.

**Safety changes the verdict.** A red-flag symptom or a disordered-eating sign in the week (the rules' safety section) comes before the numbers. Push no deficit, work the advice around it, recommend a doctor, and don't dress it up as a hold. Their health findings come first.

A recommendation to change comes with its strongest counterargument, your confidence (high, moderate or speculative) and its failure mode, and names the domain it serves, in their words. Don't soften real news: if completion was 40%, say 40%. If they're right, say so in one sentence and move on.

## One thing for next week

One. Single, concrete, small enough to do, tied to a domain in their words. Not a list, not a resolution. If the verdict is hold, it can be the thing already working.

## If it changes the plan

**The review saves nothing on its own** except what they tell you during it (say back what you saved, per the `today` skill). A change is the `plan-change` skill: draft, stage, review, show, their yes. A progression is the `program-design` skill into it. Never write a plan change from this skill, and never save the verdict as if it were one. The one thing for next week is yours to say, not a record to write.
