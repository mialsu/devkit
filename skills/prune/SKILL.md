---
name: prune
description: Find dead code across a repo — unused files, exports, imports, dependencies, env vars, commented-out blocks — prove each one is dead with evidence before anything is deleted, then handle the duplication the scan turned up without changing behaviour. Use when the user says "dead code", "unused", "prune", "clean up this repo", "what can we delete", or after a feature lands and leaves a trail behind it.
disable-model-invocation: true
argument-hint: "[path or area to scan]"
---

Dead code is the cheapest defect to carry and the most expensive to read around: it survives every
grep, it answers questions wrongly, and each new session pays for it again. This skill finds it,
**proves** each piece is dead before touching it, deletes it, and only then looks at the duplication
the scan turned up. Two acts, one hard gate between them, and they never share a commit — a diff
that both removes files and moves logic cannot be bisected, and cannot support the claim that
behaviour is unchanged.

The verb that matters is **prove**. "The scanner says it is unreferenced" is a claim, not a fact
(PRINCIPLES #6), and the categories below are not equally provable — one of them is not provable
from inside this repo at all.

## What this skill does NOT do (reuse before building)

| Piece | Owned by | Why not here |
|---|---|---|
| the architecture vocabulary — module, interface, depth, **seam**, leverage, locality | `/codebase-design` (mp) | it defines the **deletion test**, which is exactly the tool this skill needs. Use its words exactly; do not drift into "component" or "service" |
| proposing and grilling structural refactors | `/improve-codebase-architecture` (mp) | it already scans for deepening opportunities and walks you through the one you pick. Phase 2 hands off to it rather than re-running it |
| duplication *inside one change* | `/code-review` (mp) — Fowler's Duplicated Code | that axis is per-diff. This skill is per-repo, which is the gap |
| the scanner itself | the ecosystem's tool, named in `profiles/<domain>/PROFILE.md` | never hand-roll grep heuristics for a job `knip` / `ruff` / `deptry` / `cargo-udeps` already does properly |

**Where "shared utils" goes wrong.** The obvious cure for duplication — hoist it into `utils/` — is
the one shape `/codebase-design` marks *avoid*: a large interface over a thin implementation is a
**shallow module**, and a utils folder is shallow modules by construction. Merged logic goes behind
a **seam**, as a deep module with a name from `CONTEXT.md`, or it stays duplicated.

---

# Phase 1 — delete what is dead

## 1. Scope before you scan
A whole-repo report with four hundred rows gets skimmed, and a skimmed report is a pseudo-artifact.
Take the area the Owner named. If they named none, let `git log` pick: the paths that keep coming
up, plus anything a recently landed slice touched, are where dead code actually accumulates. Say
which scope you chose and what you are therefore *not* claiming anything about.

## 2. Run the profile's scanner, then verify it fits
`profiles/<domain>/PROFILE.md` → **Dead code & duplication** names the tool for this ecosystem.
Treat that as a starting point, not a fact (`/harness` step 1): confirm the tool exists, is
maintained, and understands this stack's conventions before trusting a single row it prints.

## 3. Prove it, per category — the bar is different for each

| Category | What counts as proof | The blind spot that voids it |
|---|---|---|
| **imports** | the linter or compiler says so | none. This one is certain |
| **files, exports, components** | the scanner says unreferenced **and** you checked the five | dynamic `import()` on a computed path; string-keyed registries and DI containers; framework file conventions (routes, `app/page.tsx`, migrations, `admin.py`, `conftest.py`); a barrel re-export making everything look reachable; a codegen or reflection consumer |
| **dependencies** | the scanner **plus** a grep of the config files **plus** a clean install and a green build | used only inside a config file; type-only; a transitive peer; resolved by plugin *name* (eslint, postcss, tailwind); invoked from a `package.json` script |
| **env vars** | **not obtainable here** — see below | a deploy platform, a Dockerfile, CI, an infra repo, or a sibling service reads it. This repo cannot see any of them |
| **commented-out blocks** | inverted: git holds it, so no proof of deadness is needed — but `git log -S` it first | a block that was never committed *uncommented* is not in history, and deleting it destroys it |

**Env vars are reported, never deleted by the agent.** The evidence that would settle it lives
outside this repo, so the honest deliverable is the list plus *where you looked and where you could
not*. The Owner deletes, or doesn't. Proposing a deletion whose proof you cannot obtain is the
overclaim PRINCIPLES #10 exists to forbid.

## 4. Triage into three verdicts, not two
Unreferenced is not the same as unwanted. Before anything is deleted, read `REVIEW-DEBT.md`, the
specs' non-goals and open questions, and `INVARIANTS.md`'s *enforcers owed* table:

- **dead** — nothing wants it. Delete it.
- **owed** — it is unreferenced because a slice was banked half-built, or the ledger already says
  "wired, not called yet", or a spec defers its caller on purpose. **Keep it**, and put the file:line
  into the ledger entry so it stops reading as dead to the next session. Deleting this silently
  erases a confession and makes the tracker lie (PRINCIPLES #5, #10).
- **orphaned** — its caller was deleted and nobody noticed. Delete it **and confess**, because it
  means a slice did not cut end to end (PRINCIPLES #4) and the same gap will produce more.

## 5. Show the list. Then stop.
One table: path, category, verdict, the proof, and the blind spot you checked. Recommend, do not
decide (PRINCIPLES #8). **No deletion happens before the Owner's go.**

## 6. Delete — in order, to a fixpoint
Require a clean worktree first: every deletion must be revertible on its own. Then work
inside-out, because each pass feeds the next — commented-out blocks, then unused imports, then
unused exports and files, then dependencies. **Re-run the scanner after each pass**: deleting a file
makes its imports dead, and deleting those can make a dependency dead. One pass is never enough;
stop when a pass finds nothing.

**One category per commit**, with the profile's full gate set green between each. If a deletion
breaks something, that is the gate doing its job and the proof bar in step 3 was too low — record
which blind spot you missed.

---

> **Phase gate.** Phase 1's failure mode is caught by the gates: delete something used, and the
> build or the live exercise goes red. Phase 2's failure mode is *not* — merge two things that
> should have stayed apart and every test stays green while the code gets worse. So phase 2 starts
> only on a separate go, and it is fine to stop here.

# Phase 2 — the duplication the scan turned up

## 7. Three tests before merging anything — most candidates die here
Two blocks that look alike are the same thing only if:
1. **Rule of three** — two occurrences is a coincidence, three is a pattern.
2. **Same reason to change** — would a change to one *always* require the same change to the other?
   If they change for different reasons, they are two things that currently rhyme.
3. **Same context** — merging across a context boundary couples what was rightly separate. A slice
   cuts layers, never contexts (PRINCIPLES #4); a shared helper that spans two is the same defect
   with a smaller diff.

A "no" to any of these means **leave it duplicated**, and say so in the report. *"Kept duplicated,
deliberately, because —"* is an output of this skill, not a failure of it.

## 8. "Behaviour stays identical" needs an enforcer, or it is a wish
A promise no gate checks is the anti-pattern this whole method is built against. What makes it real,
in order:

- **A baseline you watched.** The suite must be green *and observed green* before the refactor
  starts. A baseline nobody ran is not a baseline.
- **Coverage over the lines being merged.** Refactoring uncovered code is not behaviour *preserved*,
  it is behaviour *unobserved*. If the blocks are not covered, the first commit is a
  characterization test that pins what they do today — including the bug, if they have one.
- **Check whether the copies have actually diverged.** This is the single most common way a "pure
  refactor" changes behaviour: two copies that drifted have two behaviours, and unifying them picks
  a winner. That is a **product decision, not a refactor** — it goes to the Owner, and the answer
  goes in the spec's `Spec deltas` log or a confession.
- **The refactor is its own commit**, separate from every deletion, with the gate set green.

## 9. Hand the design off
For anything past a mechanical, fully covered merge, stop and delegate: `/codebase-design` for the
seam and the interface, `/improve-codebase-architecture` to grill the candidate properly. Bring it
the deletion test result and the three answers from step 7 — that is the part this skill contributes
and the part those skills do not have.

---

## 10. Wire the enforcer, or confess that it regrows
A sweep with no gate behind it means running this skill again in three months. Finish by wiring the
scanner into the project's gate set (`/harness` step 6), then **break it on purpose and watch it go
red** — a gate you have not watched fail is not a gate (PRINCIPLES #2). If the Owner declines, or
no tool fits this stack, that is fine: write "dead code will regrow here, unchecked" into
`REVIEW-DEBT.md` so the next session knows the sweep was a one-off.

## 11. Report
What was deleted and under which proof; what was **owed** rather than dead, and where you recorded
it; the env vars you could not settle and where you looked; what was kept duplicated and why; the
enforcer you wired with its pass → fail → pass; and every blind spot you knowingly did not check.
Then `/confess` the rest.
