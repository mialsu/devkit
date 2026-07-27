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
short **spine** of [principles](PRINCIPLES.md), scaled by a **weight dial**, and made concrete by
a per-domain **profile**.

## Install
```bash
./install.sh                    # links devkit's own skills into ~/.claude/skills
# then install Pocock's skills as a plugin (so his updates reach you):
#   /plugin marketplace add mattpocock/skills
#   /plugin install mattpocock-skills@mattpocock
```

## Use
```
/new-project                    # scaffold: pick a domain profile, lay down CLAUDE.md + gates
/grill-with-docs                # (Pocock) shape one question at a time → /to-spec
/implement                      # (Pocock) build the slice, drives /tdd, then /code-review
/verify-live                    # (devkit) prove it works the way a user hits it
/confess                        # (devkit) record what was cut → REVIEW-DEBT.md
/ship                           # (devkit) the explicit publish gate
/verify-claim                   # (devkit) check any "already works" claim vs the real code
```

## What's in here
| Path | What |
|---|---|
| `METHOD.md` | The loop, the roles, the weight dial, and how it maps to the two sources. |
| `PRINCIPLES.md` | The 10 non-negotiables — the spine that never bends. |
| `ANTI-PATTERNS.md` | The recurring failure shapes; stop if you catch one. |
| `skills/` | devkit's own skills (the new ones the sources didn't have as composable units). |
| `profiles/` | Per-domain overlays: web, mobile-fullstack, game, cli-tools, library. |
| `templates/` | Drop-in `CLAUDE.md`, `CONTEXT.md`, `REVIEW-DEBT.md`, ADR, SPEC. |

## Why "reference, not fork" for Pocock's skills
devkit deliberately does **not** copy his skills in. Install them as his plugin and they update
when he ships new ones; devkit only adds the pieces he doesn't cover (project bootstrap,
verify-like-a-user, confession ledger, adversarial claim-checking, per-domain profiles) plus the
method that ties everything together. `METHOD.md` marks each step **(mp)** his or **(dk)** mine.
