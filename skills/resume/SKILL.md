---
name: resume
description: Pick up a project from its most recent session handoff — find it, read it, and verify its claims against the code before acting. Use when starting a fresh session on work that a previous session handed off, when the user says "resume", "where were we", "continue where we left off", or "pick up the handoff".
---

`/handoff` (mp) writes a handoff and stops. Nothing reads it back, so the Owner has to remember a
path — and the one thing they will not remember tomorrow is a path. This is the other half.

It exists because Pocock's skill has no resume side, not because devkit wanted its own handoff.
**Do not write handoffs from here**; `/handoff` owns that format (METHOD.md, *reuse before
building*). This skill only finds, reads and interrogates one.

## Where handoffs live

```
~/.claude/handoffs/<project-slug>/YYYY-MM-DD-HHMM.md
```

`<project-slug>` is the basename of the project root — the child of your **projects root**, not the
repo you happen to be standing in. A project with four sibling repos has **one** handoff directory.

The projects root is the directory whose `CLAUDE.md` imports devkit (`@./devkit/METHOD.md`); on this
setup that is `~/code/personal`. Derive it rather than assuming it, so the skill survives someone
laying their tree out differently.

Deliberately **not** the OS temp directory that `/handoff`'s own `SKILL.md` names — most Linux boxes
empty `/tmp` on boot. METHOD.md's *Session handoffs* is the rule and carries the reasoning; this is
the path you need to do the job.

## Arguments

| Invocation | Does |
|---|---|
| `/resume` | newest handoff for the current project |
| `/resume <slug>` | newest for a named project |
| `/resume --list` | every handoff, per project, newest first — nothing is read |

## Steps

### 1. Find it
Walk up from `$PWD` to the first directory containing a `CLAUDE.md` that imports devkit; the slug is
the basename of the child you came through. Then list `~/.claude/handoffs/<slug>/` newest-first and
take the top file. Confirm the slug out loud before reading — a wrong slug silently reads another
project's handoff, which is worse than reading none.

If the directory is empty or absent, **say so and stop**. Do not go hunting through `/tmp`, do not
reconstruct a handoff from git log, and above all do not improvise a summary — a fabricated "where
we were" is worse than an honest "there is no handoff here", because the Owner will act on it. Offer
`git log --since` and the project's `REVIEW-DEBT.md` as the honest fallback and let them choose.

### 2. Read it, and read what it points at
A good handoff is mostly pointers. Follow them — `BACKLOG.html`, `REVIEW-DEBT.md`, the ADRs, the
named commits. The handoff is an index, not the content; treating it as the content is how a session
inherits a summary of a summary.

### 3. Verify before you act — this is the whole point

**A handoff is a claim** (PRINCIPLES #6). It was true when written; the repo has moved since, and
the previous session may have copied figures forward without re-measuring them. Anything load-bearing
gets checked against the code *before* the first edit, not after:

- test counts, coverage percentages, "N of M failing"
- "X already works" / "Y is already done" / "Z is already confessed"
- branch and sync state, and whether anything is unpushed
- any file:line reference — files move

`/verify-claim` is the tool for the ones that matter. Run it on the two or three the next task
actually depends on, not on all of them; a verification pass nobody reads is its own pseudo-artifact.

Report each as **holds / moved / wrong**, with the evidence. A handoff whose claims have rotted is a
useful finding in itself — say so plainly rather than quietly working around it.

### 4. Check what the handoff could not know
It was written before the session ended. Between then and now: commits may have landed, CI may have
run, a deploy may have fired. Look at `git log` since the handoff's timestamp and at any CI the
project gates on, before assuming its "where things stand" still stands.

### 5. State the position, then ask
Give the Owner a short, concrete position — what is done, what is live, what is next, and which of
the handoff's claims failed verification. Then **ask what to work on**. Do not pick up the "next
step" the handoff names and start building: it was a recommendation from a session that could not
see today, and the Owner decides (PRINCIPLES #8).

## Anti-patterns this skill exists to prevent

- **Trusting the handoff over the code.** The exact defect `/verify-claim` was written for, arriving
  through a friendlier-looking door.
- **Inventing a handoff when none exists.** Say the directory is empty. Nothing else is honest.
- **Reading only the handoff.** It is deliberately thin and points outward. Follow the pointers.
- **Sliding from resuming into building.** Resuming is orientation. The go is a separate act.
