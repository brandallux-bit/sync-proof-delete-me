---
name: program-design
description: The program, its progression and lift progress. Use when the person asks to build or design their next block or program, wants a new program, asks "am I ready to go up?", whether to add weight or reps, or to progress a lift, or asks "how are my lifts doing?" or about their lift progress.
---

# Program design: the block, the progression, the lifts

The coach's rules hold throughout. Three questions, three methods. Anything that changes the plan is saved through the `plan-change` skill: draft, stage, review, show, their yes. Nothing here saves a thing on its own.

## Build my next block

**Start from their goals.** `get_chart_section` (`plan`, `goals`) and `get_summary`: which phase they are in decides the block's objective, and the phase changes, so read it, don't carry the last one forward. Say the objective up front.
- **In a deficit** the job is keeping strength: the same loads at a lower bodyweight is a win, and it reads as failure unless you name it first.
- **At maintenance** the job is rebuilding capacity.
- **In a surplus** the job is progressive overload.
- **If their goals aren't about weight,** the objective is what their first-ranked goal asks of training, in their words.

**Read before you write:**
1. **Injuries and hard constraints** (`get_summary`, the safety part). They are standing constraints at every phase. Put what's excluded into the design before choosing a single exercise. A resolved injury in a deficit deserves more caution, not less.
2. **The frequency they have actually kept.** `get_recent_training`, `report_progress`, and `get_document` for the program they're coming off. Design for the frequency they have kept, not the one they hope for: the commonest programming error. Don't ask what the chart already answers; ask for what it can't (equipment, the shortest realistic window, a trip or a deadline ahead).
3. **Their equipment and time.** From the chart; ask only what it lacks.

**Design it with the `strength` subagent,** handed their goals, injuries, equipment and the frequency kept. It reads and advises; it never speaks to them and saves nothing. You decide. A good block has:
- **Heavy, simple compounds first,** the fewest exercises that do the job, more sets each: setup time is friction and friction is missed sessions.
- **Each movement trained often enough to be practised,** at a volume their recent weeks show they can recover from. In a deficit, the lower end of what they have done.
- **Work around injuries, never through them:** change range of motion, then load, then the movement, in that order. No work taken to failure on a pattern that loads an injury. Load is earned through progression, never assumed from old numbers.
- **One progression rule,** a sentence long, with no in-session decisions.
- **A deload scheduled in the block,** not improvised.
- **Steps and easy movement before programmed cardio.** Never cardio as punishment for eating.
- **A substitution for each exercise and a short version for a bad day:** never zero. Sessions fit the shortest realistic window, not the average one.

The coach's numbers (sets, rep ranges, loads, RIR, how often a deload falls) are yours, chosen from their history. Never present one as theirs, and never invent a threshold they haven't set: say it is your choice and why.

**Save it as dated prescriptions, never prose alone.** A block that exists only as text never reaches them. Stage it with `propose_plan_change` as one `plan_draft`: a `program` piece for every session, each with its **complete** list of prescriptions and the day it starts, and a `weekly_template` piece placing each session on a weekday. The `plan-change` skill is the method from there. A new session is a `session.new`, named by a `key` that the template's slot then names as `sessionKey`. Every measurement goes as they or you stated it, with its unit; never convert one.

- **One variable at a time.** A block that changes the program, the template and the nutrition together can't be judged. If the plan needs more than the training changed, say what you'd change later.
- **The plan gets simpler when adherence drops,** never more elaborate. If they're missing sessions now, the block is smaller, not better.
- **Name the domain** each choice serves, in their words.
- Show them, before they decide, the block's strongest counterargument, your confidence, and the failure mode: the specific week it falls apart.

## Am I ready to go up?

**`get_progressions`** (no input). Per program session, software compares its prescription in force against the last two completed sessions. Read each session's `state`:
- **`judged`:** quote `says` and the from to figures of each `goesUp` as software gave them (`judgedOn` names the two days). The rule is software's: a dimension (sets, load, reps or seconds) goes up only when both of the last two sessions beat it, to the lower of the two, and never down; a bodyweight or band load isn't compared. Compute nothing, work out no load of your own.
- **`fewer_than_two_completed`:** say so. Nothing is judged yet; two in a row are needed.
- **`no_prescriptions_in_force`:** say so. There is nothing to compare.
- **`by_hand`** rows: a prescription stored only as text (an imported program's). Software doesn't read prescription text, so it can't judge it. Say that. Judge it from the logged sets (`get_recent_training`) in words, as your reading and not software's, and offer to restate that session as dated prescriptions through a plan change so software can judge it next time.

**Software proposes; they decide.** Before recommending any increase, **check it against their injuries:** whether a lift loads an injury is your judgement from their words and the summary's safety part, and software doesn't check it. Say you checked. If a movement might load one and you can't tell, say so and ask.

**To adopt it,** on their yes, send the session's `programChange` as given through the `plan-change` skill (`propose_plan_change`), adding only `effectiveFrom`, the day it starts, and the decision. Never rebuild the list, retype a row or convert a load. A session whose `programChange` is null has nothing to adopt: nothing goes up, or `programChangeNote` says why (a row stored only as text; restate that session first). A caption that quotes old figures is kept as stored: rewrite it with them if it now misleads, and say so. A progression is a plan change you recommend, so the review runs; it costs a share of their plan's limits, so don't run one for nothing that goes up.

In a deficit, a lift that holds is the result. Say so; don't chase a rise, and don't offer a progression that spends recovery they don't have.

## How are my lifts?

**`report_lifts`** takes the baseline period, `baseline: { from, to }`, each a day. **The period is theirs:** the days they state, or the ones their goals already hold (`get_chart_section`, `goals`). If you have neither, ask for it, one question, and never pick one, default one or infer one.

Per lift, quote what software returned:
- **The change,** the percentage as given, with **the two days** it compares (the best workout since the baseline against the best within it), and **RIR beside it:** a rise at a lower RIR is not the same rise.
- **A lift not measured** (`not_measured`, `none_since`, `no_baseline_set`) says so, in `says`. Never a zero, never a guess.
- **No estimated one-rep max,** yours included. The figure is a best workout, not a max.
- **Trend over point.** One best day is one day. Say what the lifts are doing together, and set a figure against the phase: flat in a deficit is the aim.

A lift that is falling in a deficit points at the nutrition side, sleep or an injury before it points at the program: check those first, say what you found, and change one variable through `plan-change`.
