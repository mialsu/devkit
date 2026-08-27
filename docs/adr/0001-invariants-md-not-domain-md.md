# ADR-0001 — Domain rules live in `INVARIANTS.md`; there is no `DOMAIN.md`

Phase 3 was planned as a `DOMAIN.md` holding bounded contexts, their code folders, their
relationships, and the domain's invariants. Reading the installed `domain-modeling` skill first
showed that three of those four are already owned by its `CONTEXT-MAP.md` (contexts, where each
lives, how they relate) — so `DOMAIN.md` would have been the *two formats for one artifact*
anti-pattern, committed by the same repo that added it a commit earlier. devkit therefore adopts
`CONTEXT-MAP.md` unchanged and adds only the quarter nothing owns: **`INVARIANTS.md`**, the domain
rules, each naming the enforcer that fails when it is violated. That gap is real and deliberate on
Pocock's side — his `CONTEXT-FORMAT.md` says `CONTEXT.md` is "a glossary and nothing else", which
leaves domain *rules* with no home in either source.

## Rejected alternatives
- **`DOMAIN.md` as planned (contexts + folders + relationships + invariants)** — rejected: it
  restates `CONTEXT-MAP.md` in a second shape, so the two drift and every session has to guess
  which is canonical. The prettier file loses on purpose (METHOD.md, "Reuse before building — the
  docs too").
- **Put invariants in `CONTEXT.md`** — rejected: the skill that maintains that file will keep
  pruning them out, and correctly. A glossary defines what a word *is*; an invariant is a rule.
- **Put invariants in the spec only** — rejected: a spec is scoped to one slice and becomes history
  once shipped, while an invariant must outlive every spec. That's the AC/INV distinction the file
  opens with.
- **Extend `CODING_STANDARDS.md`** — rejected: that file is about the shape of *code* and is read by
  `/code-review`'s Standards axis. Domain rules there would be enforced by the wrong reviewer.
- **No file; keep invariants as tests only** — rejected as the tempting one. The tests *are* the
  enforcement, but a test suite doesn't tell a cold session which assertions are load-bearing
  domain rules versus incidental coverage, and it can't record a rule that is deliberately
  `[review-only]`.

## Consequences
- `INV-n` joins the id scheme (`US-n → AC-n → D-n → INV-n → ADR-n`), referenced from specs
  (`Invariants touched:`), from the code at each invariant's single owner, and from `/verify-live`.
- The drift gate polices the file (check 7): a new `INV-` row with an empty `Enforced by` cell fails
  the diff, which is what keeps the file from becoming the pseudo-artifact it warns about.
- A multi-context repo gets one `INVARIANTS.md` per context, beside its `CONTEXT.md`, matching the
  layout `domain-modeling` already defines.
