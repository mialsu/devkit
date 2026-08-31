# REVIEW-DEBT.md — devkit

The standing ledger of everything the green gates do NOT prove. Written at the moment a corner is
cut (`/confess`), read first by any architecture or review session, dispositioned by the Owner
(fixed / accepted-with-reason / promoted-to-issue).

<!-- Newest first. -->

## 2026-08-31 — the product brief grew an edge-case section, and nothing enforces it

- **What:** `/product-brief` gained a senior-product-manager stance, a **users / scope /
  constraints** coverage checklist that has to be complete before a section is written, a new
  template section 6 (**Edge cases & honest failures** — empty / refused / stale / broken), and
  success signals that now name what you would observe and when. Sections renumbered as a result:
  non-goals 6 → 7, riskiest assumptions 7 → 8, doors 8 → 9, open questions 9 → 10, tech 10 → 11,
  success signals 11 → 12.
- **Where:** `templates/PRODUCT-BRIEF.md`, `skills/product-brief/SKILL.md`, `METHOD.md` (Stage 0
  paragraph, loop diagram, reuse map).
- **What green tests do NOT prove here:** **every word of it is `[review-only]`.** No gate reads
  `PRODUCT-BRIEF.md` at all — the drift gate's seven checks are vocabulary, escape hatches,
  undeclared dependencies, lockfiles, generated content, oversized files and `INV-` enforcers
  (`templates/scripts/drift-check.sh:119-273`). So a brief can ship with the edge-case table holding
  nothing but its `<placeholder>` row, and with all three interview areas never asked, and the gates
  stay green. The candidate enforcer is a check 8 that fails a committed document still carrying
  template angle-bracket placeholders; deliberately not written yet, because it needs its own
  observed pass → fail → pass and a check that fires on routine work is worse than no check.
- **Disposition:** open — the stance and the checklist are prompt text, which this repo's own
  anti-pattern list calls a suggestion.

- **What:** `class-booking`'s already-written brief now **disagrees with the template about what a
  section number means.** Its §6 is non-goals and its §7 is riskiest assumptions; the template's are
  now edge cases and non-goals. Its internal pointers resolve only against the old numbering, and it
  has no edge-cases section at all.
