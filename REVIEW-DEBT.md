# REVIEW-DEBT.md — devkit

The standing ledger of everything the green gates do NOT prove. Written at the moment a corner is
cut (`/confess`), read first by any architecture or review session, dispositioned by the Owner
(fixed / accepted-with-reason / promoted-to-issue).

<!-- Newest first. -->

## 2026-09-01 — a security pass built to resist being a pseudo-artifact, and how little of it is proven

- **What:** `/audit` fills the largest gap found so far — a grep for security/vulnerability/OWASP
  across devkit and all 60-odd installed skills returned nothing, and `/code-review` has exactly two
  axes, Standards and Spec (`code-review/SKILL.md:8-9`), with no security one. The skill's whole
  shape is a defence against the failure mode of its own genre: every finding carries a verdict —
  `exploited`, `reachable`, or `suspected` — and scanner output starts at `suspected`, labelled and
  counted rather than ranked. Severity comes from three Owner questions, not from the agent. It
  starts at `INVARIANTS.md` because broken object-level authorization is the bug a solo app ships,
  and it files what it finds as `INV-n` rows rather than report prose.
- **Where:** `skills/audit/SKILL.md`; `profiles/*/PROFILE.md` (`Security surface`);
  `templates/CODING_STANDARDS.md` (`Secrets & data exposure`); `skills/verify-live/SKILL.md`;
  `METHOD.md`.
- **What green tests do NOT prove here:** **`/audit` has never been run, and nothing in it is
  machine-enforced.** The entire skill is `[review-only]` — no gate checks that a finding carries a
  verdict, that the `suspected` pile was counted, or that a fix shipped with a failing-then-passing
  test. The verdict discipline is a prompt, and a prompt is exactly what `ANTI-PATTERNS.md` says an
  agent follows less reliably than a harness.
- **Disposition:** open. The honest mitigation is that the skill's output is a report the Owner
  reads, not a document that silently becomes load-bearing — but that is a property of how it is
  used, not something devkit enforces.

- **What:** Every tool named across the five `Security surface` sections is a recommendation from
  memory rather than a verified fit: `gitleaks`, `semgrep`, `eslint-plugin-security`, `bandit`,
  `gosec`, `pip-audit`, `govulncheck`, `cargo audit`, and the `strings`-on-a-bundle check. Step 5
  and `/harness` step 1 both say to verify before trusting, which is the mitigation and not a
  substitute for having checked.
