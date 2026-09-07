# CODING_STANDARDS.md — devkit

How work in *this* repo is done. The filename is deliberate: it is the exact file
`/code-review`'s Standards axis reads, so devkit holds itself to the same convention it hands to
every project it scaffolds.

devkit is **prose plus one shipped bash script**, so most rules here govern documents. Every rule
carries its enforcer:

| Tag | Means |
|---|---|
| `[script]` | `scripts/check.sh` fails the build on it |
| `[gate]` | `templates/scripts/drift-check.sh` fails the diff on it |
| `[review-only]` | genuinely unenforced — judgement, labelled honestly so nobody mistakes it for a guarantee |

Two meta-rules, from the template devkit ships:
- **Never label a rule with an enforcer it doesn't have.** A false `[script]` buys confidence
  nothing paid for.
- **Don't restate what tooling already enforces** — `/code-review` skips those, so it is padding.

## Documents

- **Never invent a format an installed skill already maintains.** `CONTEXT.md`, `CONTEXT-MAP.md`
  and ADRs follow `domain-modeling`; specs follow `to-spec`; the standards file is named
  `CODING_STANDARDS.md` because that is what `code-review` opens. The reuse map in `METHOD.md` is
  the register — add a row before adding an artifact. `[review-only]`
- **One id scheme, repo-wide:** `US-n` → `AC-n` → `D-n` → `INV-n` → `A11Y-n` → `ADR-NNNN`. A second numbering
  for the same thing is the "two words for one thing" anti-pattern aimed at documents.
  `[review-only]`
- **Every cross-reference resolves.** This repo is documents pointing at documents; a dead pointer
  is its likeliest defect and nothing else would notice. A trailing `:NN` or `:NN-NN` is stripped
  before the check, so the file:line evidence the rule below demands does not trip this one.
  `[script]`
- **A path that means "inside a generated project" is not a devkit path.** `scripts/drift-check.sh`
  is what a *project* runs; devkit's copy lives at `templates/scripts/drift-check.sh`. Keep the two
  readings distinct in prose — the reference checker deliberately cannot tell them apart.
  `[review-only]`
- **A claim about another repo carries file:line evidence or it doesn't ship** (PRINCIPLES #6).
  `[review-only]`

## Skills

- **`name:` in the frontmatter must equal the skill's directory name.** `install.sh` links by
  directory; the runtime resolves by `name`. A mismatch installs cleanly and then cannot be
  invoked. `[script]`
- **Every skill has a `description:`** — the runtime uses it to decide relevance, so a skill without
  one is unreachable in practice. `[script]`
- **A new skill is advertised in `README.md` and `install.sh`** the same commit it appears in.
  `[script]`
- **Owner-driven skills set `disable-model-invocation: true`.** `/new-project`, `/harness`,
  `/crunch-domain` and `/ship` change a repo or publish; the model must not start them on its own.
  `/spike` and `/sketch` join them: both write code, and `/spike` is meant to run in repos that
  are not yours. `[review-only]`

## The shipped script (`templates/scripts/drift-check.sh`)

- **No apostrophes anywhere inside the awk program — comments included.** The program is a
  single-quoted shell string, so one apostrophe ends it and the rest becomes shell. `bash -n` does
  *not* catch this. To match a literal quote, pass it in: `-v SQ="'"`. This has bitten twice.
  `[script]`
- **Patterns in the template are universal conventions only** (`*.gen.ts`, `drizzle/`,
  `openapi.json`). Anything specific to one repo belongs in that repo's *copied* script, never
  upstream. `[review-only]`
- **Every tunable is env-overridable with a default**, and named in the header comment.
  `[review-only]`
- **A new check ships with its observed pass → fail → pass in the commit message** (PRINCIPLES #2).
  A check nobody watched go red is decoration. `[review-only]`
- **A check that fires on routine work is a defect, not a strict gate.** Committed codegen output
  changes on every feature; a gate that flags it gets tuned to silence, and then nothing is gated.
  `[review-only]`
- **The gate's own pattern definitions carry `drift-ok` on the same line** — the file necessarily
  contains the words it polices. `[gate]`

## Committing

- **`scripts/check.sh` green before every commit.** It is devkit's whole gate set: shell syntax,
  shellcheck (when installed), the drift gate on itself, skill frontmatter, skill advertising, and
  cross-references. `[review-only]` — nothing forces it to run; see the debt below.
- **Confess in the same commit as the corner you cut** (PRINCIPLES #5). `REVIEW-DEBT.md` is read
  first by any later session, so an entry written "next time" is an entry lost.
- **A field run that finds a defect in devkit fixes devkit, then records what stayed unproven.**
  Three runs (devkit, a Python repo, a TS monorepo) each found new blind spots; assume a fourth
  will too. `[review-only]`

## What isn't enforced here, and honestly isn't

- **`shellcheck` is not installed on this machine**, so check 2 prints `SKIP` and runs nothing.
  It is a labelled hole, not a passing gate.
- **`scripts/check.sh` is not wired to anything** — no CI, no hook. It runs when someone types it,
  which by devkit's own anti-pattern list makes it a suggestion.
- **The shipped script has no test suite.** Every check in it was proven by hand, in scratch repos
  that were never committed, so no future edit has a regression net.

All three are open entries in `REVIEW-DEBT.md`.
