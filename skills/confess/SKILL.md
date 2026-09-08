---
name: confess
description: Record every seam that was faked, stubbed, deferred, or built weaker than the spec — into REVIEW-DEBT.md, at the moment it happened. Use when closing a session or a task, when the user says "confess", "what did you cut corners on", "close the session", or before marking work done.
---

Honesty is the accelerator: a project stays trustworthy only because nothing hidden is lurking
in it. This skill writes the truth down while it's still fresh.

## What counts as a confession
Anything you did that a future reader would be surprised by:
- a stub, a hardcoded value, a `TODO`, a happy-path-only implementation;
- **a deliberate ceiling** — a simplification that is correct today with a known limit (a global
  lock, an O(n²) scan, a naive heuristic). It carries a `CEILING:` comment and an `Upgrade:` line
  in the code; the ledger entry is the other half, and the drift gate fails a marker that lands
  without one;
- a test that asserts less than the behavior actually needs;
- something built narrower than the spec, or a spec ambiguity you resolved by guessing;
- a thing that works locally but you couldn't fully verify (say why);
- a known cosmetic or edge-case defect you saw during `/verify-live`;
- **any acceptance criterion left `unproven`, `PARTIAL` or `BROKEN`** — one entry per criterion,
  quoting it, so the gap is legible without opening the spec;
- **a divergence from the spec that isn't written in the spec's `Spec deltas` log** — silent
  divergence is the defect, not the divergence;
- **an invariant tagged `[review-only]`, or a context boundary that isn't in the boundary gate's
  rules** — the label is honest, the debt is still owed. Name the `INV-n` and what would have to be
  written to enforce it.

Silence about any of these is the defect, not the corner-cut itself.

## How to record it
Append to the project's `REVIEW-DEBT.md`, one entry per confession:

```
## <date> — <one-line title>
- **What:** what is stubbed / faked / deferred / weaker than spec.
- **Where:** file:line anchors.
- **Criterion:** `AC-N` from `specs/NNNN-slug.md`, quoted  (omit if there was no spec)
- **Invariant:** `INV-N` from `INVARIANTS.md`, quoted  (omit unless a domain rule is involved)
- **Ceiling:** what breaks at the limit, and the upgrade path  (omit unless a `CEILING:` landed)
- **What green tests do NOT prove here:** the specific gap.
- **Disposition:** open  (later: fixed / accepted-with-reason / promoted-to-issue)
```

For Light-weight tasks, a single confession line in the commit message is enough; for Standard
and Full, it goes in `REVIEW-DEBT.md`. Do not invent debt to look diligent, and do not launder
real debt into vague reassurance — each entry names a concrete, checkable gap.

## Then
Report the confessions to the Owner in plain words and let them disposition each one (fix now /
accept / turn into an issue). Undispositioned entries are read first by any later architecture
or review session.
