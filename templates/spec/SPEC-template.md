# SPEC — <task>

Written after `/grill-with-docs`, before any code, on the Owner's explicit go. A thinking
artifact: lives in `specs/NNNN-slug.md`, never inside a build output.

Sections follow the installed `to-spec` skill's template so that skill can write this file
directly and `/code-review`'s **Spec axis** can read it. Two deliberate devkit deviations:

- **It's a local file.** `to-spec` publishes to an issue tracker; devkit keeps the spec in
  `specs/` and has the commit reference it. Where a project *does* have a tracker — some here do —
  link the issue at the top and keep this file canonical.
- **Tracer slices and Open questions are added sections** — PRINCIPLES #4 (slice end-to-end)
  and #7 (ambiguity goes to a human, never into a silent assumption) both need a home.

Use `CONTEXT.md` vocabulary throughout, and respect the ADRs covering the area you're touching.

## Problem statement
The problem, from the user's perspective. One paragraph.

## Solution
The solution, from the user's perspective. What changes for them — not how it's built.

## User stories
A long list, extensive enough to cover every aspect of the feature. Each one:
`As a <actor>, I want <capability>, so that <benefit>`. Tagged `US-n` because the acceptance
criteria below cite them by that tag — one numbering scheme, not two.
- **US-1** — As a <actor>, I want <capability>, so that <benefit>
- **US-2** — …

## Acceptance criteria  *(devkit addition — PRINCIPLES #1, #10)*
The unit of **done**. A task is done only when every criterion below reads `WORKS`; one `PARTIAL`
makes the whole task PARTIAL, and that is the honest answer (PRINCIPLES #10).

Rules, all four load-bearing:
- **Falsifiable.** You can state the observation that would disprove it. "Feels fast" is not a
  criterion; "first paint under 2s on a throttled 3G profile" is.
- **One line each.** If a criterion won't fit on one line, it's two criteria.
- **Every criterion names its proof route, before any code** — `test:<name>` (an automated test),
  `live:<recipe>` (a `/verify-live` exercise), or `review-only`. A `review-only` criterion is a
  confession waiting to happen: mark it, and expect to justify it.
- **`test:` is not enough on its own for anything a user touches.** Green tests gate; they do not
  prove (PRINCIPLES #1). User-facing criteria carry a `live:` route too.

`Verdict` starts at `unproven` and is filled in by `/verify-live`, never by the author.

| # | Criterion (falsifiable) | Serves | Proven by | Verdict |
|---|---|---|---|---|
| AC-1 | <the observable fact that must hold> | US-1 | `test:<name>` / `live:<recipe>` / `review-only` | unproven |
| AC-2 | <…> | US-2 | | unproven |

Referenced from commits as `Spec: specs/NNNN-slug.md#AC-3`, so `git log --grep=AC-3` shows what
proved what. This table is also what `/code-review`'s **Spec axis** checks the diff against.

## Tracer slices  *(devkit addition — PRINCIPLES #4)*
The end-to-end vertical slices, blockers first. Each cuts the whole stack and is demoable alone.
Slices cut *layers*; a slice never silently crosses a bounded context.
1. <slice> — <the thin full-stack cut it delivers>
2. <slice> (blocked by 1)

## Implementation decisions
The modules touched and the interfaces that change; architectural calls, schema changes, API
contracts, specific interactions. Tagged `D-n`, each **with its why** — the reason is the part that
stops the decision being re-litigated next session, and the part a bare list always loses. No file
paths and no code snippets; they go stale.
*Exception:* a snippet from a `/prototype` that encodes a decision more precisely than prose can
(a state machine, a reducer, a type shape) — inline the decision-rich part and say where it came from.
- **D-1** — <the decision, stated plainly>. **Why:** <the reason, and what it costs you>.
  → ADR-NNNN if it was load-bearing or hard to reverse

## Testing decisions
- What makes a good test here: external behavior only, never implementation detail.
- Which modules get tested, and at which seams (prefer existing seams; the highest one; fewest).
- Prior art: the similar tests already in this codebase to follow.

## Deliberate deviations  *(confessions up-front)*
Where this spec knowingly departs from what the issue or brief literally asked for — decided here,
with eyes open, rather than discovered later. Each is a confession made before anyone could accuse
you of it (PRINCIPLES #5), and it earns a `REVIEW-DEBT.md` entry too if it survives into the code.
- <what the ask said> → <what we're doing instead>, because <why>. (affects AC-N)

## Out of scope
The spec's **non-goals** (PRINCIPLES #7 calls them that; `to-spec` calls the section this).
What this deliberately does NOT do. Scope creep dies here.
- <non-goal>

## Open questions  *(devkit addition — PRINCIPLES #7)*
Ambiguities that need a human answer. An open question is never resolved by the agent's assumption.
- <question>

## Spec deltas  *(devkit addition — ANTI-PATTERNS: spec drift)*
The counterpart to **Deliberate deviations** above: those are known *now*, these are discovered
*during the build*. Reality diverges from a spec all the time; **silently** diverging is the defect. When the build
teaches you the spec was wrong, append a dated line here — never quietly edit the decision above
as though it had always said that. An unrecorded divergence is a confession you owe
`REVIEW-DEBT.md`.

- `YYYY-MM-DD` — <what changed vs. the spec above, and why> (affects AC-N)

## Further notes
Anything else worth carrying into the build.
