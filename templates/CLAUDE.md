# CLAUDE.md — <PROJECT>

Guard-rails for every session on this project. Adopt every section verbatim except **Domain
guard-rails**, which you fill during `/new-project`. Precedence when docs disagree: the Owner's
live instructions > this file > any summary of it.

This project follows the **devkit method** (see the devkit repo: METHOD.md, PRINCIPLES.md).
Domain profile: **<PROFILE>**.

## Hard limits (immutable)
- Never push, open a PR, deploy, publish, or release without the Owner's explicit go. Local
  commits are fine; anything that leaves this machine is an explicit keystroke.
- Never spend money, add API keys, or send anything to a real external recipient without asking.
- Never run a destructive command on shared or irreplaceable state.
- When a permission layer refuses an action, **stop and stage it** — do not work around it.

## Build gates (green before every commit)
<Filled by /new-project from the profile. Literal commands:>
- Typecheck: `<cmd>`
- Lint: `<cmd>`
- Tests: `<cmd>`
- Build: `<cmd>`
- Live exercise: see **Verify like a user** below.

A gate you haven't run is not a gate. Green tests gate; they do not prove.

## Definition of DONE
Built + gates green + **exercised the way a user hits it, with evidence** (`/verify-live`) +
copy is in the user's language + every cut corner confessed to REVIEW-DEBT.md + tracked.
Never ship: dead screens, fake zeros, raw IDs on a surface, "coming soon"/"unsupported".

## Verify like a user
<Filled by /new-project from the profile — the concrete recipe for THIS domain.>

## Process rules
- Shape before build: `/grill-with-docs` → agree a spec → wait for an explicit "go".
- One question at a time, each with a recommendation. Verify claims against the code, never
  memory. Ambiguity goes to CUSTOMER-QUESTIONS / the spec's open-questions, never a silent guess.
- Slice end-to-end; gate every commit; confess at every landing; fold review fixes into commits.
- Reuse before building. Write load-bearing decisions down as ADRs at the moment of decision.

## Domain guard-rails  (THE section to write yourself)
- **Scope (one sentence):** <what this project is>
- **Explicit non-goal:** <what it is deliberately not>
- **Must never do:** <the out-of-bounds thing>
- **Project-specific hard limit:** <data/keys/state it must not touch>
