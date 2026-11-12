# ADR-0003 — The crew runs a spec on its own; the Owner designs, scopes and approves

Status: accepted 2026-11-12 (decisions 1–5). Open questions at the end are not decided.

The crew (`openrig/crew/`) is now how the Owner builds, and its rules still assume the Owner sits
inside the loop. The architect "Route[s] nothing until the Owner says go" and, after every slice,
proposes the next one "and wait[s]" (`openrig/crew/agents/architect/guidance/role.md`). A five-slice
spec is five round trips through the Owner before any question is asked, and the Owner's own Claude
session — which `openrig/crew/CULTURE.md` (*Reaching the Owner*) already has watching the architect's
pane and relaying answers — has no stated job beyond the relay. Meanwhile every seat lives across
slices, so context and tokens grow with the mandate, in the seats and in the Owner's session alike.

The premise behind the change: generating code (and generating design documents) is now cheap; what
stays scarce is the Owner's judgement — architecture and systems design, scope, product knowledge,
and specs shaped so an agent or another person executes them without asking. So the Owner's go moves
upstream to the spec, the crew runs inside it, and the Owner's attention is spent only where a spec
cannot answer.

## Decisions

1. **The Owner's go is given per spec, not per slice.** An approved spec is a *mandate*: its tracer
   slices, acceptance criteria, the files in scope and the invariants it touches. The crew runs
   every slice in it without asking, with **one checkpoint**: it pauses after the first slice so the
   Owner sees the shape of the work, then runs the rest under stop rules.
2. **The builder and QA start fresh for every slice** (`rig seat launch <seat> --fresh --stop`).
   The spec, the queue row and the commit carry everything the next slice needs. The lead keeps
   continuity across the mandate through a checkpoint file, so it too can be relaunched fresh.
3. **The Foreman — the Owner's one Claude session — reads queue state, not panes.** It uses
   `rig queue list` and `rig queue show`; seats write a fixed-shape status note on their row at every
   transition; `rig capture` is for unsticking a seat, a few lines at a time. It wakes on a row
   parked on `owner` rather than polling, answers a parked question itself when the spec, an ADR or
   the glossary already answers it (citing the line), and escalates only the rest, each with a
   recommendation. It lives one mandate, then `/handoff`.
4. **Specialists are on-demand profiles in the one builder slot.** The lead relaunches the builder
   fresh per slice; the slice may name a runtime and model (`rig seat set-runtime --model`) and a
   specialty profile file the queue row points at. The seat's `agent_ref` stays the general
   builder, nothing new goes in `rig.yaml`, and there is still exactly one writer.
5. **No Fable models anywhere in the crew,** on cost. Allowed: Opus, Sonnet and Haiku, and Codex.

## Rejected alternatives

- **Keep the go per slice (today's crew)** — rejected: it keeps the Owner as the crew's scheduler,
  which is the role this ADR moves them out of, and it costs an Owner round trip per slice.
- **Per spec with no first-slice checkpoint** — rejected: a spec with a hole runs a long way before
  the "outside the mandate" stop rule catches it. One pause buys an early look for one round trip.
- **Managed compaction instead of fresh seats** (`rig seat set-terminal-policy`) — rejected: a
  compaction summary loses detail and nobody reviews it. Anthropic's harness study reached the same
  place: "compaction isn't sufficient", state belongs in explicit artifacts
  ([Effective harnesses for long-running agents](https://anthropic.com/engineering/effective-harnesses-for-long-running-agents), 2025-11-26).
- **Long-lived builder and QA across a mandate** — rejected: context grows without bound and carries
  one slice's assumptions into the next. The cost of fresh — re-reading the spec, `AGENTS.md` and the
  files a slice touches — is bounded, and it lands on spec quality, where the Owner wants it.
- **The Foreman watching panes** (`rig capture --rig`) — rejected: the default capture is 20 history
  lines plus the whole pane per seat, five seats at a time, repeated through a mandate. It was the
  likeliest source of bloat in the Owner's session.
- **Standing specialist seats declared in `rig.yaml`** — rejected: each costs a launch and a pane
  whether the mandate needs it or not, and two declared writers put the one-writer rule on discipline
  instead of on construction. Parallel writers are also the multi-agent shape that does not work in
  practice: they "make conflicting implicit decisions"
  ([Cognition, Multi-Agents: What's Actually Working](https://cognition.com/blog/multi-agents-working), 2026-04-22).
- **Choose builder models by reputation** ("Codex for UI, Claude for UX") — rejected as a basis: the
  only public measure found disagrees for UI (Arena WebDev frontend, 2026-11-11: Opus 5.5 at 1860 and
  Sonnet 5.5 at 1814, the best GPT entry at 1781), and the leaderboard ranks single-shot pages, not
  work inside a codebase. Code is cheap enough to test it here instead (open question 2).

## Stop rules (what parks a mandate on `owner`)

A product question the spec does not answer; a one-way door or a decision needing a new ADR; an
invariant that would have to be weakened; work outside the mandate's files; auth, schema or a new
dependency, whatever the agent's confidence; a criterion still short of MET after three fix rounds on
the same failure; a gate that will not go green or a permission prompt; a seat at its token ceiling;
anything that would leave the machine. An escalation row cites the spec clause it cannot resolve,
the options with their consequences, and a recommendation; the Owner's answer goes into the spec as
a dated delta so it is never asked twice. Everything else the lead decides and records — a spec
delta or a `REVIEW-DEBT.md` entry.

## Consequences

- **Spec readiness becomes the gate that matters.** With no Owner in the loop, every gap in a spec
  ends as a stall or a silent guess. Before a mandate is issued the lead cold-reads it and lists every
  question it would have to ask; zero blocking questions is ready.
- **The lead's role, `CULTURE.md` and `rig.yaml` change** to carry decisions 1–5 and the stop rules.
  Not done by this ADR; each is its own change, gated by `scripts/check.sh`.
- **Decision 5's enforcer does not exist yet.** It is to be a `scripts/check.sh` group failing on any
  Fable model id in `openrig/crew/`, plus a line in the lead's role for live `set-runtime --model`
  calls, which no file check can see. Until the group lands, the rule is `[review-only]`.
- **Unverified mechanic:** `rig seat set-runtime` is documented for a *live* seat, so a fresh launch
  on another runtime may be launch-then-move. Check with `--plan` before writing it into the lead's
  role.
- **No baseline was measured.** The Owner chose (2026-11-12) to land the changes without a mandate
  on today's crew; the new crew's first real mandate is the first measurement. Record context usage
  per seat and in the Foreman then, so the token ceiling (open question 3) is set from a number.

## Open questions

1. **The reviewer pairing.** The crew has Codex reviewing Claude-built code. The one controlled study
   found that direction harmful — Claude drafts fell from 91.4% to 82.8% under Codex review, while
   Codex drafts rose from 71.6% to 89.7% under Claude review
   ([Xiang et al., arXiv 2607.21656](https://arxiv.org/abs/2607.21656), older models, puzzle tasks,
   the reviewer revising rather than reporting). Test: one or two mandates with a clean-context Claude
   reviewer beside the Codex one on the same commits, counting findings QA or the Owner confirms.
2. **Builder model per slice kind.** Bake-off: one UI slice built by Opus, Sonnet and Codex in
   separate worktrees, judged by QA against the same criteria.
3. **The token ceiling per seat** — the number is the Owner's, after the measurement above.
4. ~~Rename the crew's `architect` seat to `lead`.~~ Decided 2026-11-12 in ADR-0004, decision 6.
