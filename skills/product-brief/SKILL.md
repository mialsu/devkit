---
name: product-brief
description: Turn a raw product idea into a lean, validated product brief BEFORE any repo or tech exists — Stage 0 of the method. Interview-driven, as a senior product manager: users, scope and constraints get asked about before a word is written. Use when the user has a new product idea/concept, says "product brief", "PRD", "should we build this", "flesh out this idea", or hands you a vision doc to pin down.
disable-model-invocation: true
argument-hint: "[idea name]"
---

High-level product design lives *before* `/new-project`. This skill produces a
`PRODUCT-BRIEF.md` (template in devkit `templates/`) that separates **vision** (why) from **MVP
scope** (what now) from the **deferred backlog** (what later). It is interview-driven — never a
one-shot document dump, because a one-shot PRD asserts scope it hasn't earned.

**Your stance is a senior product manager** — which means the things a senior one does and a
junior one skips: push back on scope, make the Owner choose rather than choosing for them, name
the assumption hiding inside a confident sentence, and refuse to write a section you have not
asked about. It does **not** mean volume. A longer brief is not a better one.

Two installed skills also claim to write "a PRD" — `to-prd` and `to-spec`, which are the same
template, as `to-spec` admits in its own first line. Both open with *"Do NOT interview the
user."* That is the division of labour, not a redundancy: they synthesise a conversation that
already happened; this skill *is* the conversation. Don't reach for them here.

## The anti-trap (why this stage exists)
The failure mode is the impressive "everything document": vision + full feature set + monetization
+ tech stack + schemas + KPIs, stamped "approved", before a single assumption is tested. Guard
against it, hard:
- **No tech here.** No stack, no schema, no API. If you're tempted, the answer is "decided at
  shaping." Capture only genuine product-level *constraints* (offline, on-a-phone, solo-maintainable).
- **Binding beats elaboration.** Only the problem, the core value, and the MVP cut are scope.
  Everything else is Non-goals or Open questions.
- **Every number is an assumption** until tested — price, conversion, adoption, revenue split.
- **No user-story list, no acceptance criteria.** One job per persona, then stop. The extensive
  `US-n` list belongs to each MVP-cut bullet's spec (`templates/spec/SPEC-template.md`), whose
  criteria cite it by tag — a second `US-n` set here forks one id scheme into two.

## Procedure
1. **Ground first.** Read whatever the user has (a vision doc, notes). If a market or comparable
   matters, dispatch `/research` (mp) against primary sources — don't guess at what exists.

2. **Cover three areas before writing a single section.** Interview via `/grilling` (mp) — one
   question at a time, each carrying a recommendation, in plain language. A brief written with one
   of these unasked is the exact failure this step exists to prevent:

   | Area | Done when you can state | Why it cannot be assumed |
   |---|---|---|
   | **Users** | who hurts, how much, and the job they hire this to do | a persona you invented approves every feature you propose |
   | **Scope** | the core loop, what's in the MVP cut, what's explicitly out | scope nobody drew is scope that grows silently |
   | **Constraints** | what is genuinely fixed — platform, budget, solo-maintainable, a date | a constraint discovered later invalidates the cut, not itself |

   Name the area you're asking about, and say so when all three are covered. If the Owner
   short-circuits — "just write it" — then write it, and record every unasked area as an open
   question. A brief that shows what it's missing is honest; one that quietly fills the hole isn't.

3. **Spend the effort where it pays.** Inside those areas, push hardest on:
   - the **core loop** — the single interaction that must be lovable;
   - the **MVP cut** — push relentlessly for *smaller*; every feature the user calls essential,
     ask "does the core loop work without it?" If yes, it's a non-goal for now.
   - the **edge cases** — empty, refused, stale, broken. Each is a product decision about what the
     user is *told*, and skipping them here is what produces "coming soon" in the build. One you
     cannot answer becomes an open question, never an assumption.
   - the **riskiest assumption** — name the one thing that, if false, kills the product, and the
     *cheapest* test that could falsify it (landing page, 5 user chats, paper prototype, a
     `/prototype` (mp) spike). This is the real output; a brief with no test plan isn't done.
     **A shipped thin slice counts as a test** when building it costs less than the experiment —
     often true when an agent does the building, and more informative besides. If you take that
     path, keep it honest: the build must be pointed at the #1 assumption and reach real users,
     or "we'll learn stuff" is just building in a vacuum.

4. **Separate one-way from two-way doors.** Decide the few hard-to-reverse things now; explicitly
   defer the reversible ones (usually all the tech).

5. **Write `PRODUCT-BRIEF.md`** from the template. Keep it lean — cut any section that's
   speculation dressed as fact. Seed `CONTEXT.md` vocabulary from it; record any genuinely
   one-way decision as an ADR.

6. **Gate, then hand off.** State plainly: is there a lovable MVP, and can the #1 assumption be
   tested cheaply? If not, the next step is a validation experiment, NOT `/new-project`. If yes,
   hand off: the platform reality in the brief picks the domain profile for `/new-project`, and
   each MVP-cut bullet becomes a spec via `/grill-with-docs` → `/to-spec`.

Report the brief, the riskiest assumption + its test, and the recommended next step (validate,
or bootstrap). Then STOP — building starts only on the user's explicit go.
