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
- A11y: the a11y linter over changed components (see **Design & accessibility**)
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

## Design & accessibility (`/design-brief`)
- **`DESIGN.md`** at the repo root — the surface inventory reconciled against the MVP cut, the
  flows, the states, and the `A11Y-n` rows that each name an enforcer.
- **The look is not devkit's to specify.** `ui-ux-pro-max --design-system` owns palette, type
  scale and style family; `/prototype`'s UI branch settles which layout wins, on the real route
  with real data. This profile insists on exactly two things: the tokens live in **code**, and `DESIGN.md`
  points at that file instead of copying its values.
- **`ui-ux-pro-max` supplies the rules; this profile supplies the enforcers.** `search.py --domain ux`
  is where the `A11Y-n` rows come from — 119 guidelines, WCAG 2.2 cited — and
  `--stack react|nextjs|vue|svelte|astro|shadcn|html-tailwind` is a build-time read for
  `/implement`, with `--domain react` covering rerenders, bundles and Suspense waterfalls. Two
  limits: `--design-system` is a **read**, never a `--persist` (its `MASTER.md` duplicates the token
  file the bullet above just put in code), and web's target-size bar is **24x24 CSS px** under WCAG
  2.2 — the 44pt/48dp figure in the dataset's mobile rows is native guidance and does not define web
  conformance.
- **Three a11y enforcers exist here and all three are cheap** — wire them in this order:
  `eslint-plugin-jsx-a11y` or the framework equivalent `[lint]`; `axe` asserted in the Playwright
  walk **once per state**, empty and error included `[test]`; and the keyboard walk itself `[live]`.
  Verify the current package before wiring it (`/harness` step 1) — then break each one on purpose
  and watch it go red, or it is not a gate (PRINCIPLES #2).
- **Reflow is the cheapest a11y test you are not running.** `A11Y-7` (WCAG 1.4.10) needs one
  Playwright viewport of 320x640 and the same assertions you already have — no new tool, no new
  fixture. Run it over *each* state, not the loaded happy path, because the error state with a long
  message is where a layout breaks first.
- **Contrast is measured, never intended.** Compute the ratio from the real token values. A pair
  that misses 4.5:1 is a debt entry with a number in it, not a rounding error.
- **What no a11y gate catches:** screen-reader *quality* — `axe` finds a missing accessible name,
  not a useless one ("button", a div announced as a 14-item list); a focus order that is technically
  valid and practically baffling; a live region that announces the wrong thing at the wrong moment;
  and a layout that collapses under a 60-character name or ten thousand rows.

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

## Dead code & duplication (`/prune`)
- **Two altitudes, and only one belongs in the gate set.** Unused imports and locals are a
  *lint*: `@typescript-eslint/no-unused-vars`, plus `noUnusedLocals` / `noUnusedParameters` in
  `tsconfig.json`. Those run on every commit. The repo-level sweep — unused files, exports, types
  and dependencies — is **`knip`**, which understands framework entry points through its plugins
  and has largely absorbed what `ts-prune` and `depcheck` used to do separately. Run it
  periodically, not per-commit.
- **Duplication candidates:** `jscpd` finds copy-paste across the tree. It is a *candidate
  finder*, never an authority — every row still has to pass `/prune`'s three tests before anything
  merges.
- **The five blind spots here, all of them common:** meta-framework file conventions (`app/page.tsx`,
  `routes/`, `+page.svelte`, middleware) that no import points at; a barrel re-export making the
  whole subtree look reachable — the reason `/setup-ts-deep-modules` discourages barrels; dynamic
  `import()` on a computed path; component maps keyed by string; and exports used only by Storybook
  or tests, which are real users or real dead code depending on a judgement call.
- **Env vars are not decidable in this repo.** `import.meta.env` / `process.env` greps plus
  `.env.example` give you a list; the host (Vercel, Netlify, Fly, the container spec) holds the
  truth. Report, never delete.

## Security surface (`/audit`)
- **The strongest authz enforcer here is the database, not the code.** A row-level policy or a
  constraint holds when a new route forgets; a service-layer check holds only for the paths that
  remember. This is the same argument the **Domain dial** above makes for `constraint:` over
  `test:`, and it matters most for the rules an attacker actually probes.
- **Check every route, not every page.** The classic hole in an agent-built app is a page that
  guards itself and an API route serving it that does not — the page was the thing being looked at,
  so the check landed there. Enumerate handlers, not screens.
- **`NEXT_PUBLIC_` / `VITE_` / `PUBLIC_` prefixed values are public by design** — they are compiled
  into the bundle and shipped to everyone, permanently. A key that reached one is already leaked and
  needs rotating, not renaming.
- **Over-fetching is invisible on screen and total in the response:** the handler returns the whole
  row and the UI renders three fields. Read the JSON, not the component.
- **Also specific to here:** a CORS wildcard combined with credentials; missing CSRF protection when
  auth is cookie-based; source maps served in production; a debug or seed route that survived.
- **Tools:** `gitleaks` over the **full history** (a pre-commit hook is the gate that keeps it
  clean); the package manager's `audit` command; `semgrep` for injection and taint patterns;
  `eslint-plugin-security` if the repo is already ESLint-centric. Verify each fits before wiring
  (`/harness` step 1).

## Tracer slice
`data model → API/endpoint → screen → real copy → it actually does the thing`. A slice is one
user-visible capability working end to end, demoable alone. No screens over absent APIs; no
endpoints with no screen.

## Verify like a user (`/verify-live`)
Real browser (Playwright or by hand), real navigation, real login as the **real persona** —
including a restricted, non-admin user, because admin bypasses the permission checks you most
need to test. Perform the real mutation. Screenshot each key state, **including empty and error
states**. On the deployed build for `/ship`, confirm the served version matches what you merged.

**Keyboard-only pass, every time.** Complete the primary flow with the mouse untouched — Tab,
Shift-Tab, Enter, Space, Escape. Focus visible at every step, order following reading order, no
control reachable by pointer alone, no trap you cannot Escape out of. Then run `axe` against each
state you screenshotted, not only the loaded happy path. This walk *is* the enforcer for `A11Y-1`
and `A11Y-2`: skip it and those rows are `[review-only]`, and the confession has to say so.

**Watch the focus ring, not only the tab order.** A sticky header, a cookie banner or a chat widget
that covers the focused control passes every tab-order assertion and still fails WCAG 2.2 AA
(`A11Y-9`). Tab through the flow with the page scrolled so focus lands at both the top and the
bottom of the viewport.

## What green tests can't prove here (watch for these)
- Stale client cache / persisted filters hiding new data (version your persisted-state keys).
- A global setting (locale, theme) leaking across the whole app from one preference.
- String-vs-number id comparisons in permission checks (passes as admin, denies everyone else).
- Two UI entry points to one operation diverging — route both through one function.

## Definition of done
Deployed, and clicked through as a user on the deployed URL — not localhost — with the version
string confirmed. Copy in the user's language; no raw IDs, fake zeros, or "coming soon" on any
surface.
