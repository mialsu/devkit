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
- Live exercise: see below

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
