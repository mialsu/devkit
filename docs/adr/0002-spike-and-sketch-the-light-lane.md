# ADR-0002 — The Light lane gets two doors: `/spike` and `/sketch`

`METHOD.md`'s weight dial has always sold Light as "a script, a spike, a prototype" running steps
1 → 3 → 5, and nothing ever invoked it. Every entry point devkit shipped was heavyweight and
once-per-project: `/product-brief` refuses tech, `/new-project` delegates to `/harness`, which
proves every gate by breaking it. So the fast path existed as a table row and as nothing else, and
the honest description of what happened instead was "skip the method".

Two questions turned out to have no home, and they are not the same question:

- **Could this work here at all** — against an existing codebase, mine or an employer's, mature or
  not. `/verify-claim` answers *does it work today* and is read-only by design. `/prototype` (mp)
  answers *does this design feel right*: every trigger in its `LOGIC.md` and `UI.md` is a design or
  ergonomics question. Feasibility was in neither.
- **Is there anything here worth building** — before a brief, a repo, or a stack exists.

`skills/spike/SKILL.md` and `skills/sketch/SKILL.md` are those two doors.

## Rejected alternatives

- **One skill forking on host (existing repo vs fresh)** — the first shape considered, and wrong.
  The fork is real but shallow: `/prototype`'s `UI.md` already forks on it (sub-shape A on an
  existing page, "preferred"; sub-shape B a new route, "last resort"). What actually differs between
  the two cases is the first hour's work, what may be touched, and what the output is — a verdict
  for a ticket versus a demo that decides whether a product exists. That is two skills.
- **Two skills split on enterprise vs personal** — rejected once the real axis appeared. A mature
  personal project has the same problem as a work monorepo: a large codebase whose conventions
  constrain the probe. The employer-specific parts (can a dependency be added, is CI mine, who owns
  this module) are a constraint probe inside one skill, not a second skill.
- **Extend `/prototype` (mp)** — rejected twice over. Its format is Pocock's, so forking it forfeits
  his updates and commits *two formats for one artifact*; and its scope is design questions, which
  is a third thing distinct from both feasibility and product. `/spike` delegates to it instead, for
  the case where a feasibility question turns out to be a design question wearing a coat.
- **Fold the product question into `/product-brief`** — rejected: the brief deliberately refuses
  tech at that altitude, and it already demands "the cheapest test that could falsify" the riskiest
  assumption while having no tool that builds a whole app in a day. `/sketch` serves the brief
  rather than replacing it, and can be called from either side of it.
- **Fold feasibility into `/verify-claim`** — rejected: adjacent, not identical. That skill's whole
  value is that it reads committed code and never writes any; a spike writes throwaway code on a
  branch. Merging them would make the read-only guarantee conditional, which is the guarantee.
- **No new skills; just tell the Owner to run Light** — rejected as the status quo that produced
  this ADR. A dial with no door is prose, which is the *standard with no enforcer* anti-pattern
  aimed at the method itself.

## Consequences

- **`/spike` is the first devkit skill that runs outside devkit's tree.** `install.sh` links skills
  into `~/.claude/skills`, so it is invocable in a work monorepo — where `PRINCIPLES.md` and
  `METHOD.md` never load. It therefore restates its five load-bearing rules inline and cites no
  devkit file a caller might not have. Any future skill meant for use at work inherits this
  constraint.
- **Spike reports live at `~/.claude/spikes/<repo>/YYYY-MM-DD-<slug>.md`** — the handoff directory
  convention, with a different derivation. `/resume` derives its slug from the projects root that
  imports devkit; a work repo has none, so `/spike` uses the basename of the git root. Same reason
  for avoiding the OS temp directory: most Linux boxes empty it on boot. Outside the repo because a
  spike in an employer's codebase leaves no files behind, and because the report must survive
  `git checkout main`.
- **Both set `disable-model-invocation: true`.** They write code into repos — one of them possibly
  an employer's — so the model must not start either on its own. That extends the rule
  `CODING_STANDARDS.md` already applies to `/new-project`, `/harness`, `/crunch-domain` and `/ship`.
- **PRINCIPLES #2 is scoped, never waived.** A spike or a sketch never lands on a shared branch, so
  "gates before every commit" has nothing to gate. Both skills say this in those words, and both say
  that the moment any of it lands the rule applies in full and the code is rewritten rather than
  promoted. A method that scales down by carving out exemptions is a method with holes; this one
  scales down by moving work out of scope.
- **`METHOD.md`'s supporting-skill count moves from eight to nine.** That number is prose, so
  `scripts/check.sh` cannot catch it going stale — noted here because the next skill added will hit
  the same edge.
