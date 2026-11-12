---
name: architect
description: Design a system or a change with the Owner — the agent drafts, the Owner decides each load-bearing choice from options with a recommendation, every decision becomes an ADR with its rejected alternatives and predictions a build can falsify, and a cold critic hunts contradictions before anything is built. Use when the user says "architect", "design this", "how should this be built", "system design", or has an idea (broad or narrow) that needs a shape before a spec.
disable-model-invocation: true
argument-hint: "[the idea, or the feature]"
---

The Owner's job under the crew model is design, scope and product judgement (ADR-0003 in devkit).
The Owner does not write the design: they guide it and decide, and the agent drafts. That division
has one known failure, and this skill is built around it. A design an agent drafts in one pass reads
fluently and contradicts itself between documents — nobody decided the parts, so nobody noticed that
they disagree. The cure is not more review afterwards; it is that **every load-bearing choice passes
through the Owner as a decision**, and **every decision carries a prediction a build can falsify**.

The output is ADRs and `docs/architecture.md`, in the formats they already have. No new artifact.

## 1. Which door: broad or narrow

- **Broad** — a new product or system. Start from `PRODUCT-BRIEF.md` if one exists; if the idea has
  no brief and the scope is unclear, stop and recommend `/product-brief` first — a design for an
  unscoped product is a design for the wrong thing. Run this *before* `/new-project` for the
  decisions bootstrap needs (stack, hosting, the data store), writing the ADRs into the project
  folder beside the brief; `/new-project` reads them. Continue after bootstrap for the rest.
- **Narrow** — a feature or change in a system that exists. Read `docs/architecture.md`,
  `docs/adr/`, `INVARIANTS.md` and the code the change touches first, and **trace the real flow end
  to end** before proposing anything (PRINCIPLES #3). The question is which parts it touches, and
  whether it opens a one-way door. Most narrow changes need no ADR at all — say so and stop.

## 2. Find the decisions that matter — usually two or three
Ask of each candidate: **would this be expensive to reverse at 100x** (ANTI-PATTERNS, *Designing for
the scale you don't have*)? The ones that are earn a decision. Everything else takes the cheap,
reversible option and is not discussed. List the decisions to the Owner before working any of them,
in the order they constrain each other, and let the Owner cut or add.

A design that discusses caching, queues and event buses for a product with one user has skipped
this step.

## 3. Decision by decision — one per message
For each decision, in order:
- **The forces**: what the brief, the invariants and the earlier decisions require of it.
- **Two to four options**, each with what it costs now, what it costs to reverse, and what it makes
  hard later. Ground each claim in the repo, the brief or a cited source — never in "best practice".
- **Your recommendation** and why, in one or two sentences.

The Owner picks, adjusts or sends you back. The pick is theirs; never fill a gap with your own
choice (PRINCIPLES #8). An area the Owner waves through goes into the ADR as an open question, not a
silent default.

## 4. Write the ADR at the moment of decision
`docs/adr/NNNN-slug.md` in the installed `domain-modeling` format, plus devkit's two additions:
- **Rejected alternatives** — mandatory (PRINCIPLES #7): each option not taken, and why.
- **Predictions** — two or three, each falsifiable: "this breaks when ___", "the first change that
  will hurt is ___", "if ___ then we will see ___". A prediction nobody can check is a sentiment.
  Leave a line under them for the outcome.

When decisions add up to a shape — what runs where, and the flows that cross components — draw it in
`docs/architecture.md`, with the caption contract (METHOD.md, *Diagrams*).

## 5. The cold critic
Spawn a fresh subagent with only the written ADRs, `docs/architecture.md`, the brief and the
invariants — none of this conversation. Ask it to find:
- two parts of the design that contradict each other
- a state, a race or a failure path the design does not say what happens in
- a decision that rests on an assumption no document states

Bring each finding to the Owner as a decision, the same way as step 3. A finding the Owner accepts
as a known limit goes into the ADR's consequences, named.

## 6. Test the predictions with a build
Code is cheap; a design checked only by reading is checked by opinion. For a prediction that matters,
propose the cheapest build that could prove it wrong:
- **before a repo exists**: a `/sketch`
- **in a repo**: a mandate whose deliverable is a verdict, not a feature — a throwaway branch that
  exercises the predicted failure (`/mandate`)

When the result is in, write under each prediction whether it held, and what the build exposed
that nobody predicted. Read back over months, those lines are the Owner's design record.

## What this skill does not do
- **Scope the product.** That is `/product-brief`; this designs what the brief has scoped.
- **Model the domain.** The words and the rules are `/crunch-domain`'s; this designs around them.
- **Design the surface.** Screens, states and accessibility are `/design-brief`'s.
- **Write the spec.** That is `/grill-with-docs` → `/to-spec`, once the design holds.
- **Decide.** It drafts, recommends and critiques. The Owner decides every load-bearing choice.
