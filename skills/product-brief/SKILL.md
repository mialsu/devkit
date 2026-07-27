---
name: product-brief
description: Turn a raw product idea into a lean, validated product brief BEFORE any repo or tech exists — Stage 0 of the method. Use when the user has a new product idea/concept, says "product brief", "PRD", "should we build this", "flesh out this idea", or hands you a vision doc to pin down.
disable-model-invocation: true
argument-hint: "[idea name]"
---

High-level product design lives *before* `/new-project`. This skill produces a
`PRODUCT-BRIEF.md` (template in devkit `templates/`) that separates **vision** (why) from **MVP
scope** (what now) from the **deferred backlog** (what later). It is interview-driven — never a
one-shot document dump, because a one-shot PRD asserts scope it hasn't earned.

## The anti-trap (why this stage exists)
The failure mode is the impressive "everything document": vision + full feature set + monetization
+ tech stack + schemas + KPIs, stamped "approved", before a single assumption is tested. Guard
against it, hard:
- **No tech here.** No stack, no schema, no API. If you're tempted, the answer is "decided at
  shaping." Capture only genuine product-level *constraints* (offline, on-a-phone, solo-maintainable).
- **Binding beats elaboration.** Only the problem, the core value, and the MVP cut are scope.
  Everything else is Non-goals or Open questions.
- **Every number is an assumption** until tested — price, conversion, adoption, revenue split.

## Procedure
1. **Ground first.** Read whatever the user has (a vision doc, notes). If a market or comparable
   matters, dispatch `/research` (mp) against primary sources — don't guess at what exists.
2. **Interview via `/grilling` (mp)** — one question at a time, each with a recommendation,
   plain language. Drive toward the brief's sections, spending the most effort on:
   - the **core loop** — the single interaction that must be lovable;
   - the **MVP cut** — push relentlessly for *smaller*; every feature the user calls essential,
     ask "does the core loop work without it?" If yes, it's a non-goal for now.
   - the **riskiest assumption** — name the one thing that, if false, kills the product, and the
     *cheapest* test that could falsify it (landing page, 5 user chats, paper prototype, a
     `/prototype` (mp) spike). This is the real output; a brief with no test plan isn't done.
3. **Separate one-way from two-way doors.** Decide the few hard-to-reverse things now; explicitly
   defer the reversible ones (usually all the tech).
4. **Write `PRODUCT-BRIEF.md`** from the template. Keep it lean — cut any section that's
   speculation dressed as fact. Seed `CONTEXT.md` vocabulary from it; record any genuinely
   one-way decision as an ADR.
5. **Gate, then hand off.** State plainly: is there a lovable MVP, and can the #1 assumption be
   tested cheaply? If not, the next step is a validation experiment, NOT `/new-project`. If yes,
   hand off: the platform reality in the brief picks the domain profile for `/new-project`, and
   each MVP-cut bullet becomes a spec via `/grill-with-docs` → `/to-spec`.

Report the brief, the riskiest assumption + its test, and the recommended next step (validate,
or bootstrap). Then STOP — building starts only on the user's explicit go.
