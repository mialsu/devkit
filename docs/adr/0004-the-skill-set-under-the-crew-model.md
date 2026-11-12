# ADR-0004 — The skill set under the crew model: retired, reshaped and added

Status: in progress, started 2026-11-12. Decisions are added as the Owner makes them; nothing below
is implemented yet. Follows [ADR-0003](0003-the-crew-runs-a-spec-the-owner-designs.md).

ADR-0003 moved the Owner upstream (design, scope, specs) and the crew downstream (a mandate run
without the Owner). The skill set was planned before that, and several skills have not run since.
Evidence for each decision below: the artifacts each skill leaves in the three active projects
(prep-planner, sitesmith, student-attendance-tracker), commit messages naming it, and Claude Code
transcripts on this machine — which reach back only to 2026-10-29, so a skill that leaves no file
behind (`/verify-claim`, `/pickup`, `/sketch`) is undercounted.

## Decisions

1. **`/cycle-plan`, `/cycle-groom` and `/cycle-close` are removed, and the cadence dial with them.**
   Evidence: no `CADENCE.md` in any project, no mention in any project's docs or commits, and one
   commit each (2026-09-18) since they were written. `/cycle-groom`'s readiness ladder — `stub`
   (needs a done-when and its blockers) → `scoped` (needs acceptance criteria, each naming how it
   will be proven) → `ready` (no open question that changes what gets built) — moves into the
   spec-readiness check ADR-0003 requires before a spec becomes a mandate. The ladder is the one
   piece the crew model needs; planning and closing a cycle are not.
2. **`/ship` is removed.** The Owner has never run it: every project that publishes deploys from
   CI on merge, and merging is always the Owner's keystroke (ADR-0003). The gate `/ship` was meant
   to be already exists — it is the merge. Its pre-flight half (gates green, every criterion
   verified, `REVIEW-DEBT.md` current) is the crew's definition of done. Its post-release half —
   exercise the released build, not localhost — stays with the Owner, by hand, as each profile's
   checklist.
3. **`/spike` is removed.** devkit is the Owner's personal toolkit, and `/spike` was the one skill
   built for somewhere else: an employer's monorepo, where devkit's files never load (ADR-0002,
   *Consequences*). It never ran — there is no `~/.claude/spikes/`. This partly supersedes ADR-0002:
   the Light lane keeps one door, `/sketch`.
4. **Confessions are dispositioned per mandate, and the ledger is kept compact.** Evidence: the
   writing half works and the disposition half does not. prep-planner holds 48 entries, 42 `open`
   (12,471 words, 19 Oct – 11 Nov); sitesmith 75, 52 `open` (15,682 words, 28 Sep – 2 Nov). 94
   decisions wait on the Owner, one entry at a time, mid-build, with no moment in the loop that asks
   for them. Under ADR-0003 that also costs tokens: the ledger is "read first by any architecture or
   review session", and fresh seats per slice re-read 12–16k words of mostly undecided entries.
   - **At mandate close** the Foreman shows the Owner that mandate's new entries only, each with a
     recommended disposition (fixed / accepted-with-reason / promoted-to-issue), confirmed in one
     pass.
   - **Two layers:** an index of open and accepted entries at the top — one line each, date, title,
     disposition — and the full entries below. Seats read the index and open an entry only when the
     slice touches its files.
   - **Fixed and promoted entries leave the file**; git history keeps them. **Accepted** entries
     stay, because they describe a limit the code still has (a `CEILING:` among them).
   - **One cleanup of the current backlog:** the Foreman pre-sorts each project's open entries with
     a recommended disposition, and the Owner approves in bulk, pulling out any to decide alone.
   - `/confess`'s writing half is unchanged.
