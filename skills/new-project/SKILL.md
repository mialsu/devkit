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
- `CONTEXT.md` — the domain glossary starter. One line: the project's one-sentence purpose.
- `REVIEW-DEBT.md` — empty ledger.
- `docs/adr/` with the ADR template; `specs/` for shaped specs (thinking artifacts live beside
  the code, not in it if this is a workspace-style project).

## 3. Wire the gates
From the profile, install/verify the actual gate commands: the typecheck, the lint, the test
runner, the build, and the live-exercise recipe. Write them into `CLAUDE.md`'s **Build gates**
section as literal commands. Prove each one runs (even against an empty project) before moving
on — a gate you haven't run is not a gate.

## 4. Fill the domain guard-rails — one question at a time
This is the ONE section the user must author. Grill it out, one question per message, each with
a recommendation marked "(Recommended)", plain language. Cover:
- the one-sentence scope, and one explicit **non-goal**;
- what this project must **never do** (the thing that's out of bounds / owned elsewhere);
- any hard limit specific to this project (data it must not touch, keys it must not spend).
Keep the generic hard limits from the template verbatim.

## 5. Acid test
Open the intent of a cold session: from `CLAUDE.md` and `CONTEXT.md` alone, restate the
project's scope, its hard limits, and its gate set. If a cold read wouldn't get them right, the
setup isn't done — fix the docs, not your memory.

## 6. First commit
`git init` if needed; commit the scaffold. Report: profile chosen, gates wired (with the literal
commands), guard-rails captured, acid test result. Then STOP and wait for the first real task —
which starts with `/grill-with-docs`, not with code.
