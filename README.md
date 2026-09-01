# devkit

My personal operating system for building real things with a coding agent — solo, across web,
mobile, games, CLIs, and libraries.

It marries two sources: a **heavyweight team/production agent-delivery framework** (I keep its
*discipline*) and **[Matt Pocock's agent skills](https://github.com/mattpocock/skills)**
(small, composable, "real engineering, not vibe coding" — I keep its *delivery vehicle*). The
team-scale machinery (agent fleets, boards, deploy pipelines, governance) is dropped; the
quality spine and the composable-skill format stay.

## The 10-second mental model
You are the **Owner** (decide, gate, test). Claude is the **Foreman** (recommend, execute).
Background agents are **Lanes/Verifiers** (build or verify, never publish). Every task rides one
**loop** — shape → (slice) → build → review → **verify like a user** → confess — governed by a
short **spine** of [principles](PRINCIPLES.md), scaled by a **weight dial**, sized by a **domain
dial** (does this project have a domain worth modelling at all?), and made concrete by a per-domain
**profile**.

## Install
```bash
./install.sh                    # links devkit's own skills into ~/.claude/skills
# then install Pocock's skills as a plugin (so his updates reach you):
#   /plugin marketplace add mattpocock/skills
#   /plugin install mattpocock-skills@mattpocock
```

## Use
```
/product-brief                  # (devkit) Stage 0: turn a raw idea into a lean, validated brief
/new-project                    # scaffold: pick a domain profile, lay down CLAUDE.md + gates
/grill-with-docs                # (Pocock) shape one question at a time → /to-spec
/implement                      # (Pocock) build the slice, drives /tdd, then /code-review
/verify-live                    # (devkit) prove it works the way a user hits it
/confess                        # (devkit) record what was cut → REVIEW-DEBT.md
/ship                           # (devkit) the explicit publish gate
/verify-claim                   # (devkit) check any "already works" claim vs the real code
/harness                        # (devkit) install + PROVE the standards gates (boundaries, drift)
/crunch-domain                  # (devkit) crunch the domain with the Owner → CONTEXT.md + INVARIANTS.md
/design-brief                   # (devkit) surfaces + states + A11Y-n with enforcers → DESIGN.md
/prune                          # (devkit) dead code, proven dead before it is deleted; then duplication
```

## Working on devkit itself
```bash
scripts/check.sh                # devkit's own gate set — green before every commit
```
Shell syntax, shellcheck (when installed), the drift gate on devkit's own diff, skill frontmatter
(`name:` must equal the directory, or the skill installs and can't be invoked), skill advertising,
and dead cross-references — the likeliest defect in a repo made of documents pointing at documents.
House rules are in [CODING_STANDARDS.md](CODING_STANDARDS.md); what the gates don't prove is in
[REVIEW-DEBT.md](REVIEW-DEBT.md).

## What's in here
| Path | What |
|---|---|
| `METHOD.md` | The loop, the roles, the weight dial, and how it maps to the two sources. |
| `PRINCIPLES.md` | The 11 non-negotiables — the spine that never bends. |
| `ANTI-PATTERNS.md` | The recurring failure shapes; stop if you catch one. |
| `skills/` | devkit's own skills (the new ones the sources didn't have as composable units). |
| `profiles/` | Per-domain overlays: web, mobile-fullstack, game, cli-tools, library — each with its gate set, its **standards harness**, and its **domain dial** default. |
| `templates/` | Drop-in `CLAUDE.md`, `CONTEXT.md`, `INVARIANTS.md`, `DESIGN.md`, `CODING_STANDARDS.md`, `REVIEW-DEBT.md`, ADR, SPEC, PRODUCT-BRIEF. |
| `templates/scripts/drift-check.sh` | The drift gate — `ANTI-PATTERNS.md`, made executable and run on every diff. |
| `CODING_STANDARDS.md`, `scripts/check.sh` | devkit's own standards and gate set — it runs its own method on itself. |
| `docs/adr/` | devkit's own load-bearing decisions, with what was rejected. |

## Why "reference, not fork" for Pocock's skills
devkit deliberately does **not** copy his skills in. Install them as his plugin and they update
when he ships new ones; devkit only adds the pieces he doesn't cover (project bootstrap,
verify-like-a-user, confession ledger, adversarial claim-checking, the standards harness,
per-domain profiles) plus the method that ties everything together. `METHOD.md` marks each step
**(mp)** his or **(dk)** mine.

The same rule governs the *documents*: where one of his skills already maintains an artifact,
devkit adopts that skill's format rather than a prettier one of its own — `CONTEXT.md`,
`CONTEXT-MAP.md` and ADRs follow `domain-modeling`, specs follow `to-spec`, and the standards file is named
`CODING_STANDARDS.md` because that is the filename `code-review` looks for. See the reuse map in
`METHOD.md`. Two formats for one artifact is the same defect as two implementations of one
behavior.
