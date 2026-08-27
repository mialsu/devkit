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

- **Rebuilding what you already have.** A second implementation of one behavior is a divergence
  waiting for a bug. Reuse the existing one, or delete it and build one good one.

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