- **Where:** another repo, deliberately not edited from here —
  `~/code/personal/class-booking/PRODUCT-BRIEF.md:32` ("out of scope — see §6", whose target is that
  file's `## 6. Non-goals` at line 50) and `:8` ("recorded in §7", target `## 7. Riskiest
  assumptions` at line 66).
- **What green tests do NOT prove here:** that any brief written before today still matches the
  template a later session will read it against. devkit has exactly one filled-in brief, so n=1.
- **Disposition:** open — needs the Owner's go, because closing it is a commit in a different repo.

## 2026-08-27 — devkit now runs its own method on itself (and where that stops)

- **What:** devkit shipped a harness while having none: no `CODING_STANDARDS.md` (the file
  `/code-review` opens), no CI, no lint on the 200-line script it distributes, and a drift gate that
  ran only because someone remembered to type it. Now fixed: `scripts/check.sh` with six checks and
  `CODING_STANDARDS.md` with every rule enforcer-tagged. Five of the six were observed
  pass → fail → pass — a broken awk program (an apostrophe inside the single-quoted program, which
  `bash -n` does not catch), a skill whose `name:` differs from its directory, an unadvertised skill,
  a dead cross-reference, and a shell syntax error in `check.sh` itself.
- **Where:** `scripts/check.sh`; `CODING_STANDARDS.md`.
- **What green tests do NOT prove here:** **`shellcheck` is not installed on this machine**, so
  check 2 prints `SKIP` and runs nothing. It is a labelled hole, not a passing gate — the first
  `shellcheck` run on `drift-check.sh` should be expected to find real things.
- **Disposition:** open — `apt install shellcheck` closes it; the SKIP line is deliberately loud
  until then.

- **What:** `scripts/check.sh` **is not wired to anything.** No CI, no pre-commit hook — it runs when
  someone types it. By devkit's own anti-pattern list that makes it a suggestion, and it is exactly
  what `/harness` step 6 tells every *other* project not to accept.
- **Where:** `scripts/check.sh`; no `.github/`, no hook.
- **What green tests do NOT prove here:** that a future commit ran it at all.
- **Disposition:** open — needs the Owner's call, since a hook changes their local settings and CI
  means a workflow file that eventually leaves the machine.

- **What:** My own proof run was **invalid on two of five checks the first time**: `check.sh` wasn't
  git-tracked yet, so `git ls-files` skipped it and check 1 never examined itself (the revert then
  failed and left the file broken on disk); and the awk-breakage `sed` didn't match its target
  string, so "the gate passed" meant "nothing was changed". Both proofs were redone properly.
- **Where:** the method, not a file: a pass → fail → pass is only evidence if you confirm the
  *fail* step actually changed something.
- **What green tests do NOT prove here:** that any other proof in this repo's history was valid.
  The earlier ones printed their violations, which is weak evidence the mutation landed.
- **Disposition:** accepted-with-reason, recorded as the reason `check.sh` asserts on output content
  rather than exit codes alone.

## 2026-08-27 — First real bootstrap (`class-booking`): what the run found

- **What:** The drift gate gave a **false pass on a repo with no commits** — the exact state every
  project is in when `/new-project` installs it, and when `new-project` step 3 says "an empty project
  is the easiest place in the project's life to prove this". `git diff HEAD` has no HEAD, so git
  printed `fatal: bad revision` five times to stderr and the gate reported **clean** while several
  checks silently did nothing. Fixed: with no HEAD it now diffs the **empty tree**, announces it, and
  polices the bootstrap commit like any other diff. Verified on the fixture: zero `fatal` lines, and
  check 3 correctly fired `package.json gained a dependency with no ADR` in `--cached` mode, going
  green once ADR-0001 was written.
- **Where:** `templates/scripts/drift-check.sh` (`DEFAULT_MODE`, the empty-tree substitution).
- **What green tests do NOT prove here:** `dep_names()` still diffs against `RANGE` with no untracked
  fallback, unlike `added_lines()`. In the **default** working-tree mode an *untracked* manifest is
  therefore still invisible to check 3; it works in `--cached`, which is the mode a hook uses.
  Inconsistent coverage between checks, deliberately not fixed mid-bootstrap.
- **Disposition:** false pass fixed and observed; the `dep_names` untracked gap is open.

- **What:** **`/harness` step 3's boundary work now has one end-to-end proof** — the debt open since
  Phase 1. `dependency-cruiser` 18.2.0 installed on a real Vite/React/TS project with four rules
  (no-cycles, domain↛storage, domain↛react, nothing↛ui), each broken individually and watched to
  fail. The step-3 precondition check added after training-tracker was exercised for real: this
  project's layout differs from `/setup-ts-deep-modules`' root-file convention, so the config was
  written directly, as the step now instructs.
- **Where:** `class-booking/.dependency-cruiser.cjs`; `skills/harness/SKILL.md` step 3.
- **What green tests do NOT prove here:** that the delegation branch works. `/setup-ts-deep-modules`
  has still never been run — only the write-it-directly branch has.
- **Disposition:** partly closed. Also worth recording: **`domain-stays-pure-of-react` installed
  green and could never have fired**, because `exclude: node_modules` had removed the react module
  from the graph. Only breaking it on purpose revealed it. This is the single best piece of evidence
  devkit has for PRINCIPLES #2.

- **What:** Two profile facts are **stale**, found by using them: the web profile's stack default
  says `eslint`, but the current `create-vite react-ts` template ships **oxlint** and no eslint at
  all; and the same scaffold ships **without `strict`** in any tsconfig, which no profile warns
  about even though every invariant-bearing project wants it.
- **Where:** `profiles/web/PROFILE.md` → Stack defaults, Gate set.
- **What green tests do NOT prove here:** whether the other four profiles' stack defaults have
  drifted the same way. Only web was exercised.
- **Disposition:** open — the profile should name oxlint-or-eslint and add "turn `strict` on; the
  scaffold does not".

## 2026-08-27 — `/harness` field run on training-tracker (test only, nothing installed)

- **What:** The drift gate was run against a real TS monorepo (pnpm, Hono + React, ~4 packages) over
  its whole history *and* its uncommitted work. It found **three defects in itself**, each since
  fixed and each proven pass → fail → pass:
  (1) generated files it didn't know — `*.gen.ts`, `drizzle/`, a dumped `openapi.json`, codegen
  `schema.d.ts` — were being content-policed and size-capped;
  (2) *committed codegen output* was flagged as hand-edited on every regeneration, so `GENERATED`
  split into immutable (vendored, build output, applied migrations) vs `REGENERATED` (routinely
  refreshed, skip content, never flag modification);
  (3) banned words were matched inside **string literals** — enum values, test fixtures, free text —
  now stripped by default, with `POLICE_STRINGS=1` to restore strict matching.
  Effect on that repo: **198 → 70** hits over history, and the surviving hits reduced to four
  nameable classes instead of a wall.
- **Where:** `templates/scripts/drift-check.sh` (`SKIP_CONTENT`, `GENERATED`, `REGENERATED`,
  check 1, check 5); `skills/harness/SKILL.md` (retrofit section); `templates/CONTEXT.md`.
- **What green tests do NOT prove here:** that the gate is now quiet on a *different* stack. Three
  language-agnostic runs (devkit, a Python repo, a TS monorepo) have each found new blind spots, so
  the honest prior is that the fourth will too.
- **Disposition:** fixed. **The earlier prediction was confirmed and sharpened**: the prerequisite
  isn't just "prune general programming words" from `_Avoid_`, it's "prune words the *platform*, a
  *dependency*, or your own *enum values and labels* already own" — now written into
  `templates/CONTEXT.md`.

- **What:** **`/harness` step 3's delegation had an undocumented precondition.** It delegates TS
  boundary work to `/setup-ts-deep-modules`, which enforces depth — root files public, subfolders
  private. A repo whose packages declare `"exports": {".": "./src/index.ts"}` puts its entry point a
  level down, so that rule would flag *every* legitimate import. Step 3 now checks a `package.json`
  before delegating and writes the config directly when the convention differs.
- **Where:** `skills/harness/SKILL.md` step 3.
- **What green tests do NOT prove here:** anything about the config that would be written by hand in
  that case — it was designed and reviewed against the real graph, then **not installed**, because
  the Owner scoped the run to testing only.
- **Disposition:** open — the precondition check is written; neither branch of step 3 has run to
  completion on a real repo.

- **What:** **The boundary gate is still never proven end to end** — this run stopped before
  installing it. What *did* close: `dependency-cruiser` is verified real and maintained (18.2.0,
  published 2026-08-10), and `/setup-ts-deep-modules` is verified installed, so the Phase 1 entry
  saying the profiles' tool names were unverified recommendations is now partly discharged for the
  TS profile only.
- **Where:** `profiles/web/PROFILE.md`; `skills/harness/SKILL.md` steps 3 and 5.
- **What green tests do NOT prove here:** that a project ends up with a runnable `lint:boundaries`.
  Unchanged since Phase 1.
- **Disposition:** open — needs a run the Owner actually wants installed.

- **What:** Findings that belong to **training-tracker, not devkit**, recorded here only so they
  aren't lost — nothing was changed in that repo (its tree is byte-identical to before the run):
  its `CONTEXT.md` has no term for the **auth account** (the code correctly separates
  `session.user.id` from the Athlete it resolves to, and `me.ts` returns both) and none for the
  **Calendar** read-model its in-flight feature builds, while `calendar` sits under Plan's
  `_Avoid_`; and its `CLAUDE.md` + `docs/agents/domain.md` both assert a multi-context layout
  (`CONTEXT-MAP.md`, `src/<context>/CONTEXT.md`) that does not exist in a repo laid out as
  `apps/*` + `packages/*`.
- **Where:** not devkit's files. The Owner's call, whenever that repo is next worked on.
- **Disposition:** reported, not acted on — by the Owner's explicit instruction.

## 2026-08-27 — Phase 1 (DDD/SDD/harness integration): what is and isn't proven

- **What:** `/harness` has never been run end to end. Of its two halves, only the **drift gate**
  was proven — six checks, each observed pass → fail → pass, in a scratch repo and against devkit
  itself. The **boundary gate** half delegates to the installed `/setup-ts-deep-modules`, which I
  did not execute, so "the harness works" is a verified claim for one half and an untested
  delegation for the other.
- **Where:** `skills/harness/SKILL.md` steps 3 and 5; `templates/scripts/drift-check.sh`.
- **What green tests do NOT prove here:** that a real project ends up with a runnable
  `lint:boundaries`. Every profile ships `<boundary cmd>` as a placeholder by design.
- **Disposition:** open — closes the first time `/harness` runs on a real project.

- **What:** The per-ecosystem boundary tools named in the five profiles (`import-linter`,
  `depguard`, `go-cleanarch`, ArchUnit, `cargo-deny`, `api-extractor`, `cargo-public-api`, `gdlint`,
  NetArchTest) are **recommendations I did not verify are installable or maintained**. `/harness`
  step 1 instructs the agent to verify before installing — that is a deferral, not a proof.
- **Where:** `profiles/*/PROFILE.md` → `## Standards harness`.
- **What green tests do NOT prove here:** that any named tool exists today or fits the stack.
- **Disposition:** open — verified per project, at install time, by whoever runs `/harness`.

- **What:** The drift gate's dependency check is a **heuristic net, not a proof**. Tested manifest
  shapes: `package.json` (versioned line, whole new block), `requirements.txt` (bare unversioned
  name), plus version-bump and ADR-present negatives. A dependency declared in an untested shape —
  a Gradle `implementation(...)`, a `.csproj` `PackageReference`, a Cargo workspace inherit — can
  pass silently.
- **Where:** `templates/scripts/drift-check.sh`, check 3 (`dep_names`).
- **What green tests do NOT prove here:** completeness. A clean drift-check means "nothing the net
  is shaped to catch", never "no undeclared dependency".
- **Disposition:** open — widen the shapes as real projects hit them.

- **What:** The vocabulary check was **field-tested on a real repo and failed**, then fixed. On
  `meeting-conductor` (Python, 26-term glossary) the original substring matcher produced ~all
  false positives — `runtime`/`overrun`/`Running` matching `run`, `lockstep` matching `step`,
  Qt's `setWindowFlags` matching `flag`. Replaced with **identifier-segment matching** (`clientId`
  → `client` + `id`), plurals honoured only for terms of 5+ chars. Verified: the five synthetic
  false positives now pass clean, and `createPurchase` / `clientId` / `buyerName` / `purchases`
  are still caught, each annotated with the term that matched.
