---
name: sketch
description: Build a whole app fast — one slice, end to end, in a day — to answer a product question before a brief or a repo exists. Use when the user says "sketch", "just build a rough version", "throw something together", "I want to see if this idea is any good", or when an idea is cheaper to build for a day than to argue about. Ends in a verdict and either dies or graduates to /product-brief.
disable-model-invocation: true
argument-hint: "[the idea]"
---

`/product-brief` asks what should be built. `/spike` asks whether a thing is possible in a codebase.
This asks the question that comes before both: **is there anything here worth building at all** —
answered by using the thing for ten minutes rather than reasoning about it for two hours.

Some ideas are cheaper to build than to discuss. This is the skill for those, and its output is a
verdict, not an app.

## Where this sits

```
   idea
     │
     ▼
   /sketch          is there anything here? one slice, one day, throwaway.
     │              → dies (answer written down)  ·  or graduates ↓
     ▼
   /product-brief   ◄────────┐   problem, core value, MVP cut, riskiest assumption
     │                       │   + the cheapest test that could falsify it
     │                       │
     └── when that test is "build a one-day version" ──► /sketch ──┘
     │
     ▼
   /new-project     scaffolds CLEAN. The sketch's files are never promoted.
```

Both entries are legitimate. Cold, a sketch tells you what the brief should even say. Prescribed, it
*is* the brief's cheapest falsifying test — `/product-brief` already asks for one and has never had a
tool that builds a whole app in a day.

The exit is fixed: **a sketch never becomes `/new-project` directly.** Skipping the brief is how a
weekend's momentum turns into three weeks of building the wrong thing well.

## Steps

### 1. One question, one clock

Write the product question the sketch exists to answer, in one sentence, with an answer you could
get by using the result. "Does reviewing flashcards by voice feel better than tapping?" is a sketch.
"Build a flashcard app" is a project with no exit condition.

Set the timebox in hours or a day. Write the date it dies.

### 2. Declare Light, in a file

Anything born inside a tree whose `CLAUDE.md` loads a method inherits that method — gates, specs,
the domain dial, the lot. That is the weight you are trying to escape, so switch it off explicitly.
A project's own `CLAUDE.md` wins on specifics, so the sketch's first file is:

```markdown
# <name> — a SKETCH, not a project

Weight: **Light**. Throwaway code answering one product question.

**Question:** <the one thing this exists to answer>
**Dies or graduates on:** <date>

OFF here, deliberately: gates before every commit, the standards harness, the domain dial,
specs, ADRs, REVIEW-DEBT.md, /verify-live, /code-review.
ON here, always: the question above is written down, the answer gets written down, and nothing
in this directory is promoted to a real project — graduation goes /product-brief → /new-project,
which scaffolds clean.
```

Put the sketch wherever you keep code; the file above is what makes the weight honest rather than
assumed. Without it, the next session opens the directory and starts applying the full method to a
throwaway.

### 3. Pick a boring stack in one line

The stack you already know, chosen in a sentence, with no comparison table. An unfamiliar framework
means the day gets spent learning it, and the verdict at the end is about the framework rather than
the idea.

No auth, no database unless the question is about data, no deployment, no settings screen. Those
three eat a sketch whole and answer nothing.

### 4. One slice, all the way through

The one rule from the method that applies at full strength here: the slice cuts data → logic →
surface → words → it actually does the thing. A schema with no screen and a screen over nothing are
both zero information.

One slice. Not the best slice — the one that carries the question. If the question is whether voice
review feels good, build voice review over three hardcoded cards and skip everything else in the
product.

When a piece of the slice turns into a real design question — which layout, which state model —
that is `/prototype` (mp), and it is worth the detour only if the answer blocks the demo.

The surface still has to not look like a default, because a sketch judged on an ugly screen answers
the wrong question — you learn that you dislike the screen. That is `ui-ux-pro-max` —
`--design-system` for the look, `--stack <name>` for how a component is built in whatever you
reached for. What a
sketch does **not** get: no `DESIGN.md`, no `A11Y-n` table, no persisted design system. There is no
contract to write for code that is being thrown away, and `--persist` fails drift check 11 anyway.

### 5. Use it like a user, for ten minutes

The demo is the evidence. Run the thing the way someone would, and pay attention to the moment you
get bored, confused, or annoyed — that reaction is the entire deliverable, and it does not survive
being remembered. Write it down while it is still happening.

If someone else can be handed the sketch for five minutes, that is worth more than an hour of your
own use, because you know what it is supposed to do and they do not.

### 6. Verdict, then a door

Write the verdict where the sketch lives, in its `CLAUDE.md` or beside it:

- **ALIVE** — worth a brief. Say what the sketch taught that the brief now needs: the real core
  loop, the assumption that turned out to be wrong, the edge case that appeared immediately.
- **DEAD** — and precisely why. This is a success. A day spent killing an idea is the cheapest that
  idea will ever be, and the reason belongs in writing so it is not re-litigated in six months.
- **PIVOTED** — the interesting thing was something adjacent. Name the new question; that is the
  next sketch, and the current one is now dead.

Then take the door. `ALIVE` goes to `/product-brief`, carrying the findings into the riskiest-
assumption section. `DEAD` and `PIVOTED` end here.

**The sketch's code never carries over.** It was written with no tests, no gates and no standards,
under a file that says so. `/new-project` scaffolds clean and the validated decisions travel as
prose in the brief, which is the only part that was ever worth keeping.

## Anti-patterns

- **A second slice before the first one runs.** Two half-slices answer nothing; one whole one
  answers the question. This is the failure that turns a day into a fortnight.
- **Auth, settings, onboarding.** They feel like progress, take a day each, and cannot move the
  verdict.
- **A stack you wanted to try.** Legitimate, and it is a different activity with a different name.
  Do not let it wear the sketch's clothes, because the verdict comes out about the tooling.
- **Letting the date slide.** The clock is what separates a sketch from an unplanned project. If it
  needs more time, that is itself the answer: the idea is bigger than a day, so it needs a brief.
- **Promoting the code.** The single most expensive mistake available here. Everything the sketch
  proved is in the verdict; the files are worth less than the time it takes to clean them.
- **Skipping the verdict because the answer feels obvious.** It is obvious for about a week. The
  brief is written later, by someone with a fuzzier memory than you have right now.