- **Where:** `profiles/*/PROFILE.md` → `Security surface`.
- **Disposition:** open — this is the second phase in a row shipping unverified tool names
  (`/prune`'s five sections have the same defect, recorded 2026-09-01 above). Two occurrences is the
  point at which it stops being an incident: a field run that actually installs one of these is now
  the highest-value thing devkit can do to itself.

- **What:** `templates/CODING_STANDARDS.md` gained a **Secrets & data exposure** section whose five
  rules are all `[review-only]` by construction, upgraded to `[gate]` only when `/audit` step 11
  wires the tool. That is honest, and it also means a project scaffolded today carries five security
  rules that nothing checks.
- **Where:** `templates/CODING_STANDARDS.md`.
- **What green tests do NOT prove here:** the drift gate polices `INVARIANTS.md` and `DESIGN.md` for
  rows that name no enforcer, but `CODING_STANDARDS.md` is in `SKIP_CONTENT` and is not policed at
  all — so a rule mislabelled `[gate]` in a generated project goes unnoticed by the one mechanism
  that catches exactly this defect elsewhere.
- **Disposition:** open — a check 10 that reads enforcer tags in `CODING_STANDARDS.md` is the
  obvious symmetry, and was deliberately not built today rather than shipped unproven.

- **What:** No drift-gate check for hardcoded secrets was added, deliberately. `gitleaks` does the
  job properly, keeps its rules current, and scans history; a regex sweep in `drift-check.sh` would
  be a worse second implementation of one behaviour, which is the anti-pattern.
- **Where:** decision recorded here rather than in an ADR — devkit has no `docs/adr/`.
- **Disposition:** accepted. The cost is real and named: a project that never runs `/audit` has no
  secret detection at all, because the universal gate deliberately does not cover it.


## 2026-09-01 — deletion with proof, a commented-out-code gate, and a scanner nobody has run

- **What:** `/prune` lands the half of "clean up this repo" that nothing in devkit or the installed
  Pocock set covered: dead files, exports, imports, dependencies, env vars and commented-out blocks,
  each carrying the **proof** that it is dead before it is deleted — with a different bar per
  category, because they are not equally provable. The duplication half deliberately does *not*
  re-implement `/improve-codebase-architecture`; it contributes the three tests that say **don't**
  merge, and the evidence bar that makes "behaviour is unchanged" checkable. All five profiles
  gained a `Dead code & duplication` section naming their ecosystem's scanner.
- **Where:** `skills/prune/SKILL.md`; `profiles/*/PROFILE.md`; `templates/scripts/drift-check.sh`;
  `METHOD.md`.
- **What green tests do NOT prove here:** **`/prune` has never been run on a repo.** Every tool name
  in the five profile sections is a recommendation from memory, not a verified fit — `knip`,
  `jscpd`, `periphery`, `dependency_validator`, `deadcode`, `vulture`, `deptry`, `cargo-machete`.
  `/harness` step 1 says to verify a profile's tool before installing it and `/prune` step 2 repeats
  it, which is the honest mitigation, not a substitute for having checked. The one thing actually
  proven is drift check 9.
- **Disposition:** open — the next field run should exercise `/prune` on a repo that has accumulated
  something real. class-booking is too young and too clean to test it.

- **What:** Drift check 9 fails a diff that adds a block of commented-out code (default 3+
  consecutive lines, `MIN_COMMENTED_BLOCK`). Doc comments (`///`, `//!`, `/** */`, jsdoc
  continuations, `#!`, `#[...]`) are excluded and the body must parse as code — end in `; { } ( ) ,`
  or open with a language keyword — so prose in a comment block does not fire.
- **Where:** `templates/scripts/drift-check.sh` check 9.
- **Proven:** pass → fail → pass in a scratch repo. Clean tree with jsdoc and two-line prose
  comments passed; a 4-line commented-out TS block and a 3-line Python one both went red naming the
  right file, line and count; a true revert went green. The escape hatch was confirmed to work the
  way it is documented — `drift-ok` on one line of a 4-line block splits the run into 2 and 1, both
  under the threshold.
- **What green tests do NOT prove here:** it is a **heuristic, and it can be fooled both ways.**
  Three consecutive lines of *prose* that each happen to end in a comma or a bracket will fire —
  devkit's own new comment block in check 9 contains a run of two such lines, one line short. And a
  commented-out block written as prose-shaped pseudocode will not fire at all. There is no test
  suite behind this check, like every other check in the file.
- **Disposition:** open — accepted. A false positive costs one `drift-ok`; the alternative is the
  block nobody deletes.

- **What:** The `MIN_COMMENTED_BLOCK` tunable, the `Dead code & duplication` profile sections, and
  `/prune` itself are **tag and vocabulary drift for any project already generated by devkit.**
  class-booking's copied `scripts/drift-check.sh` is at eight checks and will not gain the ninth,
  and its `CODING_STANDARDS.md` has never heard of `/prune`.
- **Where:** `templates/scripts/drift-check.sh` vs any project's copied `scripts/drift-check.sh`.
- **What green tests do NOT prove here:** nothing in devkit detects that a generated project's copy
  of the drift gate is behind the template. This is the second time the gap has been recorded; it
  is now a pattern, not an incident.
- **Disposition:** open — a `--version` line in the script plus a check that compares it against
  the template would settle it. Owner's call whether that is worth the machinery.


## 2026-08-31 — a design contract, an accessibility gate, and how little of it is proven

- **What:** `/design-brief` + `templates/DESIGN.md` land the piece neither source had: a surface
  inventory reconciled **both ways** against the MVP cut, flows, a state table that cites the
  brief instead of re-deciding it, and `A11Y-n` rows that each name an enforcer. The look, the type
  scale, the wireframes and the UI copy are **delegated** to `frontend-design`, and "which layout
  wins" to `/prototype` — devkit adds only the constraint that token *values* live in code. All five
  profiles gained a `Design & accessibility` section, `/verify-live` gained the mouse-free walk,
  and the spec template gained `Screens & states touched`.
- **Where:** `skills/design-brief/SKILL.md`; `templates/DESIGN.md`; `profiles/*/PROFILE.md`;
  `skills/verify-live/SKILL.md`; `templates/spec/SPEC-template.md`; `METHOD.md`.
- **What green tests do NOT prove here:** **only §5 of `DESIGN.md` is enforced at all.** Drift check
  8 fails an added `A11Y-` row that names no enforcer — proven pass → fail → pass in a scratch repo,
  with the retired-id form `~~A11Y-3~~` confirmed not to match and an honest `[review-only]`
  confirmed to pass. Everything else in the file is `[review-only]` in its entirety: nothing
  reconciles the surface inventory against the MVP cut, nothing checks a state column was filled,
  and nothing notices when §4 grows into an inventory of every wrapper element.
- **Disposition:** open — the inventory reconciliation is the one worth an enforcer eventually,
  since it is mechanical: surfaces named in `DESIGN.md` versus bullets in `PRODUCT-BRIEF.md`.

- **What:** **The accessibility enforcers this ships are unwired everywhere, including here.** devkit
  now instructs projects to install an a11y linter and `axe`, run it per state, and watch each go
  red — and no project on this machine has done any of it. I have never run `axe` or a keyboard walk
  in any repo in this tree. By devkit's own rule, a gate nobody watched fail is not a gate, so every
  `[lint]` and `[test]` tag in the `DESIGN.md` template is a **recommendation wearing a tag**, and
  the honest reading of the template today is that A11Y-1 through A11Y-6 are all `[review-only]`
  until a real project proves otherwise.
- **Where:** `templates/DESIGN.md` §5; `profiles/web/PROFILE.md`, `profiles/mobile-fullstack/PROFILE.md`.
- **What green tests do NOT prove here:** that any of the named tools still exist under those names,
  that they catch what I claim, or that the keyboard walk finds anything — `/verify-live`'s new
  section has never been executed once.
- **Disposition:** open, and this is the first thing a real UI project should close.

- **What:** Two smaller drifts. `[live]` is **new tag vocabulary** in
  `templates/CODING_STANDARDS.md`, so `class-booking`'s copied standards file predates it and the
  two now disagree about the tag set — the same class of divergence as the brief's renumbered
  sections, one entry above. And the contrast-ratio instruction says "measure" while naming **no
  tool** that computes a ratio.
- **Where:** `templates/CODING_STANDARDS.md` (tag table); `templates/DESIGN.md` §5 (contrast table).
- **What green tests do NOT prove here:** that a project reading its own older standards file would
  recognise `[live]` as legitimate rather than a typo.
- **Disposition:** open — both fold into the same pass over `class-booking` the previous entry owes.

- **What:** `/design-brief` **has never been run.** Its per-profile branches are untested prose:
  game keeps sections 1/3/5/6, cli-tools keeps 1/2/3/6 and treats stdout as the state table, and
  library is told not to write the file at all. The cli-tools state table in particular asserts
  things about `NO_COLOR` and non-TTY behaviour that were reasoned about, not observed.
- **Where:** `skills/design-brief/SKILL.md` step 1; `profiles/cli-tools/PROFILE.md`.
- **What green tests do NOT prove here:** that the branches produce a usable document, or that the
  step-7 acid test (recite the flow with the file closed) is a bar an Owner can actually clear.
- **Disposition:** open — the next field run should be a CLI or a UI slice, not another web fixture.

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
