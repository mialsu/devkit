# Product Brief — <IDEA>

The Stage 0 artifact: what this product is, at product altitude, *before* any repo or tech
exists. Written by interview (`/product-brief`), not one-shot. It stays lean and grows only as
assumptions get validated — its job is to separate **vision** (why) from **MVP scope** (what
now) from **the deferred backlog** (what later), so the binding-vs-elaboration line is visible.

**Standard rules (the anti-trap):**
- No tech stack, no schemas, no API design here. Those are decided at shaping/build. If you're
  writing `CREATE TABLE`, you're in the wrong document.
- Everything asserted as scope must be either the problem, the core value, or the MVP cut.
  Anything else is elaboration → it goes in Non-goals or Open questions, not in scope.
- Every number (price, conversion, adoption) is an **assumption** until tested — mark it so.
- If there's no lovable MVP and no cheap test for the #1 risk, the idea isn't ready to build.

---

## 1. One-liner & problem
- **One-liner:** <the product in one sentence a stranger understands>
- **Who hurts, and how much:** <the specific person and the pain, concrete — not "travelers struggle">
- **How they cope today:** <the current clunky workaround this replaces>

## 2. Vision — the change if we win
One short paragraph. The world after this exists. Aspirational is fine *here* (and only here).

## 3. Users & jobs-to-be-done
Personas as **jobs**, not demographics. "When I ___, I want to ___, so I can ___."
- <persona> — job: <the job they hire this product to do>

## 4. The core loop — the ONE lovable interaction
The single interaction that has to feel great or nothing else matters. If you can only ship one
thing, this is it. Describe it as a user walking through it, start to payoff.

## 5. MVP cut — the walking skeleton (what's IN)
The smallest version that delivers the core loop end to end and is lovable, not just functional.
A short bullet list. Each bullet is a candidate spec later.
- <in>

## 6. Non-goals / not now (what's OUT)
Everything deliberately deferred — the "v2 epics" that feel essential but aren't, yet. Be
generous here; this is where scope creep dies. Move things here the moment you doubt them.
- <deferred> — revisit when: <the signal that makes it worth doing>

## 7. Riskiest assumptions & how we'll test them (cheapest first)
The most important section. Rank by "if this is false, the product is dead." For each: the
cheapest test that could falsify it — a landing page, 5 user chats, a paper prototype, a spike.
| # | Assumption (stated as falsifiable) | Cheapest test | Result |
|---|---|---|---|
| 1 | <the one that kills it if wrong> | <test> | untested |

## 8. One-way vs two-way door decisions
- **One-way (hard to reverse — decide carefully now):** <e.g. a data-ownership or trust model>
- **Two-way (reversible — defer, pick the easy default):** <e.g. framework, hosting, colors>

## 9. Open questions (for us / for customers)
Ambiguities to resolve with a human, not by assumption.
- <question>

## 10. Tech — DEFERRED
No stack or schema decided here, on purpose. Note only hard *constraints* that are genuinely
product-level (e.g. "must work offline", "must run on a phone", "single-developer maintainable").
Actual technology is chosen at `/grill-with-docs` → `/to-spec`.
- Product-level constraint: <constraint>

## 11. Success signals
What would tell you it's working, at MVP scale — lightweight, real, and observable soon. Not a
KPI dashboard for a product that doesn't exist yet.
- <signal>
