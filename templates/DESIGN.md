# DESIGN.md — <project>

The project-once design contract: what the surface is made of, and which of its rules are actually
enforced. Written by `/design-brief`, before the first UI slice, and re-read before every one after.

**Deliberately small.** Three things belong somewhere else and are only *pointed at* from here:

| Not in this file | Where it lives | Why not here |
|---|---|---|
| Palette values, type scale, spacing steps | the token file in code (`tokens.css`, a theme module, the platform equivalent) | a token table here *plus* tokens in code is two implementations of one thing — they drift, and then both are suspect |
| Aesthetic direction, wireframes, UI copy | the `frontend-design` skill, applied when the UI is built | that skill owns the format (palette as named hex values, 2+ type roles, ASCII wireframes, copy that never apologises). Reuse it; do not grow a second one here |
| Which layout wins | a `/prototype` UI run — N variants on the real route with real data | a layout argued in prose has no verdict. One you can flip between in the browser does, and *"every variant looks fine in isolation"* |

**Not every project has screens.** For **cli-tools** the surfaces are commands and the states are
stdout/stderr/exit codes — keep sections 1, 2, 3 and 6 and delete the rest. For **library** the
surface is the public API, which `codebase-design` and the API report already cover; this file is
usually not worth having, and saying so beats keeping an empty one.

## 1. Surface inventory
Every surface, and the MVP-cut bullet it serves. This is a **scope** document before it is a
picture, so reconcile it *both ways*:
- a surface serving no bullet is scope creep — caught in design, which is the cheap place;
- a bullet with no surface is a gap — caught before the slice is built, which is cheaper still.

| Surface | Serves (brief's MVP cut) | Slice | Status |
|---|---|---|---|
| <screen / command / view> | <the MVP-cut bullet, quoted> | <tracer slice n> | planned / built |

- **Bullets with no surface:** <bullet> — or `none`
- **Surfaces serving nothing:** <surface> — or `none`, which is the only good answer here

## 2. Flows
The paths through those surfaces, one line each. A flow you cannot recite with this file closed is
a pseudo-artifact; shorten it until you can.
- **<flow name>:** <entry> → <step> → <step> → <payoff>. Ends early when: <the exit that isn't success>

## 3. States
Three of these were **already decided at product altitude** in `PRODUCT-BRIEF.md` — its edge-cases
section owns *what the user is told*; this section owns *how that looks*. Cite it, never re-answer
it. If design proves the product answer wrong, that is an edit to the brief plus a spec delta, not
a second answer living here.

| Surface | Empty (brief) | Loading | Refused / error (brief) | Success |
|---|---|---|---|---|
| <surface> | <how the brief's answer renders> | <what appears, and after how long> | <how the brief's answer renders> | <how the user knows it worked> |

**Loading is the one state design owns outright** — no product decision sits behind it; it exists
only because the machine takes time. Decide the thresholds before a spinner becomes a reflex: what
renders instantly, what waits for real data, and what must *never* flash a spinner because it
usually resolves in 50ms. A skeleton that flickers is worse than one that never appeared.

## 4. Components
The shared pieces, so the second surface reuses the first one's work instead of forking it. Worth
keeping only while it stays short — once it lists every wrapper element, it is an inventory nobody
reads, and deleting it is the honest move.
- **<Component>** — <the single job it does> — used by: <surfaces>

## 5. Accessibility — every line names its enforcer
PRINCIPLES #11 applied to the surface: **an accessibility note with no enforcer is decoration.**
Every row carries a tag, and an honest `[review-only]` beats a tag the project has not wired.
`[live]` means a `/verify-live` recipe proves it — the keyboard walk is a real enforcer, just a
human-run one, and it catches what no linter can.

| # | Must be true | Enforced by | Tag |
|---|---|---|---|
| A11Y-1 | Every interactive element is reachable *and* operable with the keyboard alone | `live:keyboard-walk` — the whole flow, mouse unplugged | `[live]` |
| A11Y-2 | Focus is always visible, and focus order follows reading order | `live:keyboard-walk` | `[live]` |
| A11Y-3 | Every control has an accessible name (no icon-only button without a label) | `lint:<a11y plugin>` + `test:axe` | `[lint]` |
| A11Y-4 | Text contrast is at least 4.5:1 — 3:1 for large text and UI boundaries | `test:axe`, run against **each** state in §3 | `[test]` |
| A11Y-5 | Nothing conveys meaning by colour alone | nothing — a human has to look | `[review-only]` |
| A11Y-6 | `prefers-reduced-motion` is respected | <test name, or nothing> | `[test]` / `[review-only]` |

Contrast, measured against the real tokens rather than intent — an intended ratio is not a ratio:

| Foreground on background | Ratio | Verdict |
|---|---|---|
| <token on token> | <n.n:1> | AA / **fails, and here is the debt entry** |

## 6. What no gate here catches
The honest list, because §5's tags make the *rest* of this file look more enforced than it is:
- whether the flow makes sense at all, or the empty state actually invites action;
- **screen-reader quality** as opposed to the mere presence of labels — `axe` finds a missing name,
  not a useless one ("button", "click here", a div announced as a list of 14 items);
- whether the design survives real content: a 60-character name, a zero, a negative number, one
  item, ten thousand items;
- everything in §2 and §4, which are `[review-only]` in their entirety.
