# The devkit method

A personal operating system for building real things with a coding agent — solo. It is a
marriage of two sources:

- **A heavyweight team-and-production agent-delivery framework** (the kind built to ship to
  prod with agent fleets) contributes the **discipline**: the [principles](PRINCIPLES.md), the
  [anti-patterns](ANTI-PATTERNS.md), end-to-end slices, gates, "done = verified", confessions,
  and adversarial verification.
- **Matt Pocock's agent skills** (small, composable, "real engineering, not vibe coding")
  contribute the **delivery vehicle**: a chain of tiny `SKILL.md` files you compose and adapt.

devkit keeps the discipline, drops the machinery (no agent fleets, no Linear board, no deploy
pipeline, no "dark factory" governance — those are team-scale), and wires the two together with
a **weight dial** and five **domain profiles**.

---

## The three roles (kept even though you're solo)

Losing this separation is how solo work degrades into vibe coding. Keep it.

| Role | Who | Does |
|---|---|---|
| **Owner** | You | Decides. Answers shaping questions tersely. Gates every publish. Tests the thing personally. Vetoes. |
| **Foreman** | Claude's main session | Grounds itself, recommends on every question, executes, coordinates, reports. Never decides a product question alone; never builds without your go. |
| **Lanes / Verifiers** | Background agents | Build in isolation, or attack a claim with evidence. Never publish; never mark done. |

---

## Stage 0 · Discover (product design) — before the loop

Greenfield ideas get a stage the loop doesn't cover: turning a raw concept into a **lean,
validated product brief** before any repo or tech exists. This is `/product-brief` (dk), and it
is where high-level product design lives.

It produces `PRODUCT-BRIEF.md` (template in `templates/`), which separates **vision** (why) from
**MVP scope** (what now) from the **deferred backlog** (what later). The anti-trap it enforces:
no tech/schemas at this altitude; only the problem, the core value, and the MVP cut count as
scope; every number is an assumption until tested; and the real deliverable is **the riskiest
assumption plus the cheapest test that could falsify it**.

The gate out of Stage 0 is blunt: *is there a lovable MVP, and can the #1 assumption be tested
cheaply?* If no, the next step is a validation experiment, not code. If yes, the brief's
platform reality picks the domain profile for `/new-project`, and each MVP-cut bullet becomes a
spec through the loop below. Skip Stage 0 only when the product already exists and you're just
adding a feature — then start at Shape.

## The loop

Six steps. The skills that drive each are in brackets — **(mp)** = Matt Pocock's (referenced,
installed via his plugin), **(dk)** = devkit's own (in this repo).

```
0. DISCOVER  /product-brief (dk)      → PRODUCT-BRIEF.md: problem, core loop, MVP cut,
   (greenfield only)                    non-goals, riskiest-assumption tests. Tech DEFERRED.
                  │  gate: lovable MVP + cheap test for the #1 risk? → /new-project (dk)
                  ▼
1. SHAPE     /grill-with-docs (mp)   → one question at a time, each with a recommendation.
   (+ shape)  → /to-spec (mp)          Writes SPEC.md. Ambiguity → questions file, not assumption.
                  │
2. SLICE     /to-tickets (mp)         → tracer-bullet vertical slices with blocking edges.
   (optional)                           Skip for small work.
                  │
3. BUILD     /implement (mp)          → build the slice; drives /tdd (mp) at agreed seams.
                  │                      Gates before every commit (see the profile).
4. REVIEW    /code-review (mp)        → standards + spec, adversarial. Fixes folded INTO commits.
                  │
5. VERIFY    /verify-live (dk)        → exercise it the way a user hits it, per the profile.
                  │                      This is what turns "built" into "done".
6. CONFESS   /confess (dk)            → every faked/deferred/weaker-than-spec seam → REVIEW-DEBT.md.
```

Two supporting skills sit outside the loop:

- **`/verify-claim` (dk)** — before you trust *any* "this already works / already exists"
  claim (from a doc, an old TODO, a past session), dispatch this to grep the committed code and
  return a MET / PARTIAL / NOT-MET verdict with file:line evidence.
- **`/handoff` (mp)** — when a session fills up, fork it: write a handoff doc, open a fresh
  session. Steps 1–2 want to live in one unbroken context; each `/implement` can start fresh.

Bootstrapping a brand-new project is its own skill: **`/new-project` (dk)** — picks a domain
profile, lays down the workspace, `CLAUDE.md`, `CONTEXT.md`, and `REVIEW-DEBT.md`, wires the
gate commands, and runs the acid test. Publishing is **`/ship` (dk)** — the per-profile,
explicit-keystroke publish checklist.

---

## The weight dial

The principles never bend, but the ceremony scales. Pick the weight at the start of a task; the
agent states which weight it's running.

| | **Light** | **Standard** | **Full** |
|---|---|---|---|
| **For** | a script, a spike, a prototype | a feature, a tool, a small app | a multi-session app or library |
| **Steps run** | 1 → 3 → 5 (shape briefly, build, verify) | 1 → 3 → 4 → 5 → 6 | all six, `/to-tickets`, across sessions |
| **SPEC.md** | a few lines inline, or none | yes | yes, + ADRs for load-bearing calls |
| **Sessions** | one | one or two | many, joined by `/handoff` |
| **Confession** | a line in the commit message | REVIEW-DEBT entry | REVIEW-DEBT + disposition pass |

A one-file script still gets **gated and verified** — that's the spine. It just skips the
tickets, the ADRs, and the multi-session paperwork.

---

## Parallelism (when you want it)

For a Standard/Full task with independent surfaces, you can fan out background agents — but the
one rule from the source method is absolute: **one builder per file set**. Partition the work
so no two background lanes ever write the same file; regenerate any shared/global artifact once,
yourself, after the lanes land. If you can't partition cleanly, don't parallelize — build
serially. Research and read-only verification parallelize freely; code does not.

---

## How this maps to the sources (for when you want to go deeper)

- The **7 phases** of the source framework collapse, for solo work, into: `/new-project`
  (Phase 0 Foundations), `/grill` + reuse-scout (Phase 1 Understand + Phase 2 Shape), the loop's
  steps 3–6 (Phase 3 Build), `/verify-live` + `/verify-claim` (Phase 5 Verify & defend), and
  `/confess` + REVIEW-DEBT (Phase 6 Operate). Phase 4 (multi-agent feedback rounds) is the
  parallelism note above, resized.
- The framework's **`/new-task`** shaping skill ≈ Pocock's `/grill-with-docs` + `/to-spec`
  chained. devkit uses the Pocock pair (more composable) and keeps the framework's extra
  demands — ground-in-both-repos, verify-claims-during-shaping, wait-for-go — as rules in the
  skill prompts and in `CLAUDE.md`.
- The framework's **"verify like a user with the real persona, screenshots as evidence"**
  becomes `/verify-live`, which delegates the *meaning* of "exercise it" to the domain profile.
- **High-level product design** is the one stage *neither* source covers well — the framework
  assumes the product already exists (requirements arrive as binding scope), and Pocock's flow
  starts at shaping a feature. `/product-brief` fills that gap as Stage 0, reusing Pocock's
  `/grilling`, `/research`, and `/prototype` primitives rather than inventing new machinery.

See `README.md` for install, and `profiles/` for the per-domain specifics.
