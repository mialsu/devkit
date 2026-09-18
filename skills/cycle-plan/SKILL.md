---
name: cycle-plan
description: Open a cycle by committing to a finite, capacity-checked set of ready work — carry-over accounted for, fenced work budgeted, and the commitment snapshotted so it can be measured later. Use at the start of a cycle/sprint/iteration, or when the user says "plan the cycle", "sprint planning", "what am I committing to".
---

A cycle is a **timebox you commit inside**, and the commitment is the whole point: it is the one
moment you are forced to say out loud how much fits. Everything else in a cadence — refinement,
close — exists to make this act honest.

Solo, most scrum ceremonies decay into theatre because they were built to coordinate between
people. This one does not, because its job is arithmetic against a calendar, and a calendar does
not care how many people there are.

**You propose; the Owner commits** (PRINCIPLES #8). Never write a commitment they have not said
yes to.

## Step 0 — the bindings, or bootstrap them

Read `CADENCE.md` at the project root. It holds what this skill cannot derive: which tracker, how
to reach it, what the readiness labels are called, which work classes are fenced, and what the
skills may write without asking.

**If it is absent, stop and bootstrap it** from `templates/CADENCE.md`, one question at a time,
recommendation first. Do not guess a tracker from the tools that happen to be loaded — a project
with two trackers in reach is exactly the project where guessing wrong is expensive. Write the file,
show it, get a yes, then continue.

Everything below resolves its tracker verbs through that file. This skill names no tracker, no
field, no team.

## Step 1 — the cycle, and its real last working day

Resolve the open cycle. **If none is open, say so and stop** — do not invent one or plan into a
cycle that has not started.

Then find the cycle's **last working day**, which is not its end date. Absences, travel, public
holidays, a conference, a demo that eats a day: all of these move it, sometimes by several days.
Ask the Owner, or read the calendar the bindings name.

This is the single most common way a cycle commitment is fiction. A cycle that nominally ends on a
Sunday and whose Owner is away the preceding Thursday and Friday has **three fewer working days
than its dates claim**, and anything dated into that gap is due after its own close.

State the number of working days you are planning against, out loud, before proposing anything.

## Step 2 — carry-over, with a reason each

List what the previous cycle committed and did not finish. Read it from that cycle's record file,
not from the tracker: a tracker shows the cycle's *current* contents, and by the end those are not
what was committed (see Step 6).

For each carried item, the Owner gives a **reason**, and the reason goes in the record:

- *blocked* — name the blocker and whether it moved
- *underestimated* — by how much, which feeds Step 5's sizing
- *displaced* — by what, which is usually fenced work and is a capacity finding, not a failure
- *wrong* — the item should not have been committed at all

**A third carry is a signal about the item, not about the week.** When something carries twice,
stop re-committing it and ask whether it is one item or three, or whether it is blocked on a
decision nobody has taken. Re-committing a thrice-carried ticket is how a backlog acquires a
permanent resident.

## Step 3 — budget the fenced classes

`CADENCE.md` declares work classes that **occupy the cycle without being committed**: interrupt-driven
work, support, another project's demands, anything the Owner has deliberately fenced out of the
commitment.

Fenced does not mean free. Reserve a named share of the working days for it — a number, agreed now,
not discovered later. If the last cycle's actuals are in its record, use them: fenced work is
usually more stable than anyone expects, and last cycle's figure beats an optimistic guess.

**If fenced work has consumed the majority of recent cycles, say so plainly.** A commitment that
excludes most of the Owner's actual week will read as under-delivery every single cycle, and the
instrument, not the Owner, is what is wrong. That is a conversation to have at planning, not at
close.

## Step 4 — candidates, and only ready ones

Gather candidates from the sources the bindings name — the roadmap, the milestone, the backlog, the
next-up queue.

**Only items at `ready` may be committed.** The ladder is in `CADENCE.md`, and by default:

| Rung | Means |
|---|---|
| `stub` | a title and a why. Nothing else is known |
| `scoped` | done-when written, blockers named, rough size |
| `ready` | acceptance criteria that each name how they will be proven, and blockers resolved or dated |

Anything below `ready` is refused, and **the refusal is reported with what it lacks**. A silent
exclusion is worse than a rejected item: the Owner thinks it is in the cycle.

The rung is the point of the whole cadence. An item that reaches planning as a stub has to be
specified *now*, under time pressure, by the person who also has to build it — which is how
ambiguity gets resolved by assumption (ANTI-PATTERNS: *silent scope-filling*). `/cycle-groom` exists
so that never happens; if you are routinely specifying at planning, groom is being skipped.

## Step 5 — size it, or say you are not sizing it

If the bindings say estimates are in use, size each candidate and total against Step 1's working
days minus Step 3's reserve.

If they are not in use, **say that the total is a count and not a capacity check**, and do not quote
the tracker's own scope or velocity figure — on an unestimated cycle it is not points and means
nothing. Offer to start estimating as a separate decision, scale included; do not start silently.

Either way the arithmetic is stated: *N working days, M reserved for fenced work, this many items,
here is why I believe it fits.* If it does not fit, cut before proposing, and name what you cut.

## Step 6 — propose, then snapshot

Show the Owner: the commitment, the excluded-and-why list, the carry-over reasons, the fenced
reserve, and the arithmetic. Ask for a yes. Cut on their word.

On approval, do two things **in this order**:

1. **Write the cycle record** — one file per cycle at the path the bindings name, holding the
   commitment as agreed, the working-day count, the fenced reserve, and the carry-over reasons.
2. **Then** set the cycle on the committed items in the tracker, within the write envelope
   `CADENCE.md` grants. Never set workflow state; never mark anything done.

The record first, because **a tracker forgets the opening commitment.** Items get added mid-cycle,
scope grows, and by the close the cycle's contents and its commitment are different sets. Without
the snapshot, `/cycle-close` can only report what is in the cycle now, which always looks like
success. The snapshot is what makes the close capable of saying no.

## Refuse, and say why

- No `CADENCE.md`, and the Owner declines the bootstrap.
- No open cycle.
- The Owner has not approved the commitment.
- A write the bindings do not grant. Stage it, name it, and let them apply it.

## Anti-patterns this skill exists to prevent

- **Committing to the dates instead of the days.** The calendar is the constraint, not the cycle
  boundary.
- **Planning unready work.** It converts refinement into guesswork performed under a deadline.
- **Letting the tracker be the record of the commitment.** It is a record of the current contents,
  which is a different thing, and it drifts in the direction that flatters you.
- **Counting fenced work as capacity, or pretending it is free.** Both produce a fiction; the first
  overcommits, the second overcommits and then blames the Owner.
- **Re-committing a thrice-carried item** without asking what is actually wrong with it.
