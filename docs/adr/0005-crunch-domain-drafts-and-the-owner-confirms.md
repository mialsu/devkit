# ADR-0005 — `/crunch-domain` drafts the rules from the Owner's decisions; the Owner confirms them

Status: accepted, 2026-11-25. Follows [ADR-0004](0004-the-skill-set-under-the-crew-model.md), whose
`/architect` decision already moved design to "the agent recommends, the Owner decides".

`/crunch-domain` was an interview: the Owner narrated the domain's timeline and stated each rule,
and the agent asked, transcribed and challenged. In its first run on sitesmith-v2 (2026-11-25) the
Owner stopped it after one question: "The domain dial needs to be more guiding than asking from now
on. This is agentic developing or ai assisted developing." The brief's edge-case tables and the ADRs
already held almost every rule; asking the Owner to say them again cost time and decided nothing
new.

The skill now drafts. The agent builds the timeline and the candidate invariants from the brief, the
ADRs and the glossary, each row citing its source, and the Owner accepts, strikes or changes each.
Where the sources are silent, the agent asks a product question with options and a recommendation.
PRINCIPLES #11 changes with it, from "the agent never supplies them" to "the agent drafts them from
what you have already decided, cites where each came from, and asks where that is silent; nothing
enters the model until you confirm it". `templates/INVARIANTS.md` rule 6 and METHOD.md follow.

Evidence from that run: eleven invariants drafted from brief §6 and ADR-0002, -0004 and -0006, all
accepted; one question the sources did not answer (what happens when a customer stops paying),
which produced the eleventh; and three glossary choices asked in the same prompt. Two of the
agent's proposed `_Avoid_` words (`contact`, `deleted`) would have failed real code under the drift
gate and were caught before writing, which is why the skill now tells the drafter to check them.

## Rejected alternatives

- **Keep the interview.** Rejected by the Owner: it re-asks what the brief already decided, and the
  Owner works by steering an agent (ADR-0004, the same reason for `/architect`).
- **Draft the whole model with no sources and let the Owner review it after.** Rejected: ADR-0004
  rejected the one-pass draft for design, because its contradictions sat between documents no
  decision had passed through. A draft that cites a decision is transcription; one that cites
  nothing is a guess, and goes to the Owner as a question.
- **Change the skill and leave PRINCIPLES #11 as it was.** Rejected: PRINCIPLES says a principle
  wins over a skill, so the change would be overruled by the first session that read both.

## Consequences

- The recite gate carries more weight. An Owner can accept a drafted table in one click without
  reading it; "can you state the top three invariants with the file closed?" is what catches that,
  so the skill keeps it as the closing check.
- A crunch on a project with no brief and no ADRs has nothing to draft from, and falls back to
  questions, one at a time.
