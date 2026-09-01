# Profile — Library / package

A reusable library or package. The product is the **public API and its documentation** — other
people's code is the user. That reframes "verify like a user": you consume your own API exactly
as an installer would, and the docs are part of the deliverable, not an afterthought.

## Stack defaults (adapt freely)
- The ecosystem's standard package layout and manifest (npm / PyPI / crates.io / Go module).
- A clean public surface (an explicit `index`/`__init__`/`lib.rs` exports list) — everything else
  is private. The interface is the test surface.
- Tests: unit against the public API + doc examples that are executed, not just shown.

## Gate set (green before every commit)
- Typecheck / compile including the **published type surface** (`.d.ts` / stubs / public docs)
- Lint/format
- Tests: the public-API suite; **documented examples compile and run** (doctest / example test)
- Build: the distributable artifact builds (bundle / wheel / crate)
- Public-API check: no unintended breaking change (semver diff tool where one exists)
- Boundaries: `<boundary cmd>` — the entry-point rule IS the library discipline (see **Standards harness**)
- Drift: `scripts/drift-check.sh --cached`
- Live exercise: see below

## Domain dial (default: **off** — the public API *is* the language)
- **Why off:** for a library, the exported names are the ubiquitous language, and the surface gate
  already enforces them. `CONTEXT.md` plus the API report covers what a separate model would say.
- **Turn it on when the library *is* a domain** — money, tax, dates/timezones, units, permissions.
  Then invariants are the library's actual contract, and they are the best-enforced invariants in
  any profile: **property tests** (`test:prop_*`) hold them across inputs no example test would try.
- **Invariants worth writing:** round-trip identity (parse ∘ format = id), commutativity and
  associativity where claimed, monotonicity, and every documented error condition — a promise in
  the README with no test is `[review-only]`, so label it.
- **`mapped` essentially never.** A library with two bounded contexts is two libraries.

## Design & accessibility (`/design-brief`)
**Default: do not run it, and do not create `DESIGN.md`.** A library's surface is its public API,
and `codebase-design` plus the public-surface gate above already own that better than a design
document would. An absent file is honest here; an empty one is the pseudo-artifact.

Two exceptions, both narrow:
- **The library ships UI components.** Then accessibility *is* the public contract, not a quality
  bar — a consumer cannot fix an unlabelled button inside your component. Every `A11Y-n` row becomes
  a `[test]` in the component suite, and each documented a11y promise in the README gets one, or it
  is `[review-only]` and the README should not claim it.
- **The library renders human-facing output** (a formatter, a reporter, a CLI-adjacent printer).
  Then borrow the cli-tools state table: `NO_COLOR`, non-TTY, no meaning in alignment alone.

## Standards harness (`/harness`)
- **`CODING_STANDARDS.md`** at the repo root — the file `/code-review`'s Standards axis reads.
- **Boundary gate:** for a library the entry-point rule *is* the product discipline — the public
  surface is what you ship. `/setup-ts-deep-modules`' `dependency-cruiser` config enforces exactly
  that (root files public, subfolders private, tests go through the entry points, no cycles).
  Non-TS: the ecosystem's visibility system is the gate — `pub`/`pub(crate)`, package-private,
  `__all__` plus `import-linter`, unexported Go identifiers.
- **Public-surface gate:** a surface-diff tool so an accidental breaking change fails the build
  rather than a user's install (`api-extractor` / `@arethetypeswrong/cli` for TS,
  `cargo-public-api` for Rust, an apidiff for Go). Verify the tool fits before wiring it.
- **Drift gate:** `scripts/drift-check.sh` — with `CONTEXT.md` terms mattering more here than
  anywhere else, because your vocabulary *is* your API and renaming it later is a breaking change.
- **What no harness here catches:** whether the documented examples still run. That's the live
  exercise, and it's the one that catches README drift.

## Dead code & duplication (`/prune`)
- **The default inverts: for a library, "unreferenced in this repo" proves nothing about anything
  exported.** Your callers are people you cannot grep. Dead code in a library means *internal* code
  only, and every scanner has to be told the public entry points are roots (`knip`'s `entry` and
  `exports` config, `#[allow(dead_code)]` on the crate surface, `__all__`) or it will cheerfully
  propose deleting the product.
- **Deleting a public export is a breaking change, not a prune.** It never rides in a sweep commit:
  it goes through the deprecation path, the public-surface diff tool named in **Standards harness**
  (`api-extractor`, `cargo-public-api`, an apidiff), and a major version. `/prune` may *list* an
  export it suspects nobody uses; the removal is a product decision.
- **Internal sweeps are still worth it** and are unusually safe here, because the entry-point
  boundary gate already tells you what is internal: anything in a subfolder, unreachable from a root
  file, with no test through the interface.
- **The duplication that matters is between the code and the docs.** An example in the README or a
  docstring that no longer compiles is dead code with a wider audience than any private helper —
  the live exercise below is what catches it.

## Security surface (`/audit`)
- **You are shipping the attack surface into other people's applications.** A flaw here is not your
  incident, it is theirs, multiplied by every dependent — which raises the impact axis on findings
  that would be minor in an app.
- **Validate at the public surface, because you cannot assume the caller did.** Every entry point
  takes input that reached it from somewhere you cannot see, and "the caller should have checked" is
  not a control.
- **The two that are genuinely library-shaped:** a regex applied to caller-supplied input
  (catastrophic backtracking is a denial of service you hand to your users), and, in JS, prototype
  pollution through any deep merge, clone, or path-set helper.
- **Your dependencies become your callers' dependencies.** Dependency hygiene matters more here than
  in any application — a transitive advisory is your problem, and a new runtime dependency is
  already an ADR under **Dependencies & reuse**.
- **Never put a caller's value into an exception message or a log line.** You do not control where
  their logs go, and a token in a stack trace is a leak with your name on it.
- **This is the one profile where `SECURITY.md` belongs** — in its GitHub sense: how someone reports
  a vulnerability to you privately. That is a disclosure contract, not a threat model, and it is a
  different document from anything `/audit` produces.
- **Tools:** the ecosystem's audit command; `gitleaks` over full history; `semgrep`. The
  public-surface diff tool named in **Standards harness** doubles as a security control — an
  accidentally exported internal is a surface you did not mean to defend.

## Tracer slice
`type / signature → implementation → test through the public interface → a runnable doc example`.
A slice is one public capability an installer can import and use, with the example that proves
it. Test through the public interface, never the internals.

## Verify like a user (`/verify-live`)
Consume your own package **as an outside user**: in a scratch project, install the built artifact
(pack + install locally: `npm pack` then install the tarball / `pip install .` into a fresh venv
/ `cargo publish --dry-run` + a local path dep), then `import` it by its public name and run the
documented examples verbatim. If the README example doesn't run as written, that's a BROKEN
verdict, not a doc nit.

## What green tests can't prove here
- The published surface differs from what tests import (internal test helpers leaking; wrong
  `exports`/`files` manifest; missing type declarations).
- README/doc examples drifting out of sync with the real API.
- Accidental breaking changes — a renamed export, a changed default, a narrowed type.
- Peer-dependency / version-range assumptions that only bite in a clean install.

## Definition of done
Built, installed from the packed artifact into a clean project, imported by its public name, and
the documented examples run verbatim. Semver intent is explicit. For `/ship`: version + changelog,
publish, then install *from the registry* into a clean environment and run the examples once more.
