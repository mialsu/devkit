---
name: spike
description: Answer a feasibility question against an existing codebase — could this work here at all? — with a timeboxed throwaway and a verdict backed by file:line evidence. Use when the user says "spike", "can we even", "is this possible in this repo", "try it and see", "proof of concept", "test if X would work", or when a shaping question cannot be settled without touching the code. Never builds anything meant to ship.
disable-model-invocation: true
argument-hint: "[the question]"
---

Three questions look alike and are not. `/verify-claim` asks **does it work today**. `/prototype`
(mp) asks **does this design feel right**. This asks the third: **could this work here at all** —
against this codebase, with these constraints, before anyone commits to building it.

The output is a **verdict with evidence**. The code is an appendix, and it is throwaway from the
first keystroke. A spike that produces something shippable has failed at being a spike.

## This skill runs outside devkit's tree

`install.sh` links devkit's skills into `~/.claude/skills`, so this one is invocable in any repo on
the machine — including a work monorepo, where `PRINCIPLES.md` and `METHOD.md` do **not** load.
It therefore carries its own spine and never cites a file the caller may not have:

1. **Reuse before building** — the capability may already exist in a codebase this size. Look first.
2. **Verify claims against code** — "the API already supports that" is a claim until file:line says so.
3. **Confess what you faked** — the report names every shortcut, or the verdict is worthless.
4. **The Owner decides** — the spike recommends; it does not adopt, merge, or ship.
5. **Gates are not waived, they are out of scope.** A spike never lands on a shared branch, so
   "gates before every commit" has nothing to gate. The moment any of it lands, the rule applies in
   full and the code is rewritten, not promoted.

## Steps

### 1. Make the question falsifiable, and put a clock on it

Write one sentence with a yes/no answer and a named observation that would settle it. "Can we stream
partial results through the existing response layer?" is a spike. "Look into streaming" is a task
that never ends.

Then set a **timebox** and a **kill criterion** — the thing that, if hit, ends the spike early with
`BLOCKED`. Both go at the top of the report. A spike with no clock becomes an unplanned project, and
that is the failure mode this skill exists to prevent.

### 2. Probe the constraints before writing anything

A mature codebase decides much of what a spike is allowed to be. Detect what you can; ask the Owner
what you cannot:

| Constraint | Detect by | Matters because |
|---|---|---|
| Can it run locally, and how slowly? | a README, a compose file, a `dev` script | a 20-minute boot changes the whole shape of the probe |
| May a dependency be added? | lockfile, vendoring policy, an internal registry | if not, the spike must work with what is installed |
| Is the test suite writable? | existing test dirs, their ownership | riding the existing harness is far cheaper than a TUI |
| Who owns this code? | `CODEOWNERS`, `git log` on the target files | a spike in someone else's module is a conversation first |
| Is there usable data? | fixtures, seeds, a scratch environment | otherwise the probe needs its own, and says so |

Ask them as a short list, once. Do not interview the Owner one question at a time here — the spike
is supposed to be the fast path.

### 3. Scout for the answer before building it

The cheapest spike is the one that never gets written. In a large codebase, search for the
capability under every name it might carry before assuming it is absent. If something claims to do
it already, that is a claim — hand it to `/verify-claim` and let the verdict come back with
file:line before you write a line.

Report a `FEASIBLE` that came from a scout exactly as loudly as one that came from code. Finding
the thing already built is the best possible outcome.

### 4. Declare the blast radius, then stay inside it

Write down, before touching anything:

- **Where the spike may write** — the seam it is probing, and a branch named `spike/<slug>`.
- **What it may never touch** — CI configuration, `CODEOWNERS`, migrations, lockfiles, shared
  modules, generated files, and any branch anyone else uses. In a repo that is not yours, this list
  is the difference between a spike and an incident.
- **What it will fake** — stubs, hardcoded values, bypassed auth, an in-memory store standing in for
  the real one. Every item here reappears in the report under *what this did not prove*.

Never push, never open a PR, never touch `main`. If the work needs any of those to proceed, stop and
say so; that is a finding, not a blocker to route around.

### 5. Build the smallest thing that answers the question

Smallest means smallest. A failing test that turns green is often the whole spike, and in a repo with
a working suite it is almost always cheaper than anything else. A script beside the module beats a
new surface. Reuse the project's runner, its fixtures, its conventions — you are borrowing a
codebase, not starting one.

If the question turns out to be about **shape** rather than possibility — "yes it can work, but is
this the right state model / the right screen" — that is `/prototype`'s job. Hand it over and say so
in the report. Feasibility answered, design question opened, is a complete and useful spike.

### 6. Write the report, outside the repo

```
~/.claude/spikes/<repo>/YYYY-MM-DD-<slug>.md
```

`<repo>` is the basename of `git rev-parse --show-toplevel`. Deliberately **not** the projects-root
derivation `/resume` uses for handoffs — a work repo has no devkit projects root — and deliberately
not the OS temp directory, which most Linux boxes empty on boot. It lives outside the repo because a
spike in someone else's codebase has no business leaving files in it, and because the report is the
deliverable: it must survive `git checkout main`.

The report carries:

- **The question**, the timebox, and the kill criterion, as written in step 1.
- **The verdict:**
  - **FEASIBLE** — demonstrated, with the exact command that reproduces it.
  - **FEASIBLE-WITH-COST** — it works, and these named things must change first. List them; each is
    a piece of the estimate someone is about to make.
  - **BLOCKED** — the wall, at file:line, and whether it is technical or organisational.
  - **INCONCLUSIVE** — the clock ran out. How far it got, and the single next probe worth running.
- **Evidence** — file:line for every code assertion, the command and its output for every behaviour
  assertion. A verdict with no evidence is a guess wearing a label.
- **What this did NOT prove** — every fake from step 4, plus what differs from production: scale,
  concurrency, real data shape, auth, error paths. This section is the reason the verdict can be
  trusted, so write it before anyone asks.
- **Blast radius touched** — what was actually modified, so it can be reverted.

Even `FEASIBLE` does not mean done, and the report says so in those words. It means one question got
a yes.

### 7. Take one of three doors

- **Dies** — the answer is the deliverable. The branch stays local as the primary source; the report
  is what anyone reads.
- **Feeds a spec** — the verdict resolves an open question in shaping. Quote the verdict and link the
  report from the spec, then continue at `/grill-with-docs` or `/to-spec`.
- **Becomes work** — someone builds it properly, under the full loop, from scratch. The spike's code
  is read for reference and then abandoned. It was written with no tests, no error handling and no
  standards; promoting it launders all three into a codebase that will not notice.

State which door was taken. A spike with no door is an orphan branch and a report nobody acts on.

## Anti-patterns

- **Building something finished.** The moment it has error handling, polish or a second feature, it
  stopped answering the question and started being unpaid work on a project nobody approved.
- **Letting the timebox slide.** "Almost there" at the deadline is `INCONCLUSIVE` with a named next
  probe. That verdict is genuinely useful; a spike that quietly runs for a week is not.
- **A verdict with no evidence.** `FEASIBLE` without a reproduce command is an opinion.
- **Skipping the scout.** Half of all feasibility questions in a mature codebase are answered by
  someone else's module from two years ago.
- **Touching shared state to make the probe easier.** Rewriting CI, editing a migration or reaching
  into another team's module converts a cheap experiment into an expensive apology.
- **Reporting only the good news.** The *what this did not prove* section is what makes the rest
  believable. A spike that faked auth and does not say so has produced a false estimate.
