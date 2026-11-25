---
name: crunch-domain
description: Crunch a project's domain with the Owner — draft the timeline and its rules from the brief and ADRs, have the Owner confirm or change each, ask only where the sources are silent, then harvest the language into GLOSSARY.md and the rules into INVARIANTS.md entries that each name a failing test. Use when the user says "crunch the domain", "model the domain", "what are the invariants", "event storm", when a word keeps meaning two things, or before a project with real rules (money, scheduling, permissions, state machines) gets big.
disable-model-invocation: true
---

Solo event-storming, resized. It exists for one reason: **the value is the understanding, not the
document.** A domain model the agent generated from the code in one pass, that the Owner skimmed
and approved, is a pseudo-artifact — it reads like understanding, costs like understanding, and
carries none, while every later session cites it as fact.

So the division of labour here is strict and does not bend:

> **The agent drafts; the Owner decides.** The agent turns what the Owner has already decided — the
> brief, the ADRs, the glossary — into a timeline and candidate rules, each citing its source. The
> Owner accepts, strikes or changes each one. Where the sources are silent, the agent asks, with
> options and a recommendation.

Drafting replaced an open interview on 2026-11-25 (ADR-0005): the Owner works by steering an agent,
and most rules were already written in the brief, so asking the Owner to narrate them again cost
time and added nothing. Two things keep a draft from becoming the pseudo-artifact:

- **Every draft cites its source** — a brief section, an ADR, a glossary term. A rule with no source
  in the Owner's decisions is your invention: it goes to the Owner as a *question*, never into the
  draft table as though it were settled. A guess in this file is worse than a gap, because a gap
  is visible.
- **Nothing is written until the Owner confirms it**, and the recite gate still closes the session:
  can the Owner state the top three invariants with the file closed? Accepting a table in one click
  is how a skimmed model gets in; the recite check is what catches it.

## 1. Try to talk the Owner out of it

Check the **domain dial** (METHOD.md). It is `on` only when at least two of these hold:

- rules that aren't CRUD — something decides whether an action is *allowed*, and the answer isn't
  "the user owns the row";
- one word already means different things to different actors;
- money, scheduling, permissions, or state machines are in scope;
- the project will be alive longer than a month, across many sessions.

Fewer than two: say so plainly, recommend glossary-only (`GLOSSARY.md` alone, which is always on),
and stop. Refusing to model a to-do list is the skill working, not failing. If the Owner wants it
anyway, that's their call (PRINCIPLES #8) — proceed, and note in the report that the dial said no.

## 2. Ground yourself first, out loud

Before the first draft, read and *state what you found*: `PRODUCT-BRIEF.md` (its edge-case tables
already decide most outcomes), `docs/adr/`, `GLOSSARY.md` (and `GLOSSARY-MAP.md` if it exists), the
top-level code folders, the existing specs, `REVIEW-DEBT.md`. Every "the code
already does X" is a claim needing file:line (PRINCIPLES #6) — `/verify-claim` it if it matters.
Say which terms already exist so the Owner doesn't re-invent their own vocabulary at you.

## 3. Draft the timeline, then ask only what the sources leave open

1. **Draft the timeline** from the sources: the domain as **things that happen, in order**, past
   tense. Not tables, not screens, not endpoints. "A trip was requested. A driver accepted it. …"
   Show it and let the Owner add, cut or reorder events before you build on it.
2. **Work each event yourself**, with the questions the interview used to put to the Owner:
   - **who or what caused it**, and who is allowed to issue it;
   - **what had to be true for it to be allowed**, and **what must be true afterwards, forever** —
     each a candidate **invariant**;
   - **the edges** — it happens **twice**; it arrives **out of order** or very **late**; two actors
     do it **at the same time**; someone **undoes** it (reversed, or never happened?); the data is
     **a year old**.
3. **Draft each candidate as a full row**: the rule in glossary words, the concrete case that breaks
   it, the enforcer's name, and its source. Push each until it is falsifiable before showing it.
4. **Show all the drafts at once**, as one table, and ask the Owner to accept, strike or change them
   — row by row is fine. Five to ten is the target (`templates/INVARIANTS.md`, rule 1).
5. **Ask what the sources do not answer.** An edge nobody decided (what happens when a customer
   stops paying, who may undo a cancellation) is a product question: ask it with options and a
   recommendation marked "(Recommended)". Independent questions may share one prompt; a question
   whose answer changes the next one waits for it. A choice that adds or changes a rule goes back
   into the table before it is written.
6. **Challenge the words as you draft them.** A term that conflicts with `GLOSSARY.md` gets called
   out; a fuzzy term gets a proposed canonical name. That is `/domain-modeling`'s job — invoke it
   rather than re-implementing it, and let it write `GLOSSARY.md` in its own format. Before
   proposing an `_Avoid_:` word, check it against the identifiers the code will need and the
   glossary's rule on general programming words: the drift gate bans the word everywhere, so
   `contact` as a synonym to avoid would fail the contact form's own code.

Stop when every event has its rules confirmed or its open question asked. More drafts past that
point are padding the Owner will skim.

## 4. Harvest — each thing to the file that owns it

Nothing new is invented here; every output has a home that already exists:

| What came out | Goes to | Owned by |
|---|---|---|
| a word, its definition, its rejected synonyms | `GLOSSARY.md` (`_Avoid_:`, `_Unresolved_:`) | `/domain-modeling` (mp) |
| a rule that must always hold | `INVARIANTS.md` (`INV-n`) | devkit — `templates/INVARIANTS.md` |
| a hard-to-reverse call with real alternatives | `docs/adr/NNNN-*.md` | `/domain-modeling` (mp) |
| contexts, where they live, how they relate | `GLOSSARY-MAP.md` | `/domain-modeling` (mp) |
| a question the Owner couldn't answer | the spec's **Open questions**, or `_Unresolved_:` on the term | — |

## 5. Split contexts only when a word actually collides

Default is **one context**. Split only when the same word genuinely means different things to
different actors and no single definition serves both — that's the trigger, not size, not layers,
not "it feels like two systems". Splitting early buys the cost of a boundary with none of the
benefit.

When you do split: `GLOSSARY-MAP.md` names each context, the folder it lives in, and how they
relate; each context gets its own `GLOSSARY.md` and its own `INVARIANTS.md` beside its code.

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

## 7. Report and confess

Report: dial verdict, contexts (with the recommendation to keep it at one if that's the call),
`INV-n` list with each enforcer, terms added to `GLOSSARY.md`, ADRs offered,
and every open question. Then `/confess`: each `[review-only]` invariant, each context boundary
not yet in the boundary gate, and anything the Owner deferred.

## What this skill does not do

It doesn't design the schema, pick the framework, or write the feature — that's the spec's job,
downstream. It doesn't run on a CRUD app. And it never writes a rule the Owner hasn't confirmed, or
drafts one with no source in the Owner's decisions: the draft is the agent's, the model is the
Owner's, and the recite gate is what proves the second.
