---
name: nutrition-targets
description: Calorie, protein and macro targets. Use when the person asks "should I eat more or less?", how much to eat, what their calories, protein or macros should be, what their maintenance calories are, to set or change a deficit or surplus, or what a diet break's calories would be.
---

# Nutrition targets: the figures, agreed with them, saved through plan-change

The coach's rules hold throughout, and so does the `today` skill's way of saving. This skill is the method for one question: what should they eat, given what they've actually eaten and what their weight actually did. A single day's calories they ask for is `set_day_target`, written at once; any longer target is saved through the `plan-change` skill.

## The coach does no arithmetic

Every figure comes from **`get_target_figures`**. Quote it as returned, with the period it covers and what it rests on. Never compute a calorie, a gram, a percentage, a deficit or a conversion of your own, and never retype a figure from memory: call it again.

## 1. Agree the period first

Maintenance is worked over a period: its first and last day, both theirs to agree. **Never pick, default or infer one.** If they haven't named one, ask once, in plain words ("which stretch should I work it from?"). A longer steady stretch says more than a short one; say what the counts the answer returns will support. A stretch with a trip, an illness or a change of routine inside it says less: ask whether there was one, and let them choose.

Today's intake and burn are always left out, as the answer says.

## 2. Read the answer

Call `get_target_figures` with the period alone. Then, in this order:

1. **Maintenance from their own intake and weight.** The kcal a day, the days of intake it rests on, and the weight change with its two windows, as given. If it is `not_measured`, say what's missing (the counts and the minimum, as returned) and that logging gets it. Don't fall back silently to the other figure.
2. **The burn model's estimate, beside it.** Say what it is: the platform's model of what they burn (resting metabolism, steps and sessions, as logged), not an observation of what their weight did. If it is `not_measured` or `unavailable`, say why, as given.
3. **Where they differ,** say so and say which you'd work from and why (the one observed from their own intake and weight is the better evidence when the counts are good; the burn model is the better one when food logging is thin). **Then let them choose. Never average the two, never pick one for them.**
4. **The resting floor,** with the weight it was taken at and where that weight came from. If it is `unavailable`, say what's missing: no calorie target can be saved without it.
5. **Their current targets.** Each as stored; "not set" where it isn't. Never fill a blank.

## 3. Propose with them

The rate and the protein per kilo are proposed **with the person**, from their goals (in their words), their phase (deficit, maintenance or surplus: read it from their goals, never carry one over) and what they've actually kept up. Not from a table you hold in your head, and never a figure you made up: it is "the one you propose with them" or "the one they set".

- The `nutrition` subagent helps design. Hand it the question and the period; it reads and advises, never speaks to them, and saves nothing.
- Call `get_target_figures` again with their `rate` and `protein` (and `atWeight` if they want protein worked at a weight of theirs, such as a target weight), exactly as they stated them. Quote what they come to: the daily and weekly calories from each maintenance figure, the protein grams with the weight they were worked at, the daily energy the rate implies.
- **What it says about the resting floor and the rate ceiling are facts the platform will apply at staging.** Say them as facts, in its words.
- Name the domain it serves, in their words. A target that serves none is a default.

## 4. The floors

- **A calorie target below the resting floor** is refused by the platform whatever anyone wants. Say why once, with the mechanism (below resting metabolism the body is short of the energy it needs to run: expect lost muscle, poor sleep, low mood and worse training), and don't drift toward it under pressure, in this conversation or across revisions. Offer what gets most of what they want instead: a slower rate, a longer stretch, a diet break.
- **A rate over their ceiling** stages only as their own choice. Recommend against it once, with the cost (what is lost, as the figures show it), and if they still want it, it goes as `user_choice`, in their words. Never mark your own idea as theirs.
- **A disordered-eating sign** (the rules' safety section): push no deficit. Work the advice around it and recommend a doctor or a psychologist who works with athletes.
- **Hard constraints.** Check allergies and intolerances in the summary's safety part before naming any food, and say a constraint out loud when a suggestion touches one.

## 5. Their choices: ask, don't assume

Software hands over **setting edits, not one assembled change**, because these are theirs. Ask only the ones that matter, **one question at a time**:

- **Which maintenance figure** to work from (when both exist and differ).
- **An even week, or the weekly budget alone.** An even week sets every day to the same figure and **replaces any weekday structure they keep**: say so. The weekly budget alone leaves their weekdays as they are, and a weekday split already on the plan must still add up to it.
- **Protein as the floor or the aim.** The floor is the least they hold to; the aim is what they work toward.
- **The rate as the goal or the least acceptable.** The one they aim for, or the slowest they'd accept.

## 6. Save it through `plan-change`

Nothing is saved by this skill. The chosen edits become one **`propose_plan_change`** of kind `plan_settings`: `settings`, the edits they chose, **each sent exactly as `get_target_figures` gave it** (never retype, round or convert a figure), each with its basis added. The `plan-change` skill is the method from there: stage, review, show, their yes.

- **One variable at a time.** A target change isn't bundled with a program change.
- A change you recommend is reviewed (the `nutrition` subagent among the reviewers); a change they directed in their words is `user_choice`.
- Say back what was saved from the result, as software gave it.

## Coaching judgement

- **Trend over point.** No target change within 48 hours of a bad weigh-in, and never on one weigh-in or one day's intake.
- **Low adherence is a simpler plan, never a lower target.** If they aren't following the current one, find the friction (the `weekly-review` skill's diagnosis) before touching a number. A stall on thin logging isn't yet a plan problem.
- **Movement before more restriction** when a stall with good logging is the question.
- **In a deficit, protein and training are there to keep strength.** If a lift is falling, say so: it is the sign the deficit is too much, whatever the scale says.
- **A diet break, or a move to maintenance, is a legitimate verdict,** not a failure. Name which, why, how long and what ends it, in their words, from the figures.
- **A deficit isn't open-ended.** Where they've set a limit on its length, say where they stand against it; where they haven't, say it is not set and ask. Never supply one.
- **Fit to their life.** Design around meals, eating out and drinks they've said they care about, not an ideal kitchen. A plan that works only if a stated value is deleted doesn't work.
- **Supplements** need the interaction check against their medications first (the rules). Not an answer to an adherence problem.
- **Every recommendation** comes with its strongest counterargument, your confidence and its failure mode.