- **Where:** `templates/scripts/drift-check.sh`, check 1 (`seglist`, `banned`).
- **What green tests do NOT prove here:** that the *remaining* hits are worth acting on. On
  `meeting-conductor` 60 exact matches survive, and every one is a general programming word
  (`run`, `item`, `instance`, `duration`, `step`) that the repo's `_Avoid_` list should not
  contain — Pocock's own CONTEXT-FORMAT rule says a glossary holds domain concepts only.
- **Disposition:** algorithm fixed. **New prerequisite discovered:** before `/harness` runs on any
  repo, that repo's `CONTEXT.md` `_Avoid_` list needs a prune pass, or the gate opens with dozens
  of technically-correct-but-useless hits and loses trust on day one.

- **What:** The lockfile check still fires on a legitimate lock-only change (npm dedupe, audit
  fix), whose only remedy is `drift-ok` — which weakens the gate at that spot.
- **Where:** `templates/scripts/drift-check.sh`, check 4.
- **What green tests do NOT prove here:** that a green run wasn't bought with exemptions.
  `git grep drift-ok` is the audit; nothing forces anyone to read it.
- **Disposition:** open — accepted-with-reason.

- **What:** The **boundary gate is TS-only in practice**. `CODING_STANDARDS.md` and the drift gate
  are language-agnostic (the drift gate was run successfully against a Python repo), but only
  TypeScript has a ready-made, self-proving boundary config via `/setup-ts-deep-modules`. For
  Python — which backs roughly half the projects in this tree — nothing is wired.
