---
name: cycle-close
description: Close a cycle against what was actually committed — done vs committed per item, carry-over with reasons, unplanned work reported separately, one honest throughput number, and the outward report the cadence owes. Use at the end of a cycle, or when the user says "close the cycle", "sprint review", "what did I actually finish".
---

Review and retrospective, merged, because solo they are the same conversation: *what did I commit
to, what happened, and what does that change about the next commitment.*

This is the ceremony that keeps the cadence honest, and it has exactly one way to fail: measuring
against what the cycle contains now instead of what it committed to at the start. Those are
different sets, they diverge in the flattering direction, and only one of them is a commitment.

**An honest PARTIAL always beats an indefensible DONE** (PRINCIPLES #10). This skill reports; the
Owner decides what is finished.

## Step 1 — the commitment, from the record

Read `CADENCE.md`, then read the closing cycle's **record file** — the one `/cycle-plan` wrote,
holding the commitment as agreed, the working-day count, the fenced reserve and the carry-over
reasons.

**If there is no record, refuse.** You cannot close what was never committed. Say what is missing,
and offer to report the cycle's contents as a plain summary instead — clearly labelled as *not* a
close, because a summary with no commitment behind it cannot distinguish delivery from drift.

Never reconstruct the commitment from the tracker's current contents to get past this. That is the
exact substitution the whole ceremony exists to prevent.

## Step 2 — committed versus done, one line each

For every committed item: done, partial, not started, or carried. Where the bindings name a
verification standard, apply it — **"it is wired" and "it builds" are not done** (PRINCIPLES #1),
and if the project has a live-exercise skill this is the moment its verdict counts.

Partial is a real outcome and gets stated as one, with what is missing. Rounding a partial up is how
a tracker stops being trustworthy, and a tracker is trusted only because nothing on it is marked
done that isn't.

## Step 3 — carry-over, with a reason each

Same four reasons `/cycle-plan` reads back — *blocked*, *underestimated*, *displaced*, *wrong* — and
they are written here, at close, while you still remember which it was. Deciding the reason at the
next planning session, a week later, produces a guess.

Flag anything now carrying for the **second** time. The next planning session refuses a third carry
without a conversation, and this is where that count is kept.

## Step 4 — what landed that was never committed

Report it **separately**, under its own heading, never folded into the commitment's numbers:

- **fenced classes** the bindings declared — this is expected, and the figure is the input to the
  next cycle's reserve. Compare it against what was reserved and say whether the reserve was right.
- **unfenced additions** — work that arrived mid-cycle and was neither committed nor fenced. This is
  the number to watch. A cycle whose additions rival its commitment is not being planned; it is
  being interrupted, and the fix is a fencing decision at planning, not more discipline here.

Do not count either as a commitment miss. The commitment was wrong about capacity, not about the
work — and the distinction is the difference between a useful measurement and a demoralising one.

## Step 5 — one honest number

Report **throughput**: committed items finished, against committed. One number, per cycle, kept in
the record so it accumulates.

Team velocity does not transfer to one person, but personal throughput does — after three or four
cycles it is the only reliable input to "how much fits", and it beats every estimate. Until then say
so: with one or two cycles of history the number is an anecdote, and quoting it as a capacity figure
is false precision.

If estimates are not in use, say the number is a count of items and carries no size information.
Never quote the tracker's own velocity or scope figure on an unestimated cycle.

## Step 6 — what the estimates got wrong

The solo retrospective that actually works, because it feeds a decision rather than a discussion.
Two questions, briefly:

1. Which items were sized wrong, and in which direction? A pattern here is worth more than any
   single estimate — consistently underestimating one class of work is a fact you can plan around.
2. What did the cycle teach that changes the **next** commitment? Not a general lesson; a specific
   change to what you will accept into the next cycle.

Skip the ritual questions. *What went well* with an audience of one produces nothing.

## Step 7 — the outward report

If `CADENCE.md` names a recipient and a format, draft it. This is what stops the ceremony decaying:
a close whose output is a note somebody actually reads has a reason to be accurate, and a close that
only writes to its own record does not.

Draft it; do not send it. Sending is outward-facing and the Owner's act.

## Step 8 — write the record, then stop

Append to the cycle's record file: the per-item outcomes, carry-over reasons, unplanned work, the
throughput number, the estimate findings.

Then stop. Specifically, **do not**:

- **set workflow state or mark anything done.** The Owner does that. A close that also declares
  completion is grading its own homework.
- **edit the commitment to match what happened.** A commitment that shipped short is the finding.
  Rewriting it is the *spec drift, silently* anti-pattern, at cycle scale — and it destroys the only
  record that could have taught you anything.
- **move carried items into the next cycle.** That is `/cycle-plan`'s act, and it needs the Owner's
  yes.

## Refuse, and say why

- No `CADENCE.md`.
- No cycle record for the closing cycle — offer the labelled summary instead.
- Asked to close a cycle that has not ended. Say what is left and offer a mid-cycle check.
- A write the bindings do not grant.

## Anti-patterns this skill exists to prevent

- **Closing against the cycle's current contents.** Always looks like success; measures nothing.
- **Rounding partials up**, which is how a tracker quietly stops being the truth.
- **Folding unplanned work into the commitment**, which hides the capacity finding and turns a
  planning problem into an apparent performance problem.
- **Rewriting the commitment** so the cycle reads as delivered.
- **Marking things done.** Not yours to do, and it removes the one review the cadence has.
- **A retrospective with no decision in it.** If nothing about the next commitment changed, the
  ceremony did not happen.
