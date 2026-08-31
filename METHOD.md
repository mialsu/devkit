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
**MVP scope** (what now) from the **deferred backlog** (what later). The stance is a senior product
manager's: **users, scope and constraints** are all asked about before a section is written, and an
area the Owner short-circuits is recorded as an open question rather than quietly filled in. The
anti-trap it enforces: no tech/schemas at this altitude; only the problem, the core value, and the
MVP cut count as scope; every number is an assumption until tested; **edge cases are decided
here** — empty, refused, stale, broken, each a decision about what the user is *told*, which is
what stops "coming soon" reaching the build; and the real deliverable is **the riskiest assumption
plus the cheapest test that could falsify it**. It carries one job per persona and no user-story
list: `US-n` and its criteria belong to the spec, so one id scheme runs end to end.

The gate out of Stage 0 is blunt: *is there a lovable MVP, and can the #1 assumption be tested
cheaply?* If no, the next step is a validation experiment, not code. If yes, the brief's
platform reality picks the domain profile for `/new-project`, and each MVP-cut bullet becomes a
spec through the loop below. Skip Stage 0 only when the product already exists and you're just
adding a feature — then start at Shape.

## The loop

Six steps. The skills that drive each are in brackets — **(mp)** = Matt Pocock's (referenced,
installed via his plugin), **(dk)** = devkit's own (in this repo).

```
0. DISCOVER  /product-brief (dk)      → PRODUCT-BRIEF.md: problem, core loop, MVP cut, edge
   (greenfield only)                    cases, non-goals, riskiest-assumption tests. Asks about
                                        users/scope/constraints first. Tech DEFERRED.
                  │  gate: lovable MVP + cheap test for the #1 risk? → /new-project (dk)
                  ▼
0b. CRUNCH   /crunch-domain (dk)      → only if the DOMAIN DIAL is on (below), and BEFORE the first
   (dial on only)                       spec: walk the domain's timeline with the Owner, harvest the
                                        words into CONTEXT.md and the rules into INVARIANTS.md, give
                                        every invariant the test that fails when it is violated.
                  │  gate: can the Owner recite the contexts and top 3 invariants, files closed?
                  ▼
1. SHAPE     /grill-with-docs (mp)   → one question at a time, each with a recommendation.
   (+ shape)  → /to-spec (mp)          Writes the spec; devkit then adds falsifiable ACCEPTANCE
                                       CRITERIA, each naming how it will be proven, before code.
                                       Ambiguity → the spec's open questions, not an assumption.
                  │
2. SLICE     /to-tickets (mp)         → tracer-bullet vertical slices with blocking edges.
   (optional)                           Skip for small work.
                  │
3. BUILD     /implement (mp)          → build the slice; drives /tdd (mp) at agreed seams.
                  │                      Gates before every commit (see the profile).
4. REVIEW    /code-review (mp)        → standards + spec, adversarial. Fixes folded INTO commits.
                  │
5. VERIFY    /verify-live (dk)        → exercise it the way a user hits it, per the profile.
                  │                      A verdict PER CRITERION; the task's is the worst of them.
                  │                      This is what turns "built" into "done".
6. CONFESS   /confess (dk)            → every faked/deferred/weaker-than-spec seam → REVIEW-DEBT.md.
```

### The whole chain, greenfield to shipped

Six commands do the work; everything after step 3 repeats per MVP-cut bullet.

