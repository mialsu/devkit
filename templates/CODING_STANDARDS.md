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
- Non-trivial logic leaves **one runnable check** behind: the smallest thing that fails if the
  logic breaks. No new framework, no fixture scaffolding — an assert-based self-check or one small
  test file. A trivial one-liner needs none. Code with no check is unfinished, and it is where a
  short diff goes wrong quietly (PRINCIPLES #3). `[review-only]`
- No skipped, focused, or silently-deleted test lands without a `REVIEW-DEBT.md` entry. `[script]`
- Green tests gate; they do not prove. The live exercise proves (PRINCIPLES #1). `[review-only]`
- A behavior change names the criterion it satisfies in its commit (`Spec: …#AC-N`), so the proof
  is greppable later. `[review-only]`

## Escape hatches

`TODO`, `FIXME`, `@ts-ignore`, `eslint-disable`, `type: ignore`, `#nosec`, skipped tests: allowed,
but each one is a confession — it lands together with its `REVIEW-DEBT.md` entry, in the same
commit, or the gate fails. `[script]`

## Deliberate ceilings

A simplification that is correct today and has a known limit — a global lock, an O(n²) scan over a
list that is small *for now*, a naive heuristic, a fixed retry count — is a decision worth making.
It lands with three things: a `CEILING:` comment naming what breaks, an `Upgrade:` line naming the
way out, and a `REVIEW-DEBT.md` entry in the same commit. `[script]`

```
// CEILING: global lock, single process only.
//   Upgrade: per-key locks when a second worker exists.
```

`git grep -n 'CEILING:'` is then the standing list of every corner this repo has knowingly cut.
Distinct from its neighbours, and the distinction is the point: `TODO` is unfinished, `FIXME` is
broken, a ceiling is **finished and bounded**. A `CEILING:` with no `Upgrade:` line is an excuse
wearing a convention, and the drift gate fails it.

What never gets a ceiling: input validation at a trust boundary, error handling that prevents data
loss, authorization, accessibility, and the calibration real hardware needs — a clock drifts, a
sensor reads off, and the platform is never the spec ideal. Cutting one of those is a defect with
a comment on it. `[review-only]` (`/audit` attacks the authorization half; drift check 8 catches an
`A11Y-n` row promising what nothing checks)

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
- Climb the **ladder** before writing code and stop at the first rung that holds — needed at all,
  already here, stdlib, platform, installed dependency, one line, then the minimum that works.
  The ladder runs after the flow is traced, never instead of tracing it. `[review-only]`
- No abstraction, wrapper, indirection, or config knob nobody asked for. The second caller is the
  earliest a shared helper may appear. This bans the *shallow* layer; where a genuine seam goes is
  a design call and `/codebase-design`'s to make. `[review-only]` (`/code-review`'s Speculative
  Generality baseline)
- Two stdlib approaches, same size: take the edge-case-correct one. Fewer lines, never the
  flimsier algorithm. `[review-only]`
- A bug fix lands at the shared owner, not at the caller the report happened to name. Grep every
  caller before choosing where the guard goes. `[review-only]`
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
