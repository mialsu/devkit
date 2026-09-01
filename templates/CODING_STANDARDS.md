# CODING_STANDARDS.md — <PROJECT>

How code in this repo is written. **This exact filename matters**: the installed `/code-review`
skill's Standards axis looks for `CODING_STANDARDS.md` (or `CONTRIBUTING.md`). Without this file
that axis runs on its generic smell baseline alone; with it, the review checks *your* rules.

## How to read this file

Every rule carries its **enforcer**. A rule with no enforcer is a suggestion, and agents follow
harnesses far more reliably than prose (ANTI-PATTERNS: *a standard with no enforcer*).

| Tag | Means |
|---|---|
| `[types]` | the typechecker fails on it |
| `[lint]` | the linter fails on it |
| `[boundary]` | the import/architecture gate fails on it |
| `[script]` | a repo script fails the diff or the build on it — `scripts/drift-check.sh`, a pre-commit scanner, a grep-based check where no linter exists |
| `[test]` | a test asserts it |
| `[live]` | a `/verify-live` recipe proves it — human-run, but a real gate (the keyboard walk, the clean install) |
| `[review-only]` | **nothing checks this** — it holds only if a human or `/code-review` catches it |

Two rules about the rules:
- **Don't restate what tooling already enforces.** `/code-review` skips those, so listing them
  here only pads the file. Keep the list short enough that it actually gets read.
- **Never label a rule with an enforcer it doesn't have.** A false `[lint]` is worse than an
  honest `[review-only]` — it buys confidence nothing paid for.

## Language

- Every domain concept is named with its `CONTEXT.md` term. New concept → add the term first,
  then write the code. `[script]` (`_Avoid_` words), `[review-only]` (missing terms)
- Names reveal intent; a name you can't defend means the design is still murky. `[review-only]`

## Shape & boundaries

- Import a module only through its public surface, never its internals. `[boundary]`
- No dependency cycles. `[boundary]`
- <Layering: which areas may depend on which — one rule per context in `CONTEXT-MAP.md`.> `[boundary]`
- Nothing crosses a context boundary except through a seam the context map names. `[boundary]`
- A domain invariant (`INV-n`) is enforced in **one** place, and that place is named in
  `INVARIANTS.md`. Everywhere else calls it — three enforcement sites is three chances to drift.
  A comment at the owner naming its `INV-n` tells the next reader why the check exists. `[review-only]`
- Prefer deep modules: a lot of behavior behind a small interface, placed at a clean seam. Use
  the `/codebase-design` vocabulary (module, interface, depth, seam, adapter). `[review-only]`
- A new file over <400> added lines needs a reason. `[script]`

## Tests

- Test external behavior through the module's interface, never implementation detail. `[review-only]`
- Prefer an existing seam to a new one, and the highest seam that works. `[review-only]`
- No skipped, focused, or silently-deleted test lands without a `REVIEW-DEBT.md` entry. `[script]`
- Green tests gate; they do not prove. The live exercise proves (PRINCIPLES #1). `[review-only]`
- A behavior change names the criterion it satisfies in its commit (`Spec: …#AC-N`), so the proof
  is greppable later. `[review-only]`

## Escape hatches

`TODO`, `FIXME`, `@ts-ignore`, `eslint-disable`, `type: ignore`, `#nosec`, skipped tests: allowed,
but each one is a confession — it lands together with its `REVIEW-DEBT.md` entry, in the same
commit, or the gate fails. `[script]`

## Secrets & data exposure

Every rule here starts `[review-only]` and is **upgraded to `[script]` only when `/audit` step 11
actually wires the tool** — labelling one before that is the false-enforcer mistake this file's own
meta-rules forbid.

- No secret in the repo — not in the working tree, and not anywhere in history. `[review-only]`
- A leaked secret is **rotated first**, then removed from history. Removal alone leaves a live
  credential: the value has been on a remote, in forks, and in CI logs. `[review-only]`
- A handler returns the fields the caller is entitled to, never the whole row. Hiding a field in the
  UI does not hide it in the response. `[review-only]`
- Errors reaching a client carry no stack trace, no query, and no internal id. `[review-only]`
- Logs and crash reports carry no credentials and no PII — list the fields that count as PII here,
  or the rule is unenforceable by anyone but its author. `[review-only]`

## Dependencies & reuse

- Reuse before building: never re-implement what the language, framework, or an existing
  dependency already gives you (PRINCIPLES #3). `[review-only]`
- A new runtime dependency needs an ADR — what it replaces, and what was rejected. `[script]`
- Generated, vendored, and lockfile content is touched only through its generator. `[script]`

## Smell baseline: this repo's overrides

`/code-review` always applies a fixed Fowler smell baseline (Mysterious Name, Duplicated Code,
Feature Envy, Primitive Obsession, Speculative Generality, …) as *judgement calls*. A documented
rule here **overrides** it. List only genuine, deliberate divergences:

- <e.g. "Primitive Obsession: suppressed for `<X>` — plain strings are correct there because …">

## What tooling already enforces (deliberately not restated above)

- Formatting and style: `<cmd>`
- Types: `<cmd>`
- Lint rules: `<cmd>`
- Boundaries: `<cmd>`
- Drift: `scripts/drift-check.sh`
