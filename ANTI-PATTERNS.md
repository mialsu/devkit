# Anti-patterns — if you catch yourself doing one of these, stop

Each of these was paid for on the builds that produced the source method. They are the
failure *shapes* that recur regardless of domain.

- **Shipping on green tests without a live exercise.** Real bugs — crashes, leaks, stale
  caches, wrong-persona denials — routinely pass a green suite. Tests gate; the live run proves.
  (→ `/verify-live`)

- **Trusting status over code.** An old TODO, a doc, or your own memory says "this is done."
  Marking it done without grepping the actual code is how a project rots into false progress.
  (→ `/verify-claim`)

- **Silent scope-filling.** Resolving an ambiguity with the agent's own assumption is a defect
  with a delay timer. It goes to a questions file or back to you — never quietly into the code.

- **Sliding from shaping into building.** Shaping and building are separate acts. The agent
  proposes, you say go. No go, no code.

- **Backend/layer-only "progress."** A schema with no screen, or a screen over an API that
  doesn't exist, banks work nobody can exercise. Slice end-to-end or don't slice.

- **Designing for the scale you don't have.** A caching layer before a slow query, a queue before a
  backlog, an abstraction over the one database you will ever use, or "architecture, data flow, API
  design, schema, caching strategy" delivered as a set of layers nobody can exercise yet. It is two
  of these anti-patterns wearing one coat — *Speculative Generality* and *backend/layer-only
  progress* — and it charges twice: once to build, and again on every later change that pays rent to
  machinery which was never load-bearing. The scaling question worth asking is far smaller: **which
  of today's decisions would be expensive to reverse at 100x?** Two or three genuinely are; those
  earn an ADR with their rejected alternatives, and everything else takes the cheap option and stays
  reversible. "It'll scale later" is a prediction. "This one is a one-way door" is a decision.

- **Rebuilding what you already have.** A second implementation of one behavior is a divergence
  waiting for a bug. Reuse the existing one, or delete it and build one good one.

- **The smallest diff in the wrong place.** Patching the caller the bug report names, when the
  fault is in the function every caller shares. Adding the same guard at one of six call sites.
  "Minimal change" picked before the flow was traced. It wears the costume of restraint and ships
  a sibling bug nobody has reported yet. A report names a **symptom**: grep every caller of the
  function you touch and fix the shared function once — one guard at the owner is a smaller diff
  than one per caller, and it is the only version that still holds when the seventh caller
  arrives. Understanding the problem is the rung the ladder (PRINCIPLES #3) never lets you skip.

- **Roadmap copy in the product.** No "coming soon", no "unsupported", no placeholder dressed
  up as real. A labeled honest empty state, or nothing.

- **Reformatting generated or vendored files.** Migrations, lockfiles, codegen output, and
  vendored code are not yours to prettify. Touch them only through their generator.

- **Spec drift, silently.** The build teaches you the spec was wrong — so the code goes one way
  and the spec keeps asserting the other, or worse, the spec gets quietly edited to match as
  though it always said that. Diverging is normal; diverging *unrecorded* is the defect. It goes
  in the spec's `Spec deltas` log, dated, or it becomes a confession you owe.

- **Deferring the confession.** "I'll write down what I stubbed later" means you won't. The
  debt entry is written at the moment you incur it, or it is lost.

- **A standard with no enforcer.** A rule that lives only in prose — no lint, no test, no script —
  is a suggestion, and an agent follows the harness far more reliably than the paragraph. Wire an
  enforcer or label it `[review-only]`, so nobody mistakes the document for a guarantee.
  (→ `/harness`)

- **The pseudo-artifact.** A document the agent generated in one pass, nobody read closely, and
  everybody now cites: a "domain model" reverse-engineered from the code and skimmed, a glossary of
  general programming words, an invariant list with no test names. It reads like understanding and
  costs like understanding but carries none — and it is *worse* than no document, because the next
  session trusts it. Two tests: can the Owner recite it with the file closed, and does every rule in
  it name the enforcer that fails when it's broken? If neither, delete it. An absent document is
  honest; a confident wrong one is not. (→ `/crunch-domain`)

- **Two words for one thing.** A second name for a concept that already has one forks the
  project's language: the agent starts writing a parallel vocabulary, and two half-implementations
  follow it. The word goes in `CONTEXT.md` — with its rejected synonyms under `_Avoid_` — before
  the code uses it. (→ the drift gate checks this on every diff)

- **Two formats for one artifact.** The same document (a glossary, an ADR, a spec) written two ways
  in two places guarantees they drift, and then every session has to guess which is canonical. If
  a skill you already install writes that artifact, adopt *its* format — even when yours is
  prettier. This is "rebuilding what you already have", aimed at the docs.

- **Two writers, one file.** When you parallelize with background agents, the merge pain always
  exceeds the parallel gain if two lanes edit the same file. Partition by file set first, or
  don't parallelize.
