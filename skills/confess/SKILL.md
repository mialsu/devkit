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
Add each confession to the project's `REVIEW-DEBT.md` in two places: a line at the top of its
**Index** (`<date> — <title> — open`), and the full entry below it, newest first:

```
## <date> — <one-line title>
- **What:** what is stubbed / faked / deferred / weaker than spec.
- **Where:** file:line anchors.
- **Criterion:** `AC-N` from `specs/NNNN-slug.md`, quoted  (omit if there was no spec)
- **Invariant:** `INV-N` from `INVARIANTS.md`, quoted  (omit unless a domain rule is involved)
- **Ceiling:** what breaks at the limit, and the upgrade path  (omit unless a `CEILING:` landed)
- **What green tests do NOT prove here:** the specific gap.
- **Disposition:** open  (later: accepted-with-reason; fixed and promoted entries leave the file)
```

For Light-weight tasks, a single confession line in the commit message is enough; for Standard
and Full, it goes in `REVIEW-DEBT.md`. Do not invent debt to look diligent, and do not launder
real debt into vague reassurance — each entry names a concrete, checkable gap.

## Then
Report the confessions in plain words. Do not ask the Owner to disposition each one as it is
written: a decision asked for mid-build, one at a time, is not made (ADR-0004 in devkit found
69–88% of entries still `open`). Disposition happens in one pass at the close of the mandate,
where `/mandate` shows the Owner that mandate's new entries, each with a recommendation. Outside
a mandate, offer the same one-pass review when the session closes.

After the Owner decides: a **fixed** or **promoted-to-issue** entry leaves the file, index line and
all; git history keeps it. An **accepted** entry stays, with its reason, because the limit it
describes is still in the code.
