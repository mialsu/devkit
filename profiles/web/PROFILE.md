# Profile — Web dev

Frontend / full-stack web apps. This is the domain the source method was proven on, so its
disciplines transfer most directly.

## Stack defaults (adapt freely)
- TypeScript. React / Vue / Svelte + Vite, or a meta-framework (Next / Nuxt / SvelteKit).
- A typed data layer (tRPC / GraphQL + codegen / typed REST client).
- Tests: Vitest/Jest (unit) + a component test layer + Playwright for the live walk.

## Gate set (green before every commit)
- Typecheck: `tsc --noEmit` (or `vue-tsc` / framework equivalent)
- Lint: `eslint` over changed files
- Tests: the unit + component suite for the touched area
- Build: the production build succeeds (`vite build` / `next build`)
- Boundaries: `<boundary cmd>` (see **Standards harness**)
- Drift: `scripts/drift-check.sh --cached`
- Live exercise: see below

## Domain dial (default: **on**)
- **Why on:** a web app almost always carries permissions or money, and it outlives a month — two
  triggers, which is the bar (METHOD.md).
- **Invariants worth writing:** who may see or change a row and why (not just "is logged in"),
  money that must reconcile, any status that can only move one way, uniqueness a user can observe.
- **Enforcers here are cheap and strong:** a DB constraint or a unique index beats a service-layer
  check, because it holds even when a new code path forgets. Prefer `constraint:` over `test:` when
  the database can express the rule.
- **`mapped` only when a word collides** — the `User` billing means vs. the `User` the editor means.
  A monorepo's packages, an `app/` vs `api/` split, and "it's getting big" are **not** context
  splits; they're layers and deployment units.

## Standards harness (`/harness`)
- **`CODING_STANDARDS.md`** at the repo root — the file `/code-review`'s Standards axis reads.
- **Boundary gate:** `dependency-cruiser`, installed by the Pocock skill `/setup-ts-deep-modules`,
  which ships a working config (a package's root files are its public surface, subfolders are
  private, no cycles) and proves its own rules bite. Then fill the piece it leaves empty on
  purpose — its `// Layering (optional, off by default)` stub — with which area may depend on
  which. Script it as `lint:boundaries` (`depcruise src`) and fold it into the umbrella check.
  `eslint-plugin-boundaries` is the alternative if the repo is already ESLint-centric.
- **Drift gate:** `scripts/drift-check.sh` — vocabulary from `CONTEXT.md`, suppressions without a
  confession, undeclared dependencies, stray lockfile moves, oversized new files.
- **What no harness here catches:** whether the seam is in the *right place*, runtime coupling
  through a store/context/DI container, and prop-drilled state that no import graph can see.

## Tracer slice
`data model → API/endpoint → screen → real copy → it actually does the thing`. A slice is one
user-visible capability working end to end, demoable alone. No screens over absent APIs; no
endpoints with no screen.

## Verify like a user (`/verify-live`)
Real browser (Playwright or by hand), real navigation, real login as the **real persona** —
including a restricted, non-admin user, because admin bypasses the permission checks you most
need to test. Perform the real mutation. Screenshot each key state, **including empty and error
states**. On the deployed build for `/ship`, confirm the served version matches what you merged.

## What green tests can't prove here (watch for these)
- Stale client cache / persisted filters hiding new data (version your persisted-state keys).
- A global setting (locale, theme) leaking across the whole app from one preference.
- String-vs-number id comparisons in permission checks (passes as admin, denies everyone else).
- Two UI entry points to one operation diverging — route both through one function.

## Definition of done
Deployed, and clicked through as a user on the deployed URL — not localhost — with the version
string confirmed. Copy in the user's language; no raw IDs, fake zeros, or "coming soon" on any
surface.
