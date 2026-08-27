---
name: new-project
description: Bootstrap a new personal project under the devkit method. Use when the user is starting a project from scratch, wants to set up a repo the devkit way, or says "new project", "bootstrap", "scaffold a project", "start a <web/game/cli/library/mobile> project".
disable-model-invocation: true
argument-hint: "[project name] [domain]"
---

Bootstrap a project so every future session — today or in three months — has the same ground
truth. This is Phase 0 of the method, resized for solo. Do the steps in order; check each off.

## 1. Pick the domain profile
Ask which domain this is (or infer from the argument): `web`, `mobile-fullstack`, `game`,
`cli-tools`, or `library`. Read the matching `profiles/<domain>/PROFILE.md` from the devkit repo.
It defines this project's **stack defaults, gate set, tracer-slice shape, "verify like a user"
meaning, and definition of done**. Everything below is parameterised by it.

## 2. Lay down the workspace
Create the project directory (or use the current one if it's empty). Drop in, from devkit's
`templates/`:
- `CLAUDE.md` — fill the **domain guard-rails** section WITH the user (see step 4). Everything
  else is adopt-verbatim.
- `CONTEXT.md` — the ubiquitous-language starter, in the format the installed `domain-modeling`
  skill maintains. One line on what this context is; terms get added as they're resolved, not now.
- `CODING_STANDARDS.md` — seeded from the profile in step 3. The filename is load-bearing.
- `REVIEW-DEBT.md` — empty ledger.
- `scripts/drift-check.sh` — the drift gate (step 3).
- `specs/` for shaped specs. Do **not** pre-create `docs/adr/`: ADRs are created lazily, by the
  first decision that earns one. Same for `INVARIANTS.md` — it arrives with step 3a, or not at all.

## 3. Wire the gates
From the profile, install/verify the actual gate commands: the typecheck, the lint, the test
runner, the build, and the live-exercise recipe. Then run **`/harness`** for the rest of the gate
set — `CODING_STANDARDS.md`, the boundary gate, the drift gate — and let it do the proving.

Write every command into `CLAUDE.md`'s **Build gates** section, literally. Then, for each one:
run it green, break it on purpose, watch it go red, revert. **A gate you haven't watched fail is
not a gate** (PRINCIPLES #2) — an empty project is the easiest place in the project's life to
prove this, so do it here.

## 3a. Set the domain dial
The profile has a default (`off` / `on` / `on for the rules domain only`). Confirm it against the
project in front of you using METHOD.md's four triggers, and state the verdict in `CLAUDE.md`.
- **off** — `CONTEXT.md` only. Nothing else to do; the glossary is always on.
- **on** — copy `templates/INVARIANTS.md` and run **`/crunch-domain`** *before the first spec*, not
  after. Invariants discovered after the schema exists cost a migration.
- Don't create `CONTEXT-MAP.md`. One context until a word actually collides (PRINCIPLES #4).

Recommend the profile default unless the project clearly clears or misses the bar, and say which
way you're arguing. An empty repo cannot answer "does this have a domain?" for you — the Owner can.

## 4. Fill the domain guard-rails — one question at a time
This is the ONE section the user must author. Grill it out, one question per message, each with
a recommendation marked "(Recommended)", plain language. Cover:
- the one-sentence scope, and one explicit **non-goal**;
- what this project must **never do** (the thing that's out of bounds / owned elsewhere);
- any hard limit specific to this project (data it must not touch, keys it must not spend).
Keep the generic hard limits from the template verbatim.

## 5. Acid test
Open the intent of a cold session: from `CLAUDE.md`, `CONTEXT.md` and `CODING_STANDARDS.md` alone,
restate the project's scope, its hard limits, its gate set, the domain dial's setting, and which of
its rules are enforced versus `[review-only]`. If a cold read wouldn't get them right, the
setup isn't done — fix the docs, not your memory.

## 6. First commit
`git init` if needed; commit the scaffold. Report: profile chosen, gates wired (with the literal
commands), guard-rails captured, acid test result. Then STOP and wait for the first real task —
which starts with `/grill-with-docs`, not with code.
