# SPEC — <task>

Written after `/grill-with-docs`, before any code, on the Owner's explicit go. A thinking
artifact: lives in `specs/NNNN-slug.md`, never inside a build output.

Sections follow the installed `to-spec` skill's template so that skill can write this file
directly and `/code-review`'s **Spec axis** can read it. Two deliberate devkit deviations:

- **It's a local file, not a tracker issue.** `to-spec` publishes to a project issue tracker;
  solo work has no tracker, so the spec lives in `specs/` and the commit references it.
- **Tracer slices and Open questions are added sections** — PRINCIPLES #4 (slice end-to-end)
  and #7 (ambiguity goes to a human, never into a silent assumption) both need a home.

Use `CONTEXT.md` vocabulary throughout, and respect the ADRs covering the area you're touching.

## Problem statement
The problem, from the user's perspective. One paragraph.

## Solution
The solution, from the user's perspective. What changes for them — not how it's built.

## User stories
A long, numbered list, extensive enough to cover every aspect of the feature. Each one:
`As a <actor>, I want <capability>, so that <benefit>`. Numbered because later steps cite them.
1. As a <actor>, I want <capability>, so that <benefit>

## Tracer slices  *(devkit addition — PRINCIPLES #4)*
The end-to-end vertical slices, blockers first. Each cuts the whole stack and is demoable alone.
Slices cut *layers*; a slice never silently crosses a bounded context.
1. <slice> — <the thin full-stack cut it delivers>
2. <slice> (blocked by 1)

## Implementation decisions
The modules touched and the interfaces that change; architectural calls, schema changes, API
contracts, specific interactions. No file paths and no code snippets — they go stale.
*Exception:* a snippet from a `/prototype` that encodes a decision more precisely than prose can
(a state machine, a reducer, a type shape) — inline the decision-rich part and say where it came from.
- <decision>  → ADR-NNNN if it was load-bearing or hard to reverse

## Testing decisions
- What makes a good test here: external behavior only, never implementation detail.
- Which modules get tested, and at which seams (prefer existing seams; the highest one; fewest).
- Prior art: the similar tests already in this codebase to follow.

## Out of scope
The spec's **non-goals** (PRINCIPLES #7 calls them that; `to-spec` calls the section this).
What this deliberately does NOT do. Scope creep dies here.
- <non-goal>

## Open questions  *(devkit addition — PRINCIPLES #7)*
Ambiguities that need a human answer. An open question is never resolved by the agent's assumption.
- <question>

## Further notes
Anything else worth carrying into the build.