- **Where:** `profiles/*/PROFILE.md` → `## Standards harness`; `skills/harness/SKILL.md` step 3.
- **What green tests do NOT prove here:** that a Python or Godot project gets any boundary
  enforcement at all today.
- **Disposition:** open — an `import-linter` contract set for the Python profile is the highest-value
  gap to close after the first TS run.

- **What:** `drift-check.sh` has **no committed test suite**. It was proven by hand in a scratch
  repo under `/tmp`, which is not committed — so a future session cannot re-run the proof that made
  it trustworthy, and a future edit to the script has nothing to catch a regression.
- **Where:** `templates/scripts/drift-check.sh` (no sibling test).
- **What green tests do NOT prove here:** everything. There are no tests.
- **Disposition:** open — the highest-value next task on the harness itself.

- **What:** Phase 2 (acceptance criteria) and Phase 3 (`INVARIANTS.md`, `/crunch-domain`, the
  domain dial, principle #11) are now **delivered** — this entry is kept, dispositioned, because it
  was the standing deferral the earlier phases pointed at.
- **Where:** `templates/spec/SPEC-template.md`; `templates/INVARIANTS.md`; `skills/crunch-domain/`.
- **Disposition:** closed 2026-08-27 by commits `d5f4d54` (Phase 2) and this one (Phase 3). What is
  *not* closed is listed in the Phase 3 entry below.

## 2026-08-27 — Phase 3 (DDD): what is and isn't proven

- **What:** **`/crunch-domain` has never been run.** It is a 7-step interview validated by nothing
  but inspection, and it is the piece of devkit most exposed to its own warning: the skill exists to
  prevent pseudo-artifacts, and until an Owner sits through it on a real domain, the skill is itself
  a document nobody has exercised. Both candidate repos are parked pending the Owner's repo cleanup.
- **Where:** `skills/crunch-domain/SKILL.md`.
- **What green tests do NOT prove here:** that the timeline walk in step 3 actually produces
  invariants an Owner recognises, that the edge-probe questions are the right five, or that step 7's
  cold-read acid test is passable on a real domain rather than merely demanding.
- **Disposition:** open — closes the first time it runs on a project with real rules. The specific
  risk to watch: an agent that narrates the domain *for* the Owner, which would invert the one rule
  the skill is built on.

- **What:** Of Phase 3, exactly one thing is **proven by observation**: the drift gate's new check 7
  (an `INV-` row with no `Enforced by` cell). Observed pass → fail → pass in a scratch repo — it
  caught an empty cell and a `TODO` placeholder, ignored a correctly-filled row and a struck-through
  retired row (`~~INV-0~~`), and fired on a per-context path (`src/ordering/INVARIANTS.md`).
  Everything else in Phase 3 is prose whose correctness rests on inspection.
- **Where:** `templates/scripts/drift-check.sh`, check 7.
- **What green tests do NOT prove here:** that a *named* enforcer exists. The gate reads the cell,
  not the test suite — `test:no_such_test` passes it. Closing that needs the gate to resolve test
  names, which is per-ecosystem work not done.
- **Disposition:** open — accepted-with-reason. The cell is a claim; `/verify-live` is what checks it.

- **What:** The **domain dial's four triggers and its per-profile defaults are a judgement call, not
  a measurement.** "≥2 of four" is a heuristic I chose; the profile defaults (web/mobile on, game
  rules-only, cli/library off) were reasoned from the domains, not observed on this machine's repos.
- **Where:** `METHOD.md` → `## The domain dial`; `profiles/*/PROFILE.md` → `## Domain dial`.
- **What green tests do NOT prove here:** that the bar sits in the right place. A too-low bar
  produces the pseudo-artifacts the phase exists to prevent; a too-high one loses the language on
  projects that needed it.
- **Disposition:** open — revisit after the dial has been set on three real projects.

- **What:** `INVARIANTS.md` **has no enforcement of its own semantics beyond the enforcer cell.**
  Nothing checks that an invariant is stated in `CONTEXT.md`'s words (rule 5), that it has one owner
  in code (rule 4), that the count stays in the 5–10 band (rule 1), or that a `[review-only]`
  invariant actually got its ledger entry. Four of the file's six rules are `[review-only]` — by the
  project's own standard, suggestions.
- **Where:** `templates/INVARIANTS.md`.
- **What green tests do NOT prove here:** all four of those rules.
- **Disposition:** open — the owner-in-code and ledger-entry checks look mechanisable; the other two
  probably aren't, and should be relabelled honestly rather than half-enforced.
