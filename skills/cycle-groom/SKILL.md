---
name: cycle-groom
description: Walk the NEXT cycle's candidates up the readiness ladder — stub to scoped to ready — dispatching to the project's own refinement skills rather than writing specs inline, and turning every unknown into a question instead of an assumption. Use mid-cycle, or when the user says "refine the backlog", "groom", "get the next sprint ready".
---

This is the ceremony that pays for the cadence, and the one most often skipped.

`/cycle-plan` can only commit work that is already `ready`. Something has to make it ready, and if
that does not happen on a schedule it happens at planning instead — where the person specifying the
work is under a deadline and is also the person who has to build it. That is exactly the condition
in which an ambiguity gets resolved by a quiet assumption (ANTI-PATTERNS: *silent scope-filling*).

**So: if a cycle forces you to drop a ceremony, drop planning and keep this one.** A cycle planned
badly from ready work costs you a cycle. A cycle planned well from unready work costs you the
defect you shipped inside it.

## The one rule about timing

**Groom the NEXT cycle, never the current one.** Refining work you are about to commit is just
planning again, a week early, and it leaves the following cycle as empty as this one was.

The cadence runs three horizons at once, and the bindings in `CADENCE.md` name how far ahead the
Owner wants to work:

| Horizon | State |
|---|---|
| current cycle | **committed** — closed to new work except through the fenced classes |
| next cycle | **ready** — this skill's output |
| the one after | **stubbed** — a title and a why, enough to be groomed next time |

Anything beyond that is a roadmap entry, not a ticket. Stubbing four cycles out produces tickets
written against a scope that has not been frozen yet, and they rot.

## Step 1 — the bindings and the pool

Read `CADENCE.md`. Resolve the **next** cycle and the candidate sources it names.

Gather the pool: carry-over the Owner has already agreed to re-commit, plus whatever the roadmap or
milestone says lands in that window. Aim for more than will fit — grooming a pool exactly the size
of the commitment removes the Owner's ability to choose.

## Step 2 — rung each candidate, out loud

For each, state its current rung and what it is missing:

- `stub` → needs a done-when and its blockers found
- `scoped` → needs acceptance criteria, each naming **how it will be proven** (PRINCIPLES #1)
- `ready` → nothing; leave it alone

Do this before doing any work. A pool of ten where six are already `ready` is a very different
session from one where nine are stubs, and the Owner should know which it is before you start.

## Step 3 — dispatch, do not author

**Where the project has a skill for this class of work, invoke it.** `CADENCE.md` maps work classes
to their refinement skills for exactly this reason. A domain pipeline that already knows how to
specify its own artifacts will do it properly; this skill re-implementing that badly is the
*rebuilding what you already have* anti-pattern, aimed at specs.

Only where no skill claims the work do you specify it here, and then the bar is the ladder's, not a
lower one:

- a done-when a stranger could check
- acceptance criteria that each name `test:` / `live:` / `review-only:` — how it gets proven
- blockers named as real items with real ids, and either resolved or carrying a date
- a rough size if the bindings say estimates are in use

## Step 4 — unknowns become questions, never defaults

Every ambiguity you meet takes one of three exits, and **none of them is your own judgement**:

1. a **question to the Owner**, asked now if it blocks the rung, or recorded in the project's
   questions file if it does not
2. an **open item** on the project's register, if it needs an answer from outside
3. an explicit **non-goal** on the item, written down

An item cannot reach `ready` over an open question that changes what gets built. Say so, leave it at
`scoped`, and name the question. A `ready` label over an unresolved ambiguity is the *pseudo-artifact*
at ticket scale: it reads like preparation and carries none.

## Step 5 — report what did not make it

Output, and all three parts matter:

- the pool now at `ready`, with what changed
- **what could not be raised, and what it is waiting on** — this is the list that predicts the next
  cycle's carry-over, and it is the most useful thing this ceremony produces
- questions raised, and who owes each answer

Write the rung changes to the tracker within the envelope `CADENCE.md` grants. Never set workflow
state, never assign a cycle here — committing is `/cycle-plan`'s act, and doing it from groom
removes the Owner's chance to say no.

## Refuse, and say why

- No `CADENCE.md`.
- No next cycle to groom towards.
- The Owner wants the *current* cycle groomed. Say what that actually is — replanning — and offer
  `/cycle-plan` instead.
- A write the bindings do not grant. Stage it and name it.

## Anti-patterns this skill exists to prevent

- **Grooming the current cycle**, which is replanning wearing a different name and starves the next
  one.
- **Authoring specs that a domain skill should author**, producing a second, worse pipeline beside
  the good one.
- **Marking something `ready` to clear the queue.** The label is a claim that planning will trust;
  an honest `scoped` with a named blocker beats it every time (PRINCIPLES #10).
- **Resolving an ambiguity yourself** because asking felt slower than deciding. It is not slower; it
  is the same time, moved to after the code exists.
- **Stubbing far into the future**, where scope has not been frozen and the tickets will rot.
