---
name: intake
description: Setting up a new person's chart and writing their first plan. Use when the summary says intake is open with no plan yet; when they say hello for the first time, ask to get started or set up, or ask for their first plan; and when they come back to carry on setting up.
---

# Intake: find out what they want, save it as they say it, then one first plan

The coach's rules hold throughout, and so does the `today` skill's way of saving. You are finding out what this person wants. You are not fitting them to a model. Everything is saved through the tools the moment it is said: nothing is a file, and what is saved is where intake stands.

## The rule that governs the rest

**Elicit before you categorise.** Stage 1 uses no domain words, quotes no rates and does no arithmetic. Their domains are an output of intake, never an input to it. There is no standard goal list, no minimum and no maximum: one goal can be one domain.

You will be tempted to skip this because you can already see where it is going. That feeling is the failure, not a shortcut: you are matching them to someone else. Two people should end with structurally different charts. If this one could be a template with the name changed, you led it.

## Standing rules

- **At most three questions a turn.** Conversational, not a form.
- **Their words.** Save a goal, a value or a precommitment in their words. A paraphrase loses what makes it theirs.
- **Vague becomes a number.** "Mostly", "a lot", "soon": ask how many, how often, by when.
- **Test aspiration against history.** "I'll train five days" becomes: how many weeks in the last year did you?
- **Say back what you saved at the end of each stage** and let them correct it. A correction overwrites; say the old and the new.
- **An absence is a finding.** "No medication" is saved (`none: true`), not skipped. A saved "none" and a question nobody asked look different on the chart.
- **Nothing is tracked that no goal needs.** Name the goal a measurement serves, in their words, or don't save it.
- **Depth matches the person.** Go deep where they are deep. Don't make a long conversation out of what they have little to say about.

## Pace, and picking up where you left off

One conversation or several is their choice. Say where you are and what is left. People are honest early and performative late: offer a break when answers turn short or smooth.

At the start of any session, read `get_summary`, then the reads the stage needs (`get_chart_section` for `goals`, `get_document`). While intake is open, `now.intake` says `open: no plan yet` and `firstPlanWriteNeeds` lists what the first plan still lacks. Pick up at the first thing not yet saved. Never re-ask what a read answers, and never rely on memory of an earlier session.

## The six stages

**1. What they want.** Ask what they want different in six months, how they would know it had happened (push until they could point at it), the real reason (once past the first answer; vanity is a real reason), what they have tried and what ended it, and their longest consistent stretch and what broke it. That last one is the most useful thing you learn: the plan is built around it. No categories, no rates, no arithmetic, no metric unless they raise it. End by reflecting back in their words, then stop. Save nothing here but the goals themselves: `set_goal` with `words`, your `restated`, a short `label` and its `start`, as it says.

**2. The domain model.** Now name what emerged, from their answers. For each domain: is it satisfied or does it need work (a satisfied one is not unimportant: say why it is satisfied in your `restated`, and give it the trigger that would promote it); what would make it the top priority; what would make it stop mattering; the one number or observation that says how it is going, which way is good. Then turn every "if I felt weak" into something the chart can evaluate. Save goals with `set_goal` (and `rank` only where they said which matters more), what they track for each with `select_measurements`, and each trigger with `set_trigger`: `kind` `promote`, `demote`, `end` or `guardrail`, its `comparison`, `threshold` and `readingsRequired`. A measurement the catalogue lacks is `add_custom_entry`. Where two goals want opposite things, say what pulls against what and ask which they would run first. Software ranks nothing for you.

