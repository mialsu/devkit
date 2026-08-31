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
- **Stories and criteria are spec-altitude.** One job per persona belongs here (§3); the long
  numbered `US-n` list and the acceptance criteria that cite it belong to each MVP-cut bullet's
  spec. Two `US-n` sets in one repo fork the id scheme.
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

A job *is* the product-altitude user story — the same three parts, one per persona instead of an
exhaustive list. The extensive `US-n` list lives in the spec (`templates/spec/SPEC-template.md`),
where each acceptance criterion cites it by tag.

## 4. The core loop — the ONE lovable interaction
The single interaction that has to feel great or nothing else matters. If you can only ship one
thing, this is it. Describe it as a user walking through it, start to payoff.

## 5. MVP cut — the walking skeleton (what's IN)
The smallest version that delivers the core loop end to end and is lovable, not just functional.
A short bullet list. Each bullet is a candidate spec later.
- <in>

## 6. Edge cases & honest failures
The states that aren't the happy path. They are decided **here**, at product altitude, because
each one is a decision about *what the user is told* — not a bug to be found later in QA. This
document's own rules forbid placeholder answers: no "coming soon", no silent failure, no
placeholder dressed up as real. A labelled honest state, or nothing.

Four that apply to almost everything — answer each, or mark it genuinely not-applicable:
- **Empty** — the very first run, before any data exists.
- **Refused** — the user asks for something the rules don't allow. What do they see, in their
  words, and does it tell them what to do instead?
- **Stale / gone** — what they were looking at changed or vanished while they were looking at it.
- **Broken** — the network, a dependency, or the device failed. What still works?

| Edge case | What the user sees, in their words | Settled? |
|---|---|---|
| <the not-happy-path state> | <the honest answer> | yes / **open question (§10)** |

Stay at this altitude: *what the user is told* belongs here; the criterion that **proves** it
belongs in the spec's AC table; a rule that must never break belongs in `INVARIANTS.md` with an
enforcer. An edge case you cannot answer yet is an open question, never a silent assumption.

## 7. Non-goals / not now (what's OUT)
Everything deliberately deferred — the "v2 epics" that feel essential but aren't, yet. Be
generous here; this is where scope creep dies. Move things here the moment you doubt them.
- <deferred> — revisit when: <the signal that makes it worth doing>

## 8. Riskiest assumptions & how we'll test them (cheapest first)
The most important section. Rank by "if this is false, the product is dead." For each: the
cheapest test that could falsify it — a landing page, 5 user chats, a paper prototype, a spike.

**A working thin slice can be the test.** When building the core-loop slice costs less than the
experiment that would validate it — often true now that an agent does the building — then
*shipping that slice to real users IS the test*, and usually a more informative one (real UX
friction, real data problems, whether the loop even feels good). The discipline that stays: the
build is pointed squarely at the #1 assumption and reaches real users; "we'll learn stuff"
without a named question and a real audience is just building in a vacuum.

| # | Assumption (stated as falsifiable) | Cheapest test (may be a shipped thin slice) | Result |
|---|---|---|---|
| 1 | <the one that kills it if wrong> | <test> | untested |

## 9. One-way vs two-way door decisions
- **One-way (hard to reverse — decide carefully now):** <e.g. a data-ownership or trust model>
- **Two-way (reversible — defer, pick the easy default):** <e.g. framework, hosting, colors>

## 10. Open questions (for us / for customers)
Ambiguities to resolve with a human, not by assumption.
- <question>

## 11. Tech — DEFERRED
No stack or schema decided here, on purpose. Note only hard *constraints* that are genuinely
product-level (e.g. "must work offline", "must run on a phone", "single-developer maintainable").
Actual technology is chosen at `/grill-with-docs` → `/to-spec`.
- Product-level constraint: <constraint>

## 12. Success signals
What would tell you it's working, at MVP scale — lightweight, real, and observable soon. Not a KPI
dashboard for a product that doesn't exist yet.

Each signal names **what you would look at** and **when it becomes observable**. A signal that
cannot be observed yet is recorded as not-observable, with the reason — dropping it lets an absence
read as a pass.
- <signal> — look at: <the observation>, from: <when>
