---
name: harness
description: Install and PROVE the coding-standard harness for a project — CODING_STANDARDS.md, the import/architecture boundary gate, and the drift gate — then wire them where they can't be skipped. Use when setting up a project's standards, when the user says "harness", "wire the gates", "add architecture tests", "enforce the standards", or when an existing project's rules live only in prose.
disable-model-invocation: true
---

Typecheck, lint, tests and build catch **breakage**. An agent rarely breaks the build — it erodes
**shape**: a second word for one concept, a quiet suppression, an undeclared dependency, an import
that reaches past a module's public surface. This skill installs the gates that catch that, and —
the part that matters — *proves each one bites*.

The governing rule: **a rule the harness enforces beats a rule in a prompt.** Anything that stays
prose is labelled honestly as prose.

## 1. Read the profile, then verify its suggestions
`profiles/<domain>/PROFILE.md` → `## Standards harness` names the boundary tool for this
ecosystem. Treat it as a starting point, **not a fact** (PRINCIPLES #6): confirm the tool exists,
is maintained, and fits this stack before installing it. If it doesn't, say so and pick the
nearest thing that does — or fall back to a grep-based check and label it as such.

## 2. Write `CODING_STANDARDS.md`
From devkit's `templates/CODING_STANDARDS.md`. **The filename is load-bearing** — the installed
`/code-review` skill's Standards axis looks for exactly this file; without it that axis runs on
its generic smell baseline alone.
- Every rule carries its enforcer: `[types]` `[lint]` `[boundary]` `[script]` `[test]` `[review-only]`.
- **Never label a rule with an enforcer it doesn't have.** A false `[lint]` buys confidence
  nothing paid for; an honest `[review-only]` is worth more.
- Don't restate what tooling already enforces — `/code-review` skips those, so it's only padding.
- The Owner authors the judgement calls (layering, what's deliberately exempt). Ask, one question
  at a time, with a recommendation. Don't invent house style on their behalf.

## 3. Install the boundary gate
Per the profile. For TypeScript, delegate to the installed `/setup-ts-deep-modules` — it ships a
working `dependency-cruiser` config and already proves its own rules bite. Then fill in the piece
it deliberately leaves empty: its **`// Layering (optional, off by default)` stub**, which is
where *which area may depend on which* belongs. Use `/codebase-design` vocabulary (module,
interface, seam, depth) when discussing shape.

**Where the layering rules come from:** if `CONTEXT-MAP.md` exists, its contexts *are* the rules —
one rule per context folder, forbidding everything except the seams the map names. Copy them; don't
invent a parallel set of areas (that would be two shapes for one architecture). A context that
isn't in the import graph's rules is a suggestion, and the first agent in a hurry reaches straight
through it. No context map → the layering rules are the Owner's call; ask, don't guess.

## 4. Install the drift gate
Copy `templates/scripts/drift-check.sh` to `scripts/`. Tune `MAX_NEW_FILE_LINES`, `LEDGER`,
`ADR_DIR` if the project's layout differs. It reads `CONTEXT.md`'s `_Avoid_:` lines, so the
project's ubiquitous language becomes machine-checked the moment a term is written down.

If the **domain dial** is on, it also polices `INVARIANTS.md`: a new `INV-` row whose `Enforced by`
cell is empty fails the diff. Check the existing rows too — an invariant already sitting there with
no enforcer is a `[review-only]` rule that was never labelled as one. Give it a test or the label,
and confess the label.

## 5. Prove each gate bites — the completion criterion
A config that doesn't fail on a violation is worthless, so for **every** gate you installed:
1. run it — it must **pass** on the clean tree;
2. introduce the violation it exists to catch — it must **fail**, naming the right thing;
3. revert — it must **pass** again.

Paste the observed pass → fail → pass output into the report. This is devkit's sharpest version of
PRINCIPLES #2: **a gate you haven't watched fail is not a gate.** If step 2 doesn't go red, the
gate is decoration — fix it before finishing.

## 6. Wire it where it can't be skipped
Fold every gate into the project's one umbrella command (`check` / `validate` / `ci`), then put
that command somewhere it runs without anyone remembering to: a pre-commit hook
(`/setup-pre-commit`) or a Claude Code hook (`/update-config`). **This changes the Owner's
settings — ask before wiring it**, and say which files you'd touch.

## 7. Record it
Write the literal commands into `CLAUDE.md`'s **Build gates** section, and add a one-line pointer
to `CODING_STANDARDS.md` so a cold session finds the rules. Then report: what was installed, the
pass→fail→pass evidence per gate, which rules ended up `[review-only]`, and anything you couldn't
enforce.

## Retrofitting an existing project
Run the drift gate over a wide range first (`scripts/drift-check.sh main...HEAD`) and expect
noise. Disposition it honestly: fix the cheap ones, confess the rest to `REVIEW-DEBT.md`, and
exempt only genuine false positives with a `drift-ok` comment (each one greppable, forever). Do
**not** mass-exempt to get to green — a gate tuned until it's silent is the same as no gate.

## What this harness does not do
It checks *shape*, never *behavior*. Nothing here proves the thing works: that's `/verify-live`.
And `[review-only]` rules stay genuinely unenforced — by design, labelled, so nobody mistakes the
document for a guarantee.