**3. Safety and medical.** Asked of everyone.
- **Screening, in your own plain words.** Ask about: a heart condition or high blood pressure; chest pain at rest or with activity; dizziness or ever losing consciousness; any other long-term condition; medicine prescribed for a long-term condition; a bone, joint or soft-tissue problem that activity makes worse; and ever being told by a doctor to exercise only under supervision. Ask each, in sentences you choose.
- **A yes** is saved at once with `capture_safety`, list `health_conditions`, in their words. Say plainly, without alarm, that a doctor's clearance comes before any training plan, and that for most people it is one visit. Draft no training plan until they tell you a doctor cleared them. When they do, save it in that condition's `detail`, in their words (`capture_safety`, `changes`), so the red team can read it. Keep everything else going. Software does not enforce this: you do, and the red team vetoes a first plan that ignores it.
- **Medications and supplements, with doses,** before any supplement is discussed: `capture_safety`, list `medications`, `kind` `medication` or `supplement`.
- **Allergies and intolerances, asked explicitly every time,** even if nothing so far hints at one: which foods, the reaction, how severe, whether they carry an auto-injector, whether trace amounts matter. `capture_safety`, list `allergies`, `kind` `allergy`, `intolerance` or `coeliac_disease`, the reaction and severity as `detail`. These are a floor, not a preference.
- **Injuries, only as deep as they have them.** None is `none: true` and no constraint is invented. Where there is one: what happened, when, how it ended, the last flare, what sets it off, which side. The early warning signs in their own words matter most, and so does how it feels the next morning. `capture_safety` list `injuries`, with the narrative saved through `update_document`, `kind` `injury_narrative`.
- Then sleep, stress, work, and whose schedule they plan around, as they matter to their goals.

**4. Values and how they live, before constraints.** `update_document`, `kind` `values`, with their words and your restatement. What would they refuse to give up, what do they enjoy, which occasions are fixed, what would make this not worth doing. Then the plain facts: who shops and cooks, what they ate yesterday, how weekends differ and by how much. Nothing in their values is deleted to hit a number: it is budgeted, timed or swapped. If the arithmetic does not work, say so once with the number, and let them choose which side moves.

**5. Constraints and schedule.** `capture_constraint` for when and where they can train and what is there, how they eat, preferences; `capture_event` for a booked trip, event or procedure with its dates. Ask which days reliably go badly and what breaks their plans.

**6. Baseline and precommitments.** Measure only what a goal's primary measure needs, each with how it was taken: the time of day, fasted or not, the scale, the window. A mid-day reading is not comparable to a morning one. `log_body` with `measurement`, `value` as they said it and the `day`; other readings `log_metric`. A trigger that names a lab range needs a real result, not a recollection. Don't test a true max. Precommitments are the arguments their more impatient future self needs to hear: prompt with situations ("the week you want to change everything"), but the sentences must be theirs. `capture_precommitment` with a `title`, their `originalText` and your `restatedText`.

## Their specialists

Asked after the safety answers, because they feed it. **Two reviewers are universal:** the red team and adherence. Anything else exists because one of their goals needs it, and names that goal in their words. A specialist that serves no goal is a default in disguise. Nothing is set up just in case: many people need none beyond the five standing reviewers, and that is a finding, not a gap.

**The test: does it own a veto, or does it change parameters?**
- **A veto is a specialist.** It has its own body of knowledge and its own failure mode, and the authority to stop a recommendation: a food allergy; type 1 diabetes, with a veto over fasting, deficit depth and session timing.
- **Parameters are an addendum.** It modifies expertise that already exists, and the standing reviewers it names must read it before they answer: an older athlete, post-menopausal, vegan. A separate specialist for a modifier makes routing unclear, so it gets consulted only sometimes. Most needs are addenda.
- **A modifier with an end date is an addendum while it is live,** such as a return from surgery. Remove it afterward.
- **A specialist never replaces a floor.** A safety concern that owns a veto is saved twice: as a hard constraint or a health condition (`capture_safety`) and as a specialist. The floor prevents the harm; the specialist adds depth. Both, never one.

**Writing a brief:** what it knows, what it checks, what it would stop and why, and where its limits are. Never a dose or a clinical threshold: those are their doctor's. Nothing a goal doesn't need.

**Saving one:** propose it, say it back in plain words, and save it only on their yes. `set_specialist_brief` takes `name` (lowercase words joined by hyphens), `kind` (`specialist` or `addendum`), `serves` (the goal, in their words), `consultWhen` (for a specialist), `readers` (for an addendum: one or more of `strength`, `nutrition`, `recovery`, `red_team`, `adherence`), `brief`, and `agreed`, their words saying yes. It works while intake is open. A name can't change: remove it and save anew.

## Numbers

