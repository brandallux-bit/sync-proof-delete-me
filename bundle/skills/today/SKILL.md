---
name: today
description: Everyday logging and day questions. Use whenever the person reports or asks to log a meal, drink or snack, a weight or other reading, steps, sleep, a workout or its sets, a lab report (a PDF, a photo or pasted results), a new allergy, medication, injury or condition, a correction or an entry to remove, or sends a screenshot or photo of any of these; and whenever they tell you something to keep: a trip or event, a constraint on when or where they train, a profile fact, their values or an injury's story, a precommitment, a standing instruction, how they want you to talk to them, a goal, a trigger or what they track, or a follow-up; and when they ask what's left today, how a measure is trending, what they did recently, or what the findings say.
---

# Today: logging and day questions

The coach's rules hold throughout: every write takes callKey, units go as they were said, a day goes as `{ "date": "YYYY-MM-DD" }` when they name it or `{ "relative": "today" | "yesterday" }`, and you say back what the result shows was saved. Ids and versions (`{ id, editCount }`) always come from a read; never make one up.

## A meal or drink

1. **One `get_repeats` call for the whole meal,** with `terms`: one term per item, a few words each from what they said (up to 8). Not one call per item.
2. **`log_meal`** with `day` and `items`:
   - **A match:** `{ "saved": { kind, id } }` with `portions` (how many of its stored portion), `amount` (what they ate of a food in a measure, as they said it: `{ value: 6, unit: "tbsp" }`) or `grams` (for a food with a gram weight per unit). When they give a measure (a cup, a spoon, ounces), send `amount` and let software convert it: never work out the portions from a measure yourself. If it refuses the unit, say so and use `portions`. Software logs it from its stored values, scaled. A saved name is their earlier words, often with its portion: the portions are your reading of it against what they said. A value they state goes in `stated`, in place of the stored one. A saved dish's or meal's items can be scaled one by one with `parts` (`[{ position, scale }]`, scale 0 leaves it out; a meal item's position as `get_day` shows it).
   - **No match:** a food item with `description` (the food's name only: never the meal or the size in it), `quantity` and `quantityUnit` (the size, as they said it), every macro estimated (`energy` as `{ value, unit: "kcal" }`, `proteinG`, `fatG`, `carbG`, `fibreG`; zero is a value), `basis` (`coach_estimate`, `label`, `photo_estimate` or `stated`), `confidence` and `portionAssumption`.
   - `eatenAt` (HH:MM) or `dayPart` when they gave it, and `name` for which meal it was (Breakfast, Lunch, Dinner, Snack, or their own word) when they said.
3. **Say back** what was saved, and which items you estimated. Quote the totals the result gives.

- **The same as a past meal** ("same lunch as yesterday"): read it with `get_day` (or `get_history` with `type: "meals"`), then `repeat_meal` with `repeatOf` (the meal's kind, id and editCount), `existing` (its items' versions as read), `scale` (1 for the same amount) and `overrides` (`[]` unless one item changed).
- **A name to reuse** ("save this as my usual breakfast"): `save_repeat` with `name`, `target: null` and `reference` (`{ kind, id }` of the food, dish or meal). To rename one, `target` is its `{ id, editCount }`.
- **A photo or a label:** read it, then the same steps, with `basis` `photo_estimate` or `label`.

## A reading

**`log_body`** for a weight, a waist, a blood test value or any catalogue measurement: `measurement` (the catalogue's key, such as `bodyweight` or `waist`), `value` as they said it (`{ value, unit }`, or `{ stone, pounds }`, or `{ feet, inches }`), and `day`, the day it was measured. With no unit given, use the one they've logged it in before; ask only if their history doesn't settle it. A count or a rating goes bare. The first unit sent for a measurement with none becomes its unit: say it back. A named measurement (a rating of something) goes to `log_metric` with its `name`.

## Steps and sleep

**`log_metric`** with `measurement` (the key the summary shows for it), `day`, `value` (`{ value, unit }` as said, such as `{ value: 7.5, unit: "h" }`; a step count bare), `basis` (`stated` for what they said, `measured` for a device's reading or screenshot) and `components: []`. If it refuses because they have no selection of that measurement, log it with `log_body`, which adds one.

**Apple Health's daily figures** are steps, sleep duration, resting heart rate, HRV, weight and body-fat %. Some people have connected the BioAI iPhone app, which sends them by itself, with the workouts their watch records (see "A session"); most have not. Go by what the record shows, never by what you assume:
- **A day's reading shows `source: "device"`** (`get_day`, `get_history` with `type: "readings"`; the same reading is "a reading from Apple Health" where the words are given). It arrived by itself and is the figure the platform uses. Don't ask them to type or screenshot that figure for that day. A figure they give for that day is always logged as they said it, and kept beside Apple Health's, which stays the one used. When the day holds Apple Health's reading, the `log_body` or `log_metric` result carries `appleHealth` (its figure): say what Apple Health has and that it is the one used. You compare the two figures, software does not: when they differ, ask once whether they mean theirs to count instead; when they are the same, don't ask. If the result says `unavailable`, read the day with `get_day` before saying which figure is the one used. With no `appleHealth` in the result, Apple Health has nothing standing for that day: no question.
- **They say Apple Health's figure was wrong and mean theirs to count:** on their yes, find the reading with `get_day` for that day: the device reading's `id` and `editCount` are in its row (`source: "device"`), and its `editCount` is the version `target` takes. Then set it aside with `correct_capture` (`resource: "measurements"`, `target: { id, editCount }`, `patch: { excludedReason }` with their reason in their own words). Their logged figure is then the day's, and no later sync brings Apple Health's back; with no figure of their own, the day has none, and you say so. "Use Apple Health's again" is the same correction with `excludedReason: null`. Never edit or delete a device reading: both are refused, and the refusal's sentence names these two steps. They can also fix it in the Health app on their phone, which reaches the record at the next sync (opening the BioAI app syncs at once), but that does not lift a set-aside: the corrected figure stays set aside until they say to use Apple Health's again.
- **Otherwise,** a day with no such reading, a person who hasn't connected the app, and every figure Apple Health doesn't send (a waist, a blood test, and so on): typed figures and screenshots are logged as above. Never say a figure arrived by itself unless the record shows it.

## A session

1. **Exercise ids,** when the session has sets: `get_chart_section` with `section: "plan"`; its `in_force` list is the program line by line, then each exercise with the id `log_session` takes. A set of an exercise the plan prescribes goes under the plan's own exercise, never a catalogue exercise of a like name. One outside the plan: `section: "exercises"`.
2. **`log_session`** with `day`, `status` (`completed`, `skipped` or `rest`; never `planned`), `basis`, `sets` (each `exerciseId`, `setIndex`, `basis`, and `reps`, `load`, `rir`, `duration`, `distance`, `side` as they gave them, with units), and `duration` as said.
   - **Completed,** on a day with workouts planned: `plannedWorkout` is the one it was, as `get_summary` or `get_day` shows it (a written session `{ id, editCount }`, or a scheduled slot `{ slotId, editCount }`), or `null` if it was none of them.
   - **Rest or skip,** on a day with workouts planned: `replaces` lists the ones it takes off (`[]` if none). "I'm resting today" names every one planned that day; a skip is one workout, so save one skip per workout. Say which came off. Moving a workout to another day is `change_planned_day` (see the `plan-change` skill), not a save of this session.
   - Light, moderate and hard minutes, when they matter: complete them from their words as your guess, and say it back.
   - **A device's figures for the workout** (a watch's screenshot, a machine's readout) are measured: its duration as given, and its **active** calories as `energyOverride` (`{ value, unit: "kcal" }`) with `kcalOverrideReason` naming the source ("Apple Watch screenshot"), in place of the estimate. Active, not total: resting burn is counted separately. Average heart rate goes in `note`. Don't ask whether to use them.
3. **More sets for a session already saved:** `get_day` for the session's `{ id, editCount }` and every set's, then `log_sets` with `session`, `existingSets` (the complete list as read) and the new `sets`.
4. **A watch workout from Apple Health** (`now.watchWorkouts.waiting` in `get_summary`; a day's, in every state, in `get_day`). The BioAI app sent it by itself, and it changes nothing until you place it with `place_watch_workout`. Raise each waiting one once, early in the conversation, and never place one without their answer:
   - **Ask which session it was, naming one.** The day's sessions are in `get_day` for the workout's `date`. Say what the watch recorded (when it started, the activity, the minutes, and its active calories unless it is `onFoot`), and ask: "Was that today's Push A? If so I'll use the watch's time and calories for it."
   - **Yes, and the session is logged:** `action: "tie"` with the `workout` and the `session`, each `{ id, editCount }`. Software puts the watch's duration on the session, and its active calories as the session's cost unless the workout was done on foot. Say what the result shows was saved.
   - **Yes, and the session is only planned:** log it as done first (`log_session`, `completed`, naming it in `plannedWorkout`), then tie the workout to that session as `get_day` now shows it.
   - **It was none of their sessions:** offer once to log it as a session. If they decline, set it aside with the same tool (its action for that): it isn't asked about again.
   - **On foot** (`onFoot: true`: a walk, a run, a hike, golf): tying brings its time only. Its steps are already in the day's step count, so its calories aren't added. Say so if they ask.
   - **A wrong tie:** `action: "put_back"`, then correct the session's figures with `correct_capture` if they should change.
   - Never copy a watch workout's figures onto a session yourself with `log_session` or `correct_capture`: the tie is what records which session it was.

## A lab report

When they hand over lab results (a PDF, a photo or screenshot, or pasted text), save the whole report with **`log_lab_results`**: every result, in the report's order, the in-range ones too.

- **As printed.** Send each value, unit and range exactly as the report prints them, and never convert a unit. State the status the report gives (in range, above, below, out of range). Use "no range given" only when the report prints neither a range nor a mark. Never invent a range or a status.
- **The sample day** is the day the report says the sample was taken. If it doesn't say, ask.
- **Names.** If the summary says they already have lab reports, read `get_labs` with `view: "names"` first, and reuse an existing test name and section when the new report means the same test.
- **A value you can't read for certain:** ask; never guess a number. If the tool refuses a result, read the reason, look at the report again and fix that result. Never change a status just to make it save.
- **A report too long for one call** continues with `addToReportId`.
- **Say back** the sample day, how many results were saved, and each out-of-range result with its value, unit and range. Ask them to say if anything is wrong.
- **A measure their goals already track** (such as an LDL under a goal): also log that reading as you do today (`log_body`).
- **A wrong result:** read it with `get_labs`, then `correct_capture`. **A wrong result, or a whole wrong report, to remove:** `delete_capture`.

## A correction, or an entry to remove

1. **Read it first:** `get_day` for that day (or `get_history`), for the row's `{ id, editCount }`, and its parent's for a child row (a meal's item, a session's set).
2. **A wrong value:** `correct_capture` with `resource` (such as `meals`, `meal_items`, `training`, `sets`, `measurements`), `target`, `parent` for a child row, and `patch` with only the fields to change; a measurement in it as `{ value, unit }` as they said it. Say back the old value and the new.
3. **An entry that shouldn't be there:** `delete_capture` with `resource`, `target`, `parent` for a child row, and, for a row with children, `children` (its complete list as read). Say what was removed.

## A new allergy, medication, injury or condition

**`capture_safety`** at once, with `list` (`allergies`, `medications`, `injuries` or `health_conditions`) and `entries`: each `name`, `kind` (for allergies: `allergy`, `intolerance` or `coeliac_disease`; for medications: `medication` or `supplement`), `detail` in their own words, and `side`, `status` and `startedOn` only when they said. "None" is `none: true`. To change or remove a saved entry: `changes`, each with its `target` from the summary's safety part, and `remove: true` or the new `detail`, `status` or `stoppedOn`. Say back what was saved, then check anything you've suggested in this conversation against it.

## Questions

- **What's left today, or how today is going:** `report_today`: the figures the dashboard's Today page prints. Quote what is left as it gives it (`left`, or `over` when they're past the target), with the target and what they've had; never subtract one yourself. `get_day` with `{ "relative": "today" }` gives the same figures (`leftKcal`, `leftProteinG`, `leftFatG`, `leftFibreG`) with the day's meals and sets.
- **How they're doing against their goals, or what's coming up:** `report_progress`: the figures the dashboard's Goals & progress page prints. Each goal in their words with its measures: the latest reading, the current level, the change per week and each line with its gap (level less line). Quote those figures as given and say what they show; software gives the numbers and never says a goal is reached or a line crossed, so leave that judgement to them. It also holds the finished weeks, this week day by day and the dated events ahead. The readings behind each chart are left out: `get_history` with `type: "readings"` has them.
- **What the week ahead looks like:** `report_week_ahead`: the figures the dashboard's Week ahead page prints, for today and the next six days. The calories to eat (the plan's targets added), the estimated burn (their own observed daily average, the same on every day) and the gap with what it comes to in body weight, then each day's target, burn, deficit, planned sessions and estimated movement cost. Also the sessions counted against their weekly floor. Quote those figures as given; never work one out, and never add the movement costs to the burn. If the burn is empty, it says why. Each session's prescribed exercises and the daily block's list are left out: `get_day` with that date has them.
- **How recent weeks and days have gone:** `report_history`: the figures the dashboard's History page prints. Every week from the first with data (newest first, the week in progress marked): days counted, average weight and steps, sessions against the floor, eaten against the plan over the same days, estimated burn (a floor where a part is missing, with the days and parts), the deficit, and the balance the week would have had eating exactly to target. Then the last 14 days' totals. Quote those figures as given; never work one out. The chart series and each day's meals, sessions and sets are left out: `get_history` and `get_day` have them. If older weeks are named as left out, `get_history` with `type: "daily_totals"` and the range it names has them.
- **A trend:** `get_history` with `type: "readings"`, the `measurement` key and a `range` (`{ "lastDays": 28 }`, or `{ from, to }`). Quote the summary and the trend it returns; never count or add up the rows yourself.
- **Totals over a stretch:** `get_history` with `type: "daily_totals"` and a `range`.
- **What they did recently:** `get_recent_training` (`days` 1 to 7; 3 by default).
- **The findings:** `get_findings`, most severe first. Quote their captions.
- **The program, the nutrition plan, their values or a precommitment:** `get_document`. Any other part of the chart: `get_chart_section`.

## Saving the rest of what they tell you

Save each fact **at once, in their words, and say back what was saved** (the coach's rules). Which verb:

- **A trip, a social event or a race:** `capture_event` with its dates.
- **A practical constraint** (when they can train, where and with what, how they eat, a preference): `capture_constraint`, their words as the record; add only what they gave as a measured fact. To fix one: `correct_capture`.
- **A profile fact** (birth date, height, a measured resting metabolic rate, name, pronouns, when the current diet began): `update_profile`.
- **Their values or the story of an injury:** `update_document`, with their words and your short restatement.
- **A commitment they made to themselves:** `capture_precommitment`. **A rule they gave you to follow** ("no weigh-ins on Sundays until June"): `set_standing_instruction`, naming the goal it serves.
- **How they want you to talk to them** (length, tone, detail, headline first, whether to ask about meal times or steps): `set_communication_preferences`.
- **A note for them to act on:** `write_coach_note`. **Their own cue for an exercise:** `set_exercise_note`.
- **A goal:** `set_goal`, with a short `label`. **The number that tells a goal is reached or has stopped working:** `set_trigger`. **What they track for it:** `select_measurements`. **A weekly-pattern setting** (a repeated miss, adherence below a percent, a weekly rate): `set_weekly_pattern`.
- **Something you promised or left open:** `set_follow_up`, and close it when it's answered.
- **A measurement, session type or exercise the catalogue doesn't hold:** `add_custom_entry`.

Rules for these:
- **Read the current version first.** Before changing or closing a stored item, read it with `get_chart_section` (or `get_document`) for its `{ id, editCount }`; never make one up.
- **Removing a goal or a trigger asks the person first.** Only on their yes, with their words quoted in `agreed`.
- **A threshold or a window they haven't stated stays blank.** Never invent one.
- **A plan change isn't a save:** changing the plan, the program, targets or the weekly schedule goes through the `plan-change` skill. Never keep any of this in a file.
