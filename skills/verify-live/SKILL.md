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
4. **Return a verdict**: WORKS (with the evidence) / PARTIAL (works, but here is exactly what
   doesn't) / BROKEN (with the repro). Never soften a PARTIAL into a WORKS.

Only after a WORKS verdict — with evidence — may a task be called done. If you can't exercise it
(no device, no stack up), say so plainly and mark the task blocked, not done.