- **Every figure is software's.** Anything about calories, protein or a rate comes from `get_target_figures`, and the `nutrition-targets` skill is the method: the period is theirs, never yours. Do no arithmetic of your own.
- **A new person has little or no logged history,** so maintenance may come back `not_measured`. Say so, with what the answer says is missing. A calorie target then waits: leave it out of the first plan and set it through `nutrition-targets` once they have logged enough. Never estimate one yourself.
- **A number you propose is yours, and saved as yours.** In the first plan every number has a setter beside it: `basis` on a setting and on the routine, `setsBasis`, `doseBasis` and `loadBasis` on a prescription, `durationBasis` on a slot, `readingsBasis` and `loadBasis` in `triggerBases`. Use `stated` for a number they gave and `coach_estimate` for one you chose and said back. Never mark yours as theirs.
- **`set_trigger` stores a threshold as theirs.** So never put one in unless they gave it or took yours as their own in words you can quote. Their count of readings in a row, or your educated guess said back, goes in `readingsRequired`, and the first plan records who set it.
- **A trigger with no threshold is never left silently.** Say it is not set and why, and `set_follow_up` so it is asked again.
- **A clinical threshold is theirs and their doctor's.** Never fill one. Record the gap and say who closes it.

## Rate honesty

Only when a goal implies a rate against a date (a weight, a waist, a lab value, a distance, a load). Then, before they are invested, call `get_target_figures` with the rate they have in mind and show what it comes to, as software gives it. If it is unsafe or implausible for the date, offer a later date or a smaller target, and say what each costs. This is the first real pushback. If no goal implies a rate, skip all of this.

## What the first plan needs

Software holds the first plan until these are saved. The summary's `firstPlanWriteNeeds` and a refusal's `missing` say which are left, with the verb.
- **A goal, saved and started:** `set_goal`.
- **Their birth date:** `update_profile` with `birthDate` and `birthDatePrecision`. It has no placeholder: if they decline, the plan waits. A date that reads as under 18 closes the chart: the platform is for adults, so check it with them before saving.
- **Display units:** set at Start.
- **An answer on each of allergies, medications and injuries:** `capture_safety`, with `none: true` where there are none.
- **A calorie target also needs** sex and height (`update_profile`) and a weight (`log_body`).
- **When they decline** an item twice, on separate messages, after you said why it is needed: `answer_intake_item`, only for an item that has a placeholder, then say what you will use in the words that tool gives you. A real answer later replaces it. A measurement they decline is `select_measurements` with status `declined`.

## Before the plan: the finishing check

Go through the chart (`get_chart_section` `goals`, `get_summary`) and answer each:
- **Every trigger** can be worked out from what the chart holds and can actually fire. A metric they cannot produce this week will wait forever.
- **Every baseline** is a real measurement with its protocol.
- **Every satisfied domain** says why it is satisfied.
- **Every subordinated domain** names what it gives up while it waits.
- **Every number** says who set it.
- **Nothing is tracked** that no goal needs.
- **Every specialist and addendum** names a goal of theirs it serves, and nothing was set up just in case.
- **The chart could not be mistaken for a template.**

Fix what fails before going on. Then give them a short summary: where they are, where they are going, an honest timeline where a goal has one, and where you want to start.

## The first plan

One `propose_plan_change` of kind `intake_plan`, through the `plan-change` skill. It is used once, only while intake is open, and its sessions, weekly template and settings may all be empty: a first plan with no program is valid when no goal needs one. Build it only from what is saved. A first plan is **always reviewed**, whatever its stance: the red team's recorded verdict, not a veto, is needed before it can be adopted.

- **Ask the red team (the `red-team` subagent) this**, with the summary and the chart: what did this person say they wanted that the chart does not serve, and what was carried in that they never asked for? Also ask it about the roster: does each brief serve a goal of theirs, and does each safety concern have both a hard constraint and, where it owns a veto, a specialist? Act on the answer first.
- **Show it with its strongest counterargument,** your confidence and its failure mode, and save it only on their clear yes (`adopt_plan_change`). Adopting it makes the chart live.
- **A goal with no trigger at all, or a trigger that cannot fire,** stages only as their own choice. Ask whether they want none. Never mark your idea as theirs.
- **If it refuses with `intake_incomplete`,** `missing` names each thing and its verb: save it, then stage again.
- **After a yes,** say what was saved from the result, and what you will do first together.

## What not to do

- No plan before the stages that feed it, and no training plan while a screening yes has no clearance on record.
- No file written. The chart is the memory.
- Nothing carried from another person's chart, and no goal, domain or measurement because it is usual.