```
1. /product-brief                 once, before a repo exists. Problem, core value, MVP cut,
                                  non-goals, riskiest assumption + its cheapest test. No tech.
                                  → its platform reality picks the profile, and its MVP cut is
                                    already the DOMAIN DIAL's evidence (money? scheduling?
                                    permissions? a state machine? then the dial is on)
2. /new-project                   once. Profile, CLAUDE.md, CONTEXT.md, CODING_STANDARDS.md,
                                  REVIEW-DEBT.md, scripts/drift-check.sh, specs/. Delegates to
                                  /harness, which PROVES each gate by breaking it. Step 3a sets
                                  the domain dial. You author the domain guard-rails. Then it stops.
3. /crunch-domain                 once, if the dial is on — before the first spec, because an
                                  invariant found after the schema exists costs a migration.
── per MVP-cut bullet ────────────────────────────────────────────────────────────────────
4. /grill-with-docs → /to-spec    the spec, then its AC table (each criterion naming
                                  test:/live:/review-only) and `Invariants touched: INV-n`
5. (/to-tickets)                  tracer slices, blockers first. Skip for small work.
6. /implement (+ /tdd)            build the slice. The profile's gate set green before EVERY commit.
7. /code-review                   standards + spec axes; fixes folded INTO the commits.
8. /verify-live                   a verdict per criterion, and it ATTACKS the invariants the slice
                                  touches. The task's verdict is the worst criterion's.
9. /confess                       every faked/deferred/weaker-than-spec seam → REVIEW-DEBT.md
── when you choose to publish ────────────────────────────────────────────────────────────
10. /ship                         the only command that puts anything on a remote.
```

Anywhere in there: `/verify-claim` the moment something claims "this already works", and
`/handoff` when a session fills up. Adding a feature to a project that already exists? Start at
step 4 — Stage 0 and the bootstrap are once-per-project.

Four supporting skills sit outside the loop:

- **`/verify-claim` (dk)** — before you trust *any* "this already works / already exists"
  claim (from a doc, an old TODO, a past session), dispatch this to grep the committed code and
  return a MET / PARTIAL / NOT-MET verdict with file:line evidence.
