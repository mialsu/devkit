---
name: design-brief
description: Turn a product brief into a design contract — a surface inventory reconciled against scope, flows, states, components, and accessibility rules that each name their enforcer. Delegates the look (palette, type, style family, copy) to ui-ux-pro-max and the "which layout wins" question to /prototype. Use when a project is about to build its first UI, or when the user says "design brief", "act as a product designer", "screen inventory", "user flows", "design system", or asks how the surface should be shaped.
disable-model-invocation: true
argument-hint: "[project or feature]"
---

Design sits between the brief and the spec: after `/product-brief` has settled *what the product
does*, before `/to-spec` settles *how a slice gets built*. It produces `DESIGN.md` (template in
devkit `templates/`) once per project, and a `Screens & states touched` block in each spec after.

**Your stance is a product designer** — which here means you own the *shape* of the surface and the
*honesty* of its states, and you own neither the product's decisions nor the project's aesthetics.
Both of those already have owners, named below.

## What this skill does NOT write (reuse before building)
Most of what a design brief traditionally contains already belongs to an installed skill. Adopt
their formats; do not grow a second one.

| Thing | Owner | How to use it |
|---|---|---|
| Palette, type scale, spacing, the style family, font pairing, UI copy | **`ui-ux-pro-max`** — `search.py "<product> <industry>" --design-system` | Invoke it when the UI is actually built, never here. 192 product palettes with reasoning profiles, 74 font pairings, 79 styles, and the `--variance`/`--motion`/`--density` dials; its 119 UX guidelines carry the empty-state and error-message rules. `DESIGN.md` records only *where the tokens live in code*. Never `--persist` — its `MASTER.md` puts a `--space-*` token table beside the one in code, and a one-pass file nobody read is the pseudo-artifact its own `SKILL.md` warns against |
| Copy **voice**, and ASCII wireframes | **nobody — the Owner, with `/code-review` as the backstop** | The dataset holds the empty-state and error-message *rules* (guidelines 79, 80 and 44) but not the craft: that errors do not apologise, and an empty screen is an invitation to act. Write that yourself. It is `[review-only]` by construction, and it is the one thing moving the look to `ui-ux-pro-max` cost |
| "Which of these three layouts is right?" | **`/prototype`** (mp), UI branch | N radically different variants on the *real* route with *real* data, switchable by a URL param. Prose cannot settle a layout; flipping between them can, and a variant judged in isolation always looks fine |
| Mockups the Owner wants to push pixels around in | **`/design`** (canvas artboards), where available | Only when they would rather edit the design by hand than in code |
| A library's public API, or any module's interface | **`codebase-design`** | A library's "design" *is* its API surface. This skill is the wrong tool for it |
| What the user is **told** in an edge case | **the brief's edge-cases section** | Already decided at product altitude. Cite it. Never re-answer it |

What is left is what neither source covers: scope reconciliation, state coverage, and accessibility
with real enforcers. That is this skill, and it is deliberately small.

## Procedure

1. **Check the profile first, and be willing to talk the Owner out of this.** Read
   `profiles/<domain>/PROFILE.md`.
   - **web / mobile-fullstack** → run the whole thing.
   - **game** → the surfaces are HUD and menus; whether the mechanic *feels* right is the profile's
     live exercise, not a document. Run sections 1, 3, 5, 6 only.
   - **cli-tools** → no screens, but unmistakably a surface: command shapes, the stdout contract,
     error text, exit codes, TTY vs pipe, `--help`. Run 1, 2, 3, 6; say plainly that 4 and 5 do not
     apply rather than inventing content for them.
   - **library** → the surface is the public API and `codebase-design` owns it. Recommend *not*
     writing this file, and say why. An absent document is honest; an empty one is not.

2. **Ground in the brief, then reconcile the inventory both ways.** List every surface against the
   MVP-cut bullet it serves, and report both directions out loud before anything else:
   - a **surface serving no bullet** is scope creep, and design is the cheapest place it will ever
     be caught. Recommend cutting it — the Owner decides.
   - a **bullet with no surface** is a gap in the cut, found before the slice is built, which is
     cheaper still.
   Neither belongs buried in a table. Both go in the report.

