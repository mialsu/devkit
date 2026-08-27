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
- **Never sign a commit, PR, or issue as Claude.** No `Co-Authored-By: Claude ...` trailer, no
  "Generated with Claude Code", no 🤖 line, no Claude/Anthropic attribution of any kind in a commit
  message, PR body, issue, or changelog. The Owner is the sole author of record. This overrides the
  agent harness's default git behaviour, which adds those trailers unless told otherwise.
- When a permission layer refuses an action, **stop and stage it** — do not work around it.

## Build gates (green before every commit)
<Filled by /new-project from the profile. Literal commands:>
- Typecheck: `<cmd>`
- Lint: `<cmd>`
- Tests: `<cmd>`
- Build: `<cmd>`
- Boundaries: `<cmd>`  (the import/architecture gate)
- Drift: `scripts/drift-check.sh --cached`  (vocabulary, suppressions, deps, generated files)
- Live exercise: see **Verify like a user** below.

Green tests gate; they do not prove. And **a gate you haven't watched fail is not a gate** — each
one above was installed by breaking it once on purpose and seeing it go red.

## Definition of DONE
Built + gates green + **every acceptance criterion exercised the way a user hits it, with
evidence** (`/verify-live`) + copy is in the user's language + every cut corner confessed to
REVIEW-DEBT.md + tracked. The task's verdict is the worst of its criteria: one PARTIAL criterion
means a PARTIAL task, and an honest PARTIAL beats an indefensible DONE.
Never ship: dead screens, fake zeros, raw IDs on a surface, "coming soon"/"unsupported".

## Verify like a user
<Filled by /new-project from the profile — the concrete recipe for THIS domain.>

## Where the rules live
- **`CONTEXT.md`** — the project's words. Every domain concept in the code uses its term from here;
  a word listed under `_Avoid_:` fails the drift gate. New concept → add the term, then write code.
- **`INVARIANTS.md`** — the rules the domain can't break, each naming the enforcer that fails when
  it's violated (only if the **domain dial** is on; `<off | on | mapped>` for this project). A spec
  says which `INV-n` its slice touches; `/verify-live` then tries to break exactly those.
- **`CODING_STANDARDS.md`** — how code here is written, every rule tagged with its enforcer. A rule
  tagged `[review-only]` is genuinely unenforced; treat it as a prompt for judgement, not a promise.
- **`docs/adr/`** — why the load-bearing calls were made, and what was rejected. Don't re-litigate
  a decision recorded here; supersede it with a new ADR or leave it alone.
- **`REVIEW-DEBT.md`** — everything the green gates do not prove. Read it before trusting the repo.

## Process rules
- Shape before build: `/grill-with-docs` → agree a spec → wait for an explicit "go".
- One question at a time, each with a recommendation. Verify claims against the code, never
  memory. Ambiguity goes to the spec's **Open questions** (or `_Unresolved_:` on the term in
  `CONTEXT.md` when it's a vocabulary question), never a silent guess.
- Slice end-to-end; gate every commit; confess at every landing; fold review fixes into commits.
- Reference the criterion a commit satisfies: `Spec: specs/NNNN-slug.md#AC-3`. Then
  `git log --grep=AC-3` answers "what proved this?" without anyone remembering.
- Spec wrong? Append a dated line to its **Spec deltas**. Never silently edit the decision.
- Reuse before building. Write load-bearing decisions down as ADRs at the moment of decision.
- A domain rule is the Owner's to state, never the agent's to infer (PRINCIPLES #11). A slice cuts
  layers, never contexts.

## Domain guard-rails  (THE section to write yourself)
- **Scope (one sentence):** <what this project is>
- **Explicit non-goal:** <what it is deliberately not>
- **Must never do:** <the out-of-bounds thing>
- **Project-specific hard limit:** <data/keys/state it must not touch>