5. **A new devkit skill, `/mandate`, runs a mandate's whole life in the Foreman's session:**
   - **Issue.** The readiness check. A fresh subagent — cold by construction, given only the spec
     and the repo's docs — lists every question it would have to ask; the Foreman places them on
     `/cycle-groom`'s ladder (decision 1); the Owner answers the blocking ones into the spec. At zero
     blocking questions the Foreman writes the working agreement — boundary, token ceiling, ADR-0003's
     stop rules — into the queue row that hands the mandate to the lead.
   - **Watch.** Wake on a row parked on `owner`, never poll. Classify it with OpenRig's
     `human-in-the-loop` (auto-continue / human gate / park). Answer it from the spec, an ADR or the
     glossary with the line cited, where they answer it; escalate the rest with a recommendation.
   - **Close.** Disposition that mandate's confessions in one pass (decision 4), summarise for the
     Owner in a few lines, then `/handoff`.

   Gaps are found while the Owner is present to answer them, and one word names one thing from start
   to end. devkit supplies the rules; OpenRig supplies the mechanics. Its `human-in-the-loop`,
   `openrig-software-factory` (the working agreement: "the work boundary, time/spend limit, who
   answers unresolved choices, and when to stop") and `messaging-the-human` already ship, and
   `/mandate` points at them instead of restating them.
6. **A new devkit skill, `/architect`, is the Owner's design step, and the crew's `architect` seat
   is renamed `lead`.** The Owner does not write the design; the Owner guides it and decides. The
   agent drafts. What keeps an agent-drafted design from becoming the pseudo-artifact is that every
   load-bearing choice passes through the Owner as a decision, and every design carries predictions
   a build can falsify:
   - **Two entry points.** A *broad* idea starts at scope: the smallest thing worth building and the
     few decisions that would be expensive to reverse at 100x (ANTI-PATTERNS, *Designing for the scale
     you don't have*). A *narrow* idea starts from the existing `docs/architecture.md`: which parts it
     touches, and whether it opens a one-way door.
   - **Decision by decision.** The agent puts one load-bearing choice at a time to the Owner, with
     options, trade-offs and a recommendation; the Owner picks. Each pick becomes an ADR with its
     rejected alternatives and two or three predictions ("this breaks when ___").
   - **A cold critic.** A fresh subagent given only the written design hunts contradictions between
     its parts — the check that found the episode/epoch conflict and the draft-revision hole in the
     Owner's adaptive-training pack, which was drafted in one pass with no decision put to the Owner.
   - **A build tests the predictions** — a `/sketch`, or a mandate whose deliverable is a verdict.
     The ADR records under its predictions which held and what the build exposed that nobody
     predicted. Read back over months, the ADRs are the Owner's design record; no new artifact.

## Rejected alternatives

- **Keep the cycle skills with the dial off** — rejected: ADR-0002's argument in reverse. A dial
  nothing turns on is prose, and three unused skill descriptions load into every session and every
  fresh seat launch.
- **Keep `/cycle-groom` as the readiness check** — rejected: its unit is a cycle's pool, and its
  output feeds `/cycle-plan`. The crew's unit is one spec; the ladder transplants, the skill does not.
- **Keep `/ship` as the publish gate** — rejected: a gate nobody passes through guards nothing, and
  the real one-way door (merge, which deploys) is already the Owner's alone.
- **Have the crew run the post-release check** — not now. The Owner tests production by hand. The
  cheapest piece to automate later is the version match (the served build's version against the
  merged commit), which needs no login; it stays manual until the Owner asks for it.
- **Keep `/spike` for personal repos** — rejected: in the Owner's own repos a feasibility question
  is a throwaway branch, which the crew can run as a mandate whose deliverable is a verdict, or a
  `/sketch` when the question is whether the thing is worth building at all. What made `/spike`
  its own skill was the foreign repo, and that case is out of scope.
- **Disposition each confession as it is written** (today's rule) — rejected by its own record:
  69–88% of entries are still `open`. A decision asked for mid-build, one at a time, is not made.
- **Move every confession to the issue tracker** — rejected: most entries are a limit the code
  keeps on purpose, not work to schedule. Promotion stays one of the three dispositions.
- **Cap the ledger and make an over-cap ledger a stop rule** — not now. If per-mandate disposition
  holds the open count down, a cap is unneeded; revisit if it does not.
- **The readiness check as a step in the lead's role** — rejected: the crew would find the gaps with
  no Owner present to answer them, so each becomes a stall at the start of the mandate.
- **Fold the readiness check into `/to-spec`** — rejected: that skill is Pocock's, and changing it
  is a fork that stops receiving his updates (METHOD.md, *Reuse before building — the docs too*).
- **A crew seat as the cold reader** — rejected: a seat is fresh too, but costs a launch; a
  subagent is cold by construction and ends with its answer.
- **A separate skill for watching a running mandate** — rejected: it splits one lifecycle across two
  names, and the Foreman lives one mandate anyway (ADR-0003).
- **Write devkit's own escalation classes and wait protocol** — rejected: OpenRig ships both, and a
  second version is *two formats for one artifact*.
- **The Owner writes the design, the agent critiques** — rejected by the Owner: ideas arrive broad or
  narrow, and the Owner works by guiding an agent through design and product questions. The skill
  fits how the work is done; the decisions, the predictions and the build carry the understanding.
- **Design katas separate from real projects** — rejected: practice on real decisions with a real
  build to score them is cheaper and teaches the same thing. A kata remains possible as a `/sketch`.
- **Let the agent draft the whole design in one pass and review it after** — rejected: that is how
  the adaptive-training pack was made, and its contradictions sat between documents no decision had
  passed through.
- **Name the skill something else and keep the seat `architect`** — rejected: "architect" is the
  Owner's job under ADR-0003, and the seat's own role file already calls it "the crew's lead".

## Consequences

- One commit removes `skills/cycle-plan`, `skills/cycle-groom`, `skills/cycle-close` and
  `templates/CADENCE.md`, and edits `README.md`, `install.sh`, `METHOD.md` (the skill list, the
  reuse-table rows for `CADENCE.md` and the cycle record, and *The cadence dial* section) and
  `REVIEW-DEBT.md` — all files that name them today.
- The skills stay in git history; restoring them is a revert, if dates from outside ever arrive.
- Removing `/ship` touches `skills/ship`, `README.md`, `install.sh`, `METHOD.md` (the chain's
  step 11 and the bootstrap paragraph), `CODING_STANDARDS.md` (the `disable-model-invocation`
  list), `skills/audit/SKILL.md` ("a `/ship`-class act" becomes "an Owner-only act"), and the five
  profiles' "for `/ship`" lines, reworded to "after release, by hand". ADR-0002 keeps its mention;
  ADRs are history.
- Outside devkit, `~/code/personal/CLAUDE.md` names `/ship` twice: in the hard limit ("a
  deliberate keystroke (`/ship`)", which becomes the Owner's merge or an explicit go — the rule is
  unchanged, only its name) and in the list of the loop's commands.
- Removing `/spike` touches `skills/spike`, `README.md`, `install.sh`, `METHOD.md` (its paragraph
  in the supporting skills, its reuse-table row, and the Light lane's "two doors" line),
  `CODING_STANDARDS.md` (the `disable-model-invocation` list), and `skills/sketch/SKILL.md`, whose
  opening contrasts itself with `/spike`. `/sketch` also loses the "neither lands on a shared branch"
  pairing in `METHOD.md`; the rule it states still holds for `/sketch` alone.
- Decision 4 touches `templates/REVIEW-DEBT.md` (the index and the leave-the-file rule),
  `skills/confess/SKILL.md` (disposition at mandate close), `templates/AGENTS.md` ("Read it before
  trusting the repo" becomes "read its index"), and the crew's roles and `CULTURE.md` (the Foreman's
  close-of-mandate pass). The drift gate is unaffected: it only requires the ledger to change in the
  same commit as a new suppression or `CEILING:` (`templates/scripts/drift-check.sh:303`, `:510`),
  and removing a fixed entry does not trip it.
- The backlog cleanup is per project, in that project's repo, not in devkit.
- **Risk to check during the crew changes:** OpenRig's `mission-slice-sop` is a delivery loop of its
  own (intent → mini-requirements + proof contract → build → QA → proof), and the crew runs devkit's.
  If seats load both, that is two formats for one artifact; the crew's roles must say which wins.
