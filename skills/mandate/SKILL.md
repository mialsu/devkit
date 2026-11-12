---
name: mandate
description: Run one spec through the crew from the Owner's session — issue it as a mandate once a cold reader finds no blocking question, watch it by waking only when the crew parks a decision on the Owner, and close it with one pass over its confessions. Use when the user says "mandate", "hand this spec to the crew", "issue it", "start the crew on this", or when a crew mandate parks a question or finishes.
disable-model-invocation: true
argument-hint: "[path to the spec]"
---

The crew runs a spec on its own; the Owner's go is given once, per spec, not per slice (ADR-0003 in
devkit). That moves every cost of a weak spec to the moment it is handed over: a gap the Owner could
have answered in ten seconds becomes a stall halfway through, or a guess nobody sees. This skill is
the Foreman's side of a mandate — the Owner's one Claude session, outside the rig — from issue to
close. The Foreman lives one mandate, then hands off.

devkit supplies the rules here; OpenRig supplies the mechanics. Its `human-in-the-loop`,
`openrig-software-factory` (the working agreement) and `messaging-the-human` skills ship with it
(`rig context get <name>`). Use them; do not restate them.

## Phase 1 — Issue

### 1. Refuse what is not a spec yet
The spec needs an acceptance-criteria table whose rows each name a proof route, and tracer slices.
Missing either, stop and send it back to `/to-spec` (with `/grill-with-docs` first if the problem
itself is unclear). Read the spec and its `Invariants touched` before going further.

### 2. A cold read, by a reader with no context
Spawn a fresh subagent. Give it only paths: the spec, the project's `AGENTS.md`, `GLOSSARY.md`,
`INVARIANTS.md`, `DESIGN.md` and `docs/adr/` where they exist, and the **Index** of `REVIEW-DEBT.md`.
Give it none of this conversation — the crew will not have it either. Ask it:

> You will build this spec alone, slice by slice, with nobody to ask. List every question you would
> have to ask before or during the build. For each: the spec line it comes from, and whether the
> answer changes what gets built (blocking) or only how (not blocking).

A subagent is cold by construction. Reading the spec yourself is not a cold read: you have the
conversation that wrote it.

### 3. Place the spec on the ladder
- `stub` — no done-when, or blockers unknown
- `scoped` — done-when and blockers known, but a criterion lacks its proof route, or a blocking
  question is open
- `ready` — every criterion names how it will be proven, and no open question changes what gets built

Only `ready` is issued. A `ready` label over an unresolved question is the pseudo-artifact at spec
scale: the crew trusts it and builds the guess.

### 4. Every question takes one of three exits — none of them your judgement
1. **A question to the Owner, now**, if it blocks. One per message, with the options, what each one
   costs, and your recommendation. The answer goes into the spec; if the spec was already agreed,
   as a dated line in its `Spec deltas`.
2. **An open question in the spec**, if it does not block, so the crew sees it and stops on it if a
   slice reaches it.
3. **An explicit non-goal**, written into the spec.

When the answers have changed the spec, run the cold read once more. Ready is zero blocking questions
from a reader who has not seen the answers being given.

### 5. Write the working agreement and hand it over
One queue row to the lead (`rig queue create --destination orch-lead@crew-<project> --body-file
<file>`), carrying:
- the spec path, its slices in order, and the criteria ids each slice must reach
- the files and areas in scope; work outside them is a stop
- the invariants touched
- **the first-slice checkpoint**: park on `owner` after slice 1, with its per-criterion report
- **the stop rules** (ADR-0003): a product question the spec does not answer; a one-way door or a
  decision needing a new ADR; an invariant that would have to be weakened; work outside the files
  in scope; auth, schema or a new dependency, whatever the confidence; a criterion short of MET
  after three fix rounds on the same failure; a gate that will not go green or a permission prompt;
  a seat at its token ceiling; anything that would leave the machine
- the token ceiling per seat, if the Owner has set one; until then, "none set — record usage"
- a builder profile or model for any slice that needs one. **Never a Fable model.**

Note the commit the mandate starts from; Phase 3 needs it.

## Phase 2 — Watch

**Wait in the shell, not in the model.** Arm a background wait (the Monitor tool, an until-loop on
`rig queue list -o json`) that returns only when a row in this rig is parked on `owner`, or the
mandate's row closes. An empty check costs no model turn; a model that polls pays for every look.
Never read panes to see how it is going. `rig capture <seat> --lines 5` is for a seat that looks
stuck, and nothing else.

When the wait returns, `rig queue show <id>` and classify it as OpenRig's `human-in-the-loop` does:

- **Answerable from the record.** The spec, an ADR, the glossary or an invariant already answers
  it. Answer it yourself, citing the file and line, and say it is the Foreman answering from the
  record — not "From the Owner". The lead unparks the row itself (`CULTURE.md`).
- **A human gate.** Put it to the Owner exactly as Phase 1 step 4 puts a question: one at a time,
  the spec clause, options, consequences, recommendation. Relay the answer as a message starting
  "From the Owner", and write it into the spec as a dated delta so it is never asked twice.
- **The first-slice checkpoint.** Show the Owner the slice's verdicts in a few lines, and what the
  crew proposes next. Continue, adjust the spec, or stop — the Owner's call.
- **Auto-continue** should not reach you. If the lead parked a decision the mandate already
  covers, say so, so the next one is not parked.

Then arm the wait again.

## Phase 3 — Close

When the lead reports the mandate done:

1. **Read the verdicts, not the diff.** One per criterion; the mandate's verdict is the worst of
   them. List anything short of MET in plain words. Run `/verify-claim` on a verdict only where the
   Owner wants it checked.
2. **Decide the confessions in one pass.** Diff `REVIEW-DEBT.md` against the starting commit. Show
   the Owner each new entry with a recommended disposition — fixed, accepted-with-reason, or
   promoted-to-issue — and apply what they confirm: fixed and promoted entries leave the file, index
   line and all; accepted ones stay with their reason. Creating an issue on a remote is outside the
   machine: ask before running it.
3. **Record the cost.** Context usage per seat and for this session, while there is no token ceiling
   (ADR-0003, open question 3). The number is what the ceiling will be set from.
4. **Report in a few lines**: the verdicts, the PR, what was not checked, the confessions and what
   became of each. Then `/handoff`. The next mandate starts in a fresh session.

## What this skill does not do
- **Write the spec.** That is `/grill-with-docs` → `/to-spec`; the design behind it is `/architect`.
- **Build, review or merge.** The crew builds and reviews; merging is the Owner's, always.
- **Watch the crew work.** It waits for the crew to need a decision. A Foreman reading every pane is
  the token bill ADR-0003 exists to cut.
