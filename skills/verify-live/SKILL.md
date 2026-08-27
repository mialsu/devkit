---
name: verify-live
description: Prove a change works the way a user hits it — the step that turns "built" into "done". Use after building or before marking anything done, and whenever the user says "verify", "does it actually work", "check it live", "prove it", or is about to close a task.
---

Green tests gate; they do not prove. This skill produces the *proof*: the thing exercised the
way a real user reaches it, with evidence you could show someone. What "exercise it" means is
set by the project's domain profile — read `profiles/<domain>/PROFILE.md` (or the
`## Verify like a user` section the project copied into `CLAUDE.md`) and follow its recipe.

## The contract, every domain
1. **Reach it the way a user does**, not through a test harness or a unit call. The profile
   names the concrete recipe:
   - **web** → real browser, real navigation, real clicks/mutations; screenshots.
   - **mobile-fullstack** → the built app on a device/emulator; tap the real flow; screen capture.
   - **game** → build and *play* the slice; capture a short clip or key frames; note whether the
     mechanic actually feels right, not just that it runs.
   - **cli-tools** → run the built binary on real input; check stdout/stderr and exit codes;
     confirm `--help` renders and a clean install works.
   - **library** → consume your own public API from a scratch script exactly as a user would
     import it; confirm the documented examples actually compile and run.
2. **Use the real persona / real conditions**, never a privileged shortcut. If the thing behaves
   differently for a restricted user, a small screen, a slow input, or an empty state — exercise
   *that*, because that is where the bugs the tests missed actually live.
3. **Evidence is honest.** Capture what you saw — including errors and ugliness. A screenshot of
   a broken state is evidence; skipping it is a lie. Cosmetic problems visible in the evidence go
   to `REVIEW-DEBT.md`, they don't get silently smoothed over.
4. **Return a verdict per acceptance criterion, not per task.** If the spec has an
   `## Acceptance criteria` table, that table *is* the checklist: exercise each criterion by the
   proof route it names, then write its verdict into the `Verdict` column — **WORKS** (with the
   evidence) / **PARTIAL** (works, but here is exactly what doesn't) / **BROKEN** (with the
   repro). Never soften a PARTIAL into a WORKS.

   A criterion whose route is `test:` and that a user can touch is **not** proven by the test
   passing. Exercise it live too, or record it PARTIAL with that gap named (PRINCIPLES #1).

   No AC table — a Light task, or an older spec? Return one verdict for the task, and say which
   spec you checked against, or that there wasn't one.

## Attack the invariants the slice touches
An acceptance criterion asks "does it do the thing?" — a happy-path question. An invariant asks
"can I break the domain?", and only the second one finds the bug that ships. If the project has an
`INVARIANTS.md` and the spec names `Invariants touched`, then for each of those `INV-n`: **try the
violation the invariant itself describes** — the double submit, the overlapping booking, the
out-of-order arrival, the concurrent edit, the cancelled thing revived.

- It's refused → say which layer refused it (the DB constraint, the type, the service check). A rule
  enforced only in the UI is not enforced.
- It goes through → that is a **BROKEN** finding on its own, whatever the AC verdicts say, and it
  outranks them: a violated invariant is a bug in every release, not an unfinished slice.

## The task verdict is the worst criterion's verdict
One PARTIAL makes the whole task PARTIAL, however many WORKS surround it. Report it that way and
list the criteria that aren't green. A task-level "works" that averages over a broken criterion is
exactly the overclaim PRINCIPLES #10 exists to stop, and it is the granularity where an
indefensible DONE actually hides.

Only when **every** criterion reads WORKS — each with evidence — may the task be called done. Hand
each non-WORKS criterion to `/confess` as its own ledger entry, quoting the criterion.

If exercising a criterion turns out to be impossible (no device, no stack up), say so plainly and
mark it blocked, not done. If the criterion itself turns out to be wrong or unfalsifiable, that is
a **spec delta**, not a verdict — record it in the spec's `Spec deltas` log and tell the Owner.
