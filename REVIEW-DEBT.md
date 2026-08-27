# REVIEW-DEBT.md — devkit

The standing ledger of everything the green gates do NOT prove. Written at the moment a corner is
cut (`/confess`), read first by any architecture or review session, dispositioned by the Owner
(fixed / accepted-with-reason / promoted-to-issue).

<!-- Newest first. -->

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

- **What:** Phase 2 (spec acceptance criteria + AC→test→evidence traceability + per-AC verdicts)
  and Phase 3 (`DOMAIN.md`, `/crunch-domain`, the domain dial, principle #11) were agreed and are
  **not done**. Consequence today: `templates/spec/SPEC-template.md` has numbered user stories but
  no acceptance criteria, so `/verify-live` still returns one verdict per task rather than one per
  criterion — the granularity where an indefensible DONE actually hides.
- **Where:** `templates/spec/SPEC-template.md`; `skills/verify-live/SKILL.md`; `skills/confess/SKILL.md`.
- **What green tests do NOT prove here:** n/a — this is scope deferred by the Owner, not a fake seam.
- **Disposition:** open — Owner's call on when to run Phase 2.
