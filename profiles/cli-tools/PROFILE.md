# Profile — CLI / tools / scripts

Command-line tools, automation, and small utilities. The product is the *behavior at the
command line*: the right output, the right exit code, and a tool a stranger can install and run.

## Stack defaults (adapt freely)
- Any language; match the ecosystem you'll distribute in (Go / Rust for single binaries, Node /
  Python / shell for scripting, etc.).
- An arg-parsing library that gives you `--help` and validation for free (reuse before building).
- Tests: unit for logic + a thin integration layer that runs the built binary on real args.

## Gate set (green before every commit)
- Typecheck / compile: `<cmd>` (the build must succeed)
- Lint/format: `<cmd>`
- Tests: unit + the integration layer (run the binary, assert stdout/stderr/exit code)
- `--help` renders and documents every flag
- Boundaries: `<boundary cmd>` (see **Standards harness**)
- Drift: `scripts/drift-check.sh --cached`
- Live exercise: see below

## Domain dial (default: **off** — glossary only)
- **Why off:** a CLI's rules usually belong to the thing it wraps, and that thing already owns
  them. Re-stating someone else's rules here creates a second source of truth that silently goes
  stale — the pseudo-artifact in its purest form.
- **Still always on:** `CONTEXT.md`. Flag names, subcommand names and output nouns are the tool's
  ubiquitous language, and they are the part users actually type. One name per concept, and a
  renamed flag is a breaking change.
- **Turn it on when** the tool encodes its own rules rather than relaying them — a scheduler, a
  cost/quota calculator, a migration planner, anything with an ordering guarantee. Then the
  invariants are about *idempotence and ordering*: running it twice does what running it once did,
  a partial failure leaves nothing half-applied, and `--dry-run` output matches the real run.

## Design & accessibility (`/design-brief`)
A CLI has no screens and unmistakably has a surface, so run `/design-brief` for sections 1, 2, 3
and 6 and say plainly that components and visual a11y do not apply. Here the **surface inventory**
is the command shapes and the **state table** is the output contract:

| Surface | Empty | Loading | Refused / error | Success |
|---|---|---|---|---|
| `<subcommand>` | what prints when there is nothing — never a blank line and exit 0 with no word | progress on **stderr** so stdout stays pipeable, or nothing at all | the message on stderr, and the exit code | stdout shape, and exit `0` |

- **Accessibility here is mostly testable, which makes it the cheapest of any profile `[test]`:**
  honour `NO_COLOR` and a non-TTY stdout (colour codes in a pipe are corruption, not decoration);
  never carry meaning in ASCII art, box drawing or alignment alone, because that is what a screen
  reader flattens; wrap to the real terminal width rather than a hard-coded 80; keep every error on
  stderr so a screen-reader user is not hunting for it inside data.
- **Assert it the way the profile already asserts `--help`:** run the built binary with stdout piped
  and `NO_COLOR=1`, and diff the output. Both are one integration test each.
- **What no gate catches:** whether the output is *comprehensible* when read aloud line by line, and
  whether a progress display degrades gracefully when the terminal is 40 columns wide.

## Standards harness (`/harness`)
- **`CODING_STANDARDS.md`** at the repo root — the file `/code-review`'s Standards axis reads.
- **Boundary gate by ecosystem:** Go → `depguard` (via golangci-lint) for import rules, plus
  `go-cleanarch` for layer checks — written by Robert Laszczak of Three Dots Labs, the same source
  as the DDD-and-agents argument this profile's discipline comes from. Python → `import-linter`
  with layer/forbidden/independence contracts in `.importlinter`. Rust → module visibility +
  `cargo-deny`. Node → `dependency-cruiser` via `/setup-ts-deep-modules`.
- **Drift gate:** `scripts/drift-check.sh`.
- **The CLI-specific one:** exit codes and `--help` drifting away from the flags that exist. That
  is a `[test]`, not a lint — assert the built binary's `--help` mentions every flag and that each
  documented failure mode returns its documented exit code.
- **What no harness here catches:** the clean-install experience, non-TTY behavior, and
  cross-platform path assumptions. Those need the live exercise below.

## Dead code & duplication (`/prune`)
- **Go:** `golang.org/x/tools/cmd/deadcode` for unreachable functions, `staticcheck`'s U1000 for
  unused identifiers, and `go mod tidy` followed by `git diff --exit-code go.mod go.sum` for
  dependencies — that pair is a real `[script]` gate and belongs in the gate set.
- **Python:** `ruff` covers three of the categories at lint speed — F401 unused imports, F841
  unused locals, and **ERA001 commented-out code**, which is the one ecosystem with a maintained
  rule for it. Add `vulture` for unused functions and classes (it reports a confidence score; treat
  anything under 100% as a candidate, not a finding) and `deptry` for unused, missing and
  transitive dependencies.
- **Rust:** `cargo-machete` (stable toolchain) or `cargo +nightly udeps`, plus the `dead_code` lint.
  **Node:** `knip`.
- **The CLI-specific blind spot: a subcommand or flag with no in-code caller is not dead — users
  call it from a shell.** Anything registered by string (cobra, click, argparse, clap derive) and
  anything exposed through `[project.scripts]` or a `bin` entry has callers this repo cannot see.
  The `--help` test in **Standards harness** is the check that actually settles it: if a flag is
  documented and tested, it is live regardless of what the scanner says.
- **Env vars here are the honest exception:** a CLI reads its own env vars, so the repo *can* often
  prove it — but only if you also grep the shell completions, the man page and the README, which are
  part of the contract.

## Tracer slice
`flag/arg → logic → output (stdout + exit code) → it does the thing`. A slice is one subcommand
or one flag working end to end, including its error path. A flag that parses but does nothing is
not a slice.

## Verify like a user (`/verify-live`)
Run the **built** tool (not the source via a test runner) on real input:
- the happy path — correct stdout, exit code `0`;
- a bad-input path — a helpful error on stderr and a non-zero exit code;
- **install from clean** — install it the way a user will (`go install` / `npm i -g` / `pipx` /
  copy the script to PATH) into a fresh environment and run it there. A tool that only works in
  your dev checkout isn't done.
Paste the actual terminal output as evidence.

## What green tests can't prove here
- Exit codes and stderr behavior (scripts calling your tool depend on these).
- The clean-install experience — missing runtime, missing PATH entry, missing execute bit.
- Piping / redirection / non-TTY behavior (colors, prompts) vs an interactive terminal.
- Cross-platform path and line-ending assumptions.

## Definition of done
Built, installed from clean into a fresh environment, and run there with the real output and
exit codes captured. `--help` is honest and complete. For `/ship`: versioned, tagged, published
to the registry, then installed *from the registry* and run once more.
