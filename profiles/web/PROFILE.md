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
- Live exercise: see below

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
