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
- **`DESIGN.md`** — the surface contract (only if this project has a surface): the inventory
  reconciled against scope, the flows, the four states of each surface, and the `A11Y-n` rows that
  each name an enforcer. It records *where* the design tokens live in code; it never copies their
  values. See **Surface work** below for who owns the parts this file deliberately does not.
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
- Reuse before building, as a **ladder** (PRINCIPLES #3): needed at all → already in this repo →
  stdlib → platform → installed dependency → one line → the minimum that works. Stop at the first
  rung that holds, and climb only after the real flow is traced — the smallest change in the wrong
  place buys a second bug. No abstraction, wrapper or knob nobody asked for. A bug fix lands at the
  shared owner, not at the caller the report happened to name. A simplification with a known limit
  gets a `CEILING:` comment, an `Upgrade:` line, and its `REVIEW-DEBT.md` entry in the same commit.
  Shortest is measured *inside* a slice, never against one: no rung licenses stopping at the logic
  layer.
- Write load-bearing decisions down as ADRs at the moment of decision.
- A domain rule is the Owner's to state, never the agent's to infer (PRINCIPLES #11). A slice cuts
  layers, never contexts.

## Surface work  (only if this project has a surface)
The look is not this project's to invent. Three installed skills own the parts devkit deliberately
does not, and they are reached for **at build time** — `DESIGN.md` is the contract, not the design.
- **The look** — palette, type scale, spacing, the signature element, wireframes, UI copy:
  **`frontend-design`**. Invoke it when the UI is actually built, not while shaping. One constraint
  survives from `DESIGN.md`: the token **values live in code**, and that file points at them.
- **Which a11y rules this surface owes** — **`ui-ux-pro-max`**, `search.py --domain ux`: 119
  guidelines citing WCAG 2.2, Apple HIG and Material. It supplies the *rule*; the `A11Y-n` row in
  `DESIGN.md` supplies the `[test]`/`[live]`/`[review-only]` tag. One observable outcome per query,
  and verify the returned id fits this platform before it becomes a row.
- **How it is done in this stack** — **`ui-ux-pro-max`**, `search.py --stack <name>`; `--domain
  react` for rerenders, bundles and Suspense waterfalls. A read that writes nothing.
- **Which of two layouts wins** — **`/prototype`**, N variants on the real route with real data.
  Prose cannot settle a layout, and a variant judged in isolation always looks fine.
- **Never `--persist` or `--force`.** They write `design-system/<slug>/MASTER.md`, whose token table
  is a second home for values that live in code. **Drift check 11 fails the commit** — and it also
  fires on 3+ markdown table rows pairing a `--token` name with its value, so a hand-written palette
  table in `DESIGN.md` is caught too.

## Domain guard-rails  (THE section to write yourself)
- **Scope (one sentence):** <what this project is>
- **Explicit non-goal:** <what it is deliberately not>
- **Must never do:** <the out-of-bounds thing>
- **Project-specific hard limit:** <data/keys/state it must not touch>