3. **Walk each flow in one line.** Entry → steps → payoff, plus the exit that is not success. A
   flow that needs a paragraph is either two flows or not understood yet.

4. **Fill the state table by citing the brief.** Empty, refused and error were decided at product
   altitude — carry those answers over and render them. **Loading is yours alone:** no product
   decision sits behind it, so set the thresholds here instead of reaching for a spinner during the
   build. What renders instantly, what waits for real data, and what must never flash a spinner
   because it usually resolves in 50ms. If rendering a state proves the product answer wrong, that
   is an edit to the brief *plus* a spec delta — never a quiet second answer in `DESIGN.md`.
   **Then ask the width question once:** what is the narrowest viewport this supports? Every state
   in the table has to hold there, and the error state carrying a long message is where a layout
   actually breaks. It lands as `A11Y-7` rather than a prose paragraph, because reflow at 320px is a
   WCAG criterion with a real test behind it, not a preference.

5. **Give every accessibility rule an enforcer, or label it honestly.** This is the section the
   method actually contributes, and the rule is PRINCIPLES #11's: a rule naming no enforcer is prose.

   **Take the rows from the dataset, not from memory.** `ui-ux-pro-max`'s `search.py --domain ux`
   holds 119 guidelines with stable ids and WCAG 2.2 citations, and it covers criteria the template's
   eight examples do not: `focus-not-obscured`, `dragging-alternative`, `web-target-size`,
   `accessible-authentication`, `redundant-entry`, `consistent-help`, `auto-rotation-controls`.
   Query **one observable outcome at a time** — `"focus not obscured" --domain ux`, not a sweep —
   and verify the returned id fits this product and platform before it becomes a row. Then do the
   half the dataset has no opinion on:
   - `[lint]` — the ecosystem's a11y linter, wired into the profile's gate set, not merely installed.
   - `[test]` — `axe` or the platform equivalent, run against **each state** in §3, not the happy one.
   - `[live]` — the keyboard walk: the whole flow with the mouse unplugged. A real enforcer that
     happens to be human-run, and it catches what no linter can.
   - `[review-only]` — for what nothing checks, meaning-by-colour-alone chief among them.

   Then **measure** the contrast ratios against the real tokens: an intended ratio is not a ratio,
   and a failing pair is a debt entry rather than a rounding error. And per PRINCIPLES #2, a gate
   you have not watched fail is not a gate — delete a label or a focus style on purpose, watch the
   linter or `axe` go red, revert. Until you have, the row is aspiration.

6. **Delegate the look, and hand the delegation forward.** Choose no palette here. When the first
   UI slice is built, `ui-ux-pro-max --design-system` does that work; where more than one layout
   is plausible, `/prototype`'s UI branch lets the Owner flip between variants against real data.
   `DESIGN.md` records only the path where the tokens live.

   **Then write it where it will still be read.** This skill stops before the UI exists, so an
   "invoke `ui-ux-pro-max` at build time" note left *here* is out of context at the moment it
   applies. Confirm the project's `CLAUDE.md` carries the **Surface work** section
   (`templates/CLAUDE.md` ships it) — that file loads every session, which is the only reason the
   delegation survives this skill's own STOP. If the project predates that section, add it now.

7. **The acid test is the Owner's, not yours.** Ask them to recite the main flow, and name the four
   states of the primary surface, **with the file closed**. If they cannot, this is a
   pseudo-artifact in progress: cut it until they can. A short design contract that is genuinely
   held in the head beats a complete one nobody has read — that is the whole lesson of the
   anti-pattern.

8. **Report and confess.** Report the step-2 reconciliation findings, the holes in the state table,
   which accessibility rows came out `[review-only]`, and every contrast pair that failed or went
   unmeasured. Each of those is a `/confess` entry: an accessibility claim with no enforcer is
   precisely what the ledger exists to keep visible.

Then STOP. This skill shapes the surface; it does not build it.