- **`/harness` (dk)** — install and *prove* a project's standards harness: `CODING_STANDARDS.md`
  (the exact filename `/code-review`'s Standards axis reads), the import/architecture boundary
  gate, and the drift gate that makes `ANTI-PATTERNS.md` executable. Run at bootstrap, or to
  retrofit a project whose rules currently live only in prose.
- **`/crunch-domain` (dk)** — for a project whose **domain dial** is on (below): walk the domain's
  timeline with the Owner, harvest the words into `CONTEXT.md` and the rules into `INVARIANTS.md`,
  and give every invariant the test that fails when it's violated. Its first act is to check the
  dial and try to talk you out of it. Not per-task: run it once early, re-run when the domain moves.
- **`/handoff` (mp)** — when a session fills up, fork it: write a handoff doc, open a fresh
  session. Steps 1–2 want to live in one unbroken context; each `/implement` can start fresh.

Bootstrapping a brand-new project is its own skill: **`/new-project` (dk)** — picks a domain
profile, lays down the workspace, `CLAUDE.md`, `CONTEXT.md`, and `REVIEW-DEBT.md`, wires the
gate commands via **`/harness`**, and runs the acid test. Publishing is **`/ship` (dk)** — the per-profile,
explicit-keystroke publish checklist.

---

## Reuse before building — the docs too

devkit does **not** invent a format for an artifact that a skill you already have maintains. The
map, so no session has to guess which shape is canonical:

| Artifact | Format owned by | devkit's additions |
|---|---|---|
| `CONTEXT.md` (ubiquitous language) | `domain-modeling` (mp) — `CONTEXT-FORMAT.md` | an `_Unresolved_:` marker; `_Avoid_:` made machine-checked by the drift gate |
| `docs/adr/NNNN-*.md` | `domain-modeling` (mp) — `ADR-FORMAT.md`; created lazily | **rejected alternatives are mandatory** (PRINCIPLES #7) |
| `specs/NNNN-*.md` | `to-spec` (mp) — its section template | a local file, not a tracker issue (solo work has no tracker); adds Tracer slices (#4) and Open questions (#7) |
| `CONTEXT-MAP.md` (contexts, their folders, their relationships) | `domain-modeling` (mp) — `CONTEXT-FORMAT.md` | each context folder becomes a layering rule in the boundary gate |
| `CODING_STANDARDS.md` | `code-review` (mp) reads this exact filename | the enforcer tag on every rule |
| the boundary gate | `setup-ts-deep-modules` (mp) — ships a working dependency-cruiser config | fills its deliberately-empty layering stub; per-profile equivalents for non-TS |
| `INVARIANTS.md` (the rules, each naming its enforcer) | devkit — neither source has this | the whole file: `domain-modeling` keeps `CONTEXT.md` a glossary and *nothing else*, so domain **rules** had no home |
| `PRODUCT-BRIEF.md` (product altitude, before a repo exists) | devkit — neither source covers this stage | the whole file. Note the name clash: **"PRD" is already taken** — `to-prd` and `to-spec` (mp) are one template under two names, and both refuse to interview. This is the earlier, *interviewed* document, and it deliberately holds no `US-n` list so the spec keeps that id scheme to itself |
| `scripts/drift-check.sh`, `REVIEW-DEBT.md`, the profiles | devkit | — |

The rule, and it applies to prose as hard as to code: **if an installed skill writes the artifact,
adopt its format even when yours is prettier.** Two formats for one artifact is the same defect as
two implementations of one behavior — they drift, and then both are suspect.

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
| **Harness** | drift gate | + boundary gate | + `CODING_STANDARDS.md` and layering rules |
| **Acceptance criteria** | one falsifiable line in the commit message | an AC table, verdicts filled by `/verify-live` | AC table + `Serves` column back to user stories + spec-delta log |

A one-file script still gets **gated and verified** — that's the spine. It just skips the
tickets, the ADRs, and the multi-session paperwork.

---

## The domain dial

The weight dial scales *ceremony*. The domain dial answers a different question: **does this project
have a domain worth modelling at all?** DDD earns its cost on complex, long-lived software and is a
tax on everything else — a CRUD app's rules *are* its schema, and writing them out twice produces a
document that rots. So the dial is **argued upward, never assumed**: each profile names the setting
it expects for its domain (`profiles/*/PROFILE.md`), and the Owner confirms or overrides it against
the actual project, because an empty repo can't answer this and a profile can't see your project.

The bar for **on** is at least **two** of these:

1. **Rules that aren't CRUD** — something decides whether an action is *allowed*, and the answer
   isn't "the user owns the row".
2. **One word already means two things** to two different actors.
3. **Money, scheduling, permissions, or state machines** are in scope.
4. **It will outlive a month**, across many sessions — the point at which the agent's context is
   gone and only the files remain.

| Setting | What exists | When |
|---|---|---|
| **off** (the floor — cli-tools, library) | `CONTEXT.md` only — the glossary is *always* on, because vocabulary drift is free to prevent and expensive to fix | scripts, CRUD, thin wrappers, most CLIs |
| **on** (web, mobile-fullstack; game's rules only) | + `INVARIANTS.md`, each invariant naming the enforcer that fails when it's violated; `/crunch-domain` before the first spec | ≥2 triggers above |
| **mapped** (rare, and never by default) | + `CONTEXT-MAP.md`, one `CONTEXT.md` + `INVARIANTS.md` per context, **and each context folder wired as a layering rule in the boundary gate** | a word genuinely collides between actors — nothing else justifies a split |

Two rules keep the dial honest:

- **Never split a context for size.** Layers, file counts and "it feels like two systems" are not
  triggers; a colliding word is the only one. Slices cut layers, never contexts (PRINCIPLES #4).
- **On means enforced.** An invariant with no named enforcer, or a context boundary not in the
  import graph's rules, is the *pseudo-artifact* — the document that manufactures confidence. Down
  the dial is always available; a decorative model is not.

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
- **DDD** enters through the same door as everything else — reuse. Pocock's `domain-modeling`
  already owns the ubiquitous language, the ADRs, and the context map, so devkit adds only the piece
  it deliberately excludes (`CONTEXT.md` is "a glossary and nothing else", which leaves domain
  *rules* homeless): `INVARIANTS.md`, plus the dial that decides when any of it is worth doing. The
  discipline it borrows from Three Dots Labs' *DDD and AI coding* is the warning, not the ceremony —
  the model's value is the understanding, an agent-generated model nobody read is a pseudo-artifact,
  and the ubiquitous language is the highest-leverage context an agent can be given.
- **High-level product design** is the one stage *neither* source covers well — the framework
  assumes the product already exists (requirements arrive as binding scope), and Pocock's flow
  starts at shaping a feature. `/product-brief` fills that gap as Stage 0, reusing Pocock's
  `/grilling`, `/research`, and `/prototype` primitives rather than inventing new machinery.

See `README.md` for install, and `profiles/` for the per-domain specifics.
