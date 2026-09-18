# Cadence — <PROJECT NAME>

The bindings the `/cycle-*` skills read. It holds only what they **cannot derive**: which tracker,
how to reach it, what the rungs are called, which work is fenced, and what an agent may write
without asking.

Keep it short. Everything in here is load-bearing on the next planning session, so a line nobody
maintains becomes a wrong instruction rather than a stale note.

Exists only when work is tracked in cycles. A project with no tracker does not need this file, and
devkit's loop runs fine without one — see *The cadence dial* in `METHOD.md`.

## One word for the timebox: **cycle**

Trackers call it a sprint, an iteration, a milestone. Pick one word for this project and use it
everywhere, including in conversation. Two words for one thing forks the vocabulary and the agent
starts writing a parallel one (`ANTI-PATTERNS.md`).

- This project's word: **cycle**
- The tracker's own word, if different: `<sprint | iteration | …>` — *translate at the boundary,
  never inside the project's own prose*

## Tracker

| | |
|---|---|
| **Tracker** | `<name>` |
| **Scope** | `<the team / board / project the cycles belong to>` |
| **How to read a cycle** | `<the exact tool or command, and what identifies the open one>` |
| **How to read an item** | `<tool or command>` |
| **Cycle length** | `<2 weeks>`, starting `<Monday>` |
| **Where the cycle record lives** | `cadence/<cycle>.md` |

The record path matters more than it looks. `/cycle-plan` writes the commitment there and
`/cycle-close` measures against it, because **a tracker forgets what was committed at the start** —
items get added, and by the close its contents and its commitment are different sets.

## Readiness ladder

Only `ready` may be committed. Name what each rung is called *in the tracker*, so the skills can
read and set it.

| Rung | Tracker label | Means |
|---|---|---|
| `stub` | `<label>` | a title and a why. Nothing else is known |
| `scoped` | `<label>` | done-when written, blockers named, rough size |
| `ready` | `<label>` | acceptance criteria each naming how they'll be proven; blockers resolved or dated |

**Horizons the Owner works to:** current cycle committed · next `ready` · the one after `stubbed`.
Anything further out is a roadmap entry, not a ticket.

## Refinement skills by work class

`/cycle-groom` dispatches rather than authoring. Where a class of work has its own pipeline, name
it; where none is named, groom specifies the item itself against the ladder's bar.

| Work class | Skill that refines it |
|---|---|
| `<class>` | `<skill>` |
| anything else | `/to-spec`, or inline against the ladder |

## Fenced work

Classes that **occupy the cycle without being committed** — interrupt-driven work, support, another
project's demands. Fenced is not free: planning reserves a named share of the working days for it,
and close reports the actual separately.

| Class | Why it is fenced | Reserve |
|---|---|---|
| `<class>` | `<reason>` | `<n days or %>` |

**A warning to re-read every few cycles.** If fenced work is the majority of your actual week, the
commitment describes a minority of it and will read as under-delivery every cycle. That is the
instrument being wrong, not the Owner. Revisit the fence rather than the discipline.

## Working days, not dates

A cycle's **last working day is not its end date**. Absences, travel, holidays and a day-long
commitment all move it. Name where the truth lives so planning can check it rather than assume:

- **Calendar/source:** `<where>`
- **Known absences this horizon:** `<list, or "ask the Owner at planning">`

## Estimates

- **In use:** `<yes | no>`
- **Scale:** `<points | days | t-shirt | none>`

If `no`, the skills report item counts and say so, and **never quote the tracker's own velocity or
scope figure** — on an unestimated cycle it is not points and means nothing. Starting estimates is a
deliberate decision, scale included; it does not begin by accident.

## The outward report

What `/cycle-close` drafts, and for whom. A close whose output somebody reads stays accurate; one
that only writes to its own record decays.

- **Recipient:** `<who, by role>`
- **Format:** `<where it goes and roughly what shape>`
- **Sending is the Owner's act.** The skill drafts and stops.

## Write envelope

What the `/cycle-*` skills may change without asking. Anything outside it is **staged and named**
for the Owner to apply.

| May | May not |
|---|---|
| set the cycle on an item | set workflow state |
| set the estimate | mark anything done |
| set the readiness rung | touch items outside **Scope** above |
| create stubs in `<the named projects>` | edit an item's body that the Owner authored |

**If the project's own rules are stricter, they win.** A repo whose `CLAUDE.md` forbids agents
creating issues overrides this table until that rule is changed — inherited docs lose to a repo's
own. Check before granting anything here, and record the date the Owner granted it.

- **Granted by the Owner on:** `<date>`

## Ceremonies

Three. Daily standup is deliberately absent: it coordinates between people, and solo it is a status
report to yourself.

| Ceremony | When | Length | Output |
|---|---|---|---|
| `/cycle-plan` | `<day>`, week 1 | `<45 min>` | a capped commitment |
| `/cycle-groom` (next cycle) | `<day>`, week 1 | `<60 min>` | candidates at `ready` |
| `/cycle-close` | `<day>`, week 2 | `<30 min>` | outcomes + the outward report |

**If one has to go, keep groom.** A cycle planned badly from ready work costs a cycle; a cycle
planned well from unready work costs the defect shipped inside it.
