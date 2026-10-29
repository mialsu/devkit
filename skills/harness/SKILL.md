---
name: harness
description: Install and PROVE the coding-standard harness for a project — CODING_STANDARDS.md, the import/architecture boundary gate, and the drift gate — then wire them where they can't be skipped. Use when setting up a project's standards, when the user says "harness", "wire the gates", "add architecture tests", "enforce the standards", or when an existing project's rules live only in prose. `/harness sync` brings an installed drift gate back to devkit's template, when the user says "sync the gate" or a project's copy has drifted.
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
Per the profile. For TypeScript, delegate to the installed `/setup-ts-deep-modules` — **but check
its precondition first.** That skill enforces *depth*: a package's root files are its public
surface, every subfolder is private. That is only correct if the packages really do put their entry
points at the root. Read a `package.json` before delegating — if it declares
`"exports": {".": "./src/index.ts"}` (or `main`/`module` pointing into `src/`), the entry point is a
level down and the skill's rule would flag every legitimate import in the repo. Then write the
`dependency-cruiser` config directly instead, re-expressing the same rules against the real surface
(`packages/<pkg>/src/index.ts` public, everything else under `src/` private). Same tool, same
proving step in step 5 — just not the delegation. Delegate only when the convention matches; it
ships a working config and already proves its own rules bite. Then fill in the piece
it deliberately leaves empty: its **`// Layering (optional, off by default)` stub**, which is
where *which area may depend on which* belongs. Use `/codebase-design` vocabulary (module,
interface, seam, depth) when discussing shape.

**Where the layering rules come from:** if `GLOSSARY-MAP.md` exists, its contexts *are* the rules —
one rule per context folder, forbidding everything except the seams the map names. Copy them; don't
invent a parallel set of areas (that would be two shapes for one architecture). A context that
isn't in the import graph's rules is a suggestion, and the first agent in a hurry reaches straight
through it. No context map → the layering rules are the Owner's call; ask, don't guess.

## 4. Install the drift gate
Copy `templates/scripts/drift-check.sh` to `scripts/` **byte-for-byte, and never edit the copy.**
Everything that is the project's own goes beside it in `scripts/drift-check.local.sh`, which the
gate sources: `DEVKIT_GATE=<devkit commit the copy came from>` (always, so `/harness sync` knows
its base), the tunables when the layout differs (`MAX_NEW_FILE_LINES`, `MAX_NEW_TEST_FILE_LINES`,
`LEDGER`, `ADR_DIR`, `ERD_CMD`), `DRIFT_ROOT=package` for a copy per monorepo package, a
`local_settings` function to extend the patterns, and a `local_checks` function for a check only
this project needs. A gate edited in place is how four projects came to differ from devkit by 64 to
299 lines, and from each other, with fixes stranded in each (2026-10-29).

The gate reads `GLOSSARY.md`'s `_Avoid_:` lines, so the project's ubiquitous language becomes
machine-checked the moment a term is written down.

If the **domain dial** is on, it also polices `INVARIANTS.md`: a new `INV-` row whose `Enforced by`
cell is empty fails the diff. Check the existing rows too — an invariant already sitting there with
no enforcer is a `[review-only]` rule that was never labelled as one. Give it a test or the label,
and confess the label.

Checks 12 and 13 are the **diagram** gates (METHOD.md, *Diagrams*) and both are inert until the
project has something to police: 12 fires only on a `schema.gen.md` left unstaged at a commit, 13
only on a `**Code:**` caption line. Neither needs wiring. What does need wiring, in a project that
stores data, is the generated ERD itself: name what declares the schema (METHOD.md, *Diagrams*:
migrations, an ORM's schema, a document store's config), the profile names the generator, and the
gate is the test run — assert the generated diagram against the committed file, so
regeneration is the test runner's `-u` and staleness fails with a diff. Put the regenerate command
in `AGENTS.md`'s **Build gates** section beside the others.

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
Write the literal commands into `AGENTS.md`'s **Build gates** section, and add a one-line pointer
to `CODING_STANDARDS.md` so a cold session finds the rules. Then report: what was installed, the
pass→fail→pass evidence per gate, which rules ended up `[review-only]`, and anything you couldn't
enforce.

## `/harness sync` — bring an installed gate back to the template
For a project whose gate was installed earlier. The gate is the only file this mode touches, with
its `drift-check.local.sh`; the rest of the harness is the project's and stays as it is.

1. **Find the three versions.** *Base* is the template at `DEVKIT_GATE` (`git -C <devkit> show
   <sha>:templates/scripts/drift-check.sh`); *ours* is the project's copy; *theirs* is the template
   at devkit's `HEAD`. A copy with no `DEVKIT_GATE` predates the stamp: diff it against `HEAD` and
   sort every hunk by hand, as step 2 says.
2. **Sort every line where ours differs from base**, before copying anything. Each is one of:
   - **the project's setting** (a cap, a path, an extra skipped pattern) — moves to
     `drift-check.local.sh`;
   - **a check only this project needs** — moves to `local_checks`, or stays in a separate script
     the project already runs;
   - **a fix every project needs** (a false pass, a missed match) — goes to **devkit first**: the
     template change and a `scripts/check.sh` assertion that fails without it, as its own devkit
     commit. Only then is it in *theirs*.
   - **already in theirs**, because another project sent it back — nothing to move.
   Say which pile each hunk went to; a hunk nobody can place is a question for the Owner, not a
   line to drop.
3. **Copy theirs over ours, byte-for-byte**, and set `DEVKIT_GATE` to devkit's `HEAD`. Then
   `cmp` the two files: anything but identical means step 2 missed a hunk.
4. **Prove it, as step 5 does.** The clean tree passes; each setting and local check that moved
   fails on its planted violation and passes once reverted; and the project's full gate run is
   green. *Theirs* may carry checks the project never had, so expect new findings and sort them as
   *Retrofitting* below does.
5. **Commit in the project** with the base and target commits, the pile of each hunk, and the
   pass → fail → pass output. Pushing either repo is the Owner's call.

A multi-package repo with a copy per package syncs each copy, and sets `DRIFT_ROOT=package` in each
local file rather than editing the `cd`.

## Retrofitting an existing project
**Measure before you install.** Run the drift gate over the whole history first — the range
`$(git rev-list --max-parents=0 HEAD | head -1)...HEAD` scores every line the project ever added —
and then over the working tree, which is where the in-flight feature lives. Expect noise, and sort
it into three piles before changing anything:

1. **The gate's own blind spots** — generated files it doesn't know about, a codegen convention it
   hasn't met. Fix the gate; these are not the project's problem.
2. **Glossary bugs** — a banned word whose every hit is a value, a UI label, or a word the platform
   or a dependency owns. Fix `GLOSSARY.md`; the code is fine.
3. **Real drift** — the same concept under two names. This is the only pile that touches code.

Expect pile 3 to be the smallest, and don't be disappointed: a run that finds two missing *terms*
and no code defects has found the more expensive problem. Confess what you don't fix, and exempt
only genuine false positives with a `drift-ok` comment (each one greppable, forever). Do **not**
mass-exempt to get to green — a gate tuned until it's silent is the same as no gate.

## What this harness does not do
It checks *shape*, never *behavior*. Nothing here proves the thing works: that's `/verify-live`.
And `[review-only]` rules stay genuinely unenforced — by design, labelled, so nobody mistakes the
document for a guarantee.
