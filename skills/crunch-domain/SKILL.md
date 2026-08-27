---
name: crunch-domain
description: Crunch a project's domain with the Owner — walk the timeline out loud, harvest the language into CONTEXT.md, and turn the rules into INVARIANTS.md entries that each name a failing test. Use when the user says "crunch the domain", "model the domain", "what are the invariants", "event storm", when a word keeps meaning two things, or before a project with real rules (money, scheduling, permissions, state machines) gets big.
disable-model-invocation: true
---

Solo event-storming, resized. It exists for one reason: **the value is the understanding, not the
document.** A domain model the agent generated from the code in one pass, that the Owner skimmed
and approved, is a pseudo-artifact — it reads like understanding, costs like understanding, and
carries none, while every later session cites it as fact.

So the division of labour here is strict and does not bend:

> **The Owner supplies the rules. The agent asks, transcribes, challenges, and names.**

If you catch yourself writing an invariant the Owner never said, stop and ask instead. A guess in
this file is worse than a gap, because a gap is visible.

## 1. Try to talk the Owner out of it

Check the **domain dial** (METHOD.md). It is `on` only when at least two of these hold:

- rules that aren't CRUD — something decides whether an action is *allowed*, and the answer isn't
  "the user owns the row";
- one word already means different things to different actors;
- money, scheduling, permissions, or state machines are in scope;
- the project will be alive longer than a month, across many sessions.

Fewer than two: say so plainly, recommend glossary-only (`CONTEXT.md` alone, which is always on),
and stop. Refusing to model a to-do list is the skill working, not failing. If the Owner wants it
anyway, that's their call (PRINCIPLES #8) — proceed, and note in the report that the dial said no.

## 2. Ground yourself first, out loud

Before the first question, read and *state what you found*: `CONTEXT.md` (and `CONTEXT-MAP.md` if
it exists), the top-level code folders, the existing specs, `REVIEW-DEBT.md`. Every "the code
already does X" is a claim needing file:line (PRINCIPLES #6) — `/verify-claim` it if it matters.
Say which terms already exist so the Owner doesn't re-invent their own vocabulary at you.

## 3. Walk the timeline — one question per message

Ask the Owner to narrate the domain as **things that happen, in order**, past tense. Not tables,
not screens, not endpoints. "A trip was requested. A driver accepted it. …"

For each event, work it before moving on — one question at a time, each with a recommendation
marked "(Recommended)":

1. **Who or what caused it?** (the command, and who is allowed to issue it)
2. **What had to be true for it to be allowed?** → this is a candidate **invariant**. Push until
   it's falsifiable: "what would have to happen for that to be violated?"
3. **What must be true afterwards, forever?** → also a candidate invariant.
4. **Then probe the edges** — the questions that find the real model:
   - what if it happens **twice**?
   - what if it arrives **out of order**, or very **late**?
   - what if two actors do it **at the same time**?
   - who can **undo** it, and what does undone mean — reversed, or never happened?
   - what does this look like **a year later**, when the data is old?
5. **Challenge the words as they're spoken.** A term that conflicts with `CONTEXT.md` gets called
   out immediately; a fuzzy term gets a proposed canonical name. That is `/domain-modeling`'s job —
   invoke it rather than re-implementing it, and let it write `CONTEXT.md` in its own format.

Stop when the Owner starts repeating themselves. That's the model, not a shortage of questions.

## 4. Harvest — each thing to the file that owns it

Nothing new is invented here; every output has a home that already exists:

| What came out | Goes to | Owned by |
|---|---|---|
| a word, its definition, its rejected synonyms | `CONTEXT.md` (`_Avoid_:`, `_Unresolved_:`) | `/domain-modeling` (mp) |
| a rule that must always hold | `INVARIANTS.md` (`INV-n`) | devkit — `templates/INVARIANTS.md` |
| a hard-to-reverse call with real alternatives | `docs/adr/NNNN-*.md` | `/domain-modeling` (mp) |
| contexts, where they live, how they relate | `CONTEXT-MAP.md` | `/domain-modeling` (mp) |
| a question the Owner couldn't answer | the spec's **Open questions**, or `_Unresolved_:` on the term | — |

## 5. Split contexts only when a word actually collides

Default is **one context**. Split only when the same word genuinely means different things to
different actors and no single definition serves both — that's the trigger, not size, not layers,
not "it feels like two systems". Splitting early buys the cost of a boundary with none of the
benefit.

When you do split: `CONTEXT-MAP.md` names each context, the folder it lives in, and how they
relate; each context gets its own `CONTEXT.md` and its own `INVARIANTS.md` beside its code.

Then make the boundary real: **each context folder becomes a layering rule in the boundary gate**
(`/harness` step 3). A context that isn't in the import graph's rules is a suggestion, and the
first agent in a hurry will reach straight through it.

## 6. The enforcer pass — where this stops being a document

For **every** invariant harvested, in the same session, before the report:

- name the enforcer that fails when it's violated — `test:<name>`, `constraint:<db object>`,
  `type:<name>`;
- name its **one owner in code**. Three enforcement sites for one rule is three chances to drift.

Then it splits, because the two situations are genuinely different:

**Brownfield — the rule is already implemented.** Write the enforcer *now*. If a test that should
fail on a violation doesn't exist, write it (`/tdd`) and watch it go red against a deliberate
violation before you trust it. If you won't write it today, tag the invariant `[review-only]` and
open its `REVIEW-DEBT.md` entry the same minute (`/confess`).

**Greenfield — nothing is implemented yet.** Do *not* write a wall of failing tests: gates must be
green before every commit (PRINCIPLES #2), so a repo carrying eight deliberately-red tests can never
commit, and eight `[review-only]` entries on day one just teaches you to skim the ledger. Instead:
record the enforcer's **name** (`test:no_overlapping_bookings`) as a commitment, and let the tracer
slice that implements the rule deliver it — that slice's spec carries the acceptance criterion
*"INV-n's enforcer exists and fails when the rule is violated"*, proven by `test:` plus the
break-it-on-purpose observation. The invariant and its enforcer then arrive together, and the AC
table is what remembers the debt instead of the ledger.

Either way the rule is the same: **the enforcer is named before any code, and it exists before the
invariant is called enforced.**

An invariants table with no test names is the pseudo-artifact this skill was built to prevent.
The drift gate backs this up: a new `INV-` row with an empty `Enforced by` cell fails the diff.

## 7. Cold-read acid test — the Owner's, not yours

Close the files. The Owner states, from memory: the contexts, and the top three invariants.

- Can't do it → the model is too complicated, or wrong, or not theirs. **Simplify it; don't
  approve it** (PRINCIPLES #9, #11). Cutting the list to the three they *can* recite is a better
  outcome than a complete list nobody carries.
- Can do it → the model is real, and the files are now just its backup.

## 8. Report and confess

Report: dial verdict, contexts (with the recommendation to keep it at one if that's the call),
`INV-n` list with each enforcer, terms added to `CONTEXT.md`, ADRs offered, the acid-test result,
and every open question. Then `/confess`: each `[review-only]` invariant, each context boundary
not yet in the boundary gate, and anything the Owner deferred.

## What this skill does not do

It doesn't design the schema, pick the framework, or write the feature — that's the spec's job,
downstream. It doesn't run on a CRUD app. And it never, at any weight, hands the Owner a finished
model to nod at: the interview *is* the deliverable, and the files are the residue.
