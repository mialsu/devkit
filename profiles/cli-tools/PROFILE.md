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
- Live exercise: see below

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
