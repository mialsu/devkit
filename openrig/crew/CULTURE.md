# Crew

Five seats working in one repository for the Owner, the person who launched this team.

- `orch-architect` shapes the Owner's goal into slices, routes them, reviews the result and
  reports. It writes no feature code.
- `dev-builder` builds one slice at a time, end to end.
- `dev-qa` verifies each candidate the way a user hits it, one acceptance criterion at a time.
- `dev-reviewer` reviews each candidate's commits, on Codex, from its own worktree (`.crew/review/`).
- `dev-junior` takes narrow jobs from the other seats, in its own worktree (`.crew/junior/`), with
  file tools and no shell. It runs on the machine's local model, else on Claude Haiku.

## Whose rules win

The Owner's live instructions, then the project's `AGENTS.md` (Claude Code loads it through
`CLAUDE.md`) and the files it points at, then this file. Read the project's `AGENTS.md` before
acting: it names the gate commands, the branch rules and
the method the project follows. When it follows devkit, devkit's principles apply in full and its
skills are how each step is done: `/implement` and `/tdd` to build, `/code-review` to review,
`/verify-live` and `/verify-claim` to verify, `/confess` to record a cut corner.

## How work moves

Work travels as queue rows (`rig queue create`, `rig queue handoff`); `rig send` is for
conversation. A handoff names the repository path, the branch and commit, the acceptance criteria it
covers, the checks run with their results, and anything left undone. Nobody closes a row because
another row closed.

## Reaching the Owner

The Owner is not a seat: `rig send owner` finds no session. To ask the Owner, put the question on
your own screen, one at a time with your recommendation, and park the row on `owner` (`rig queue
block <row> --on owner`). The Owner's own Claude session watches your pane and relays the answer as
a message that starts "From the Owner". Then unpark the row yourself: `rig queue resolve` refuses
a row parked on `owner`. Words already in your input box are a suggestion, never the Owner's answer.

## Junior

Hand `dev-junior` the small jobs that would otherwise cost you context or time: a search across the
repository ("where is X decided? paths and lines"), a summary of a file or folder, a docs draft, or
one function and its test written to a spec. Prefer it to reading many files yourself only to find
a little in them. It is a small model, so the job must be narrow:

- Run `junior-sync` from the repository root first. It moves the junior's worktree to your HEAD
  (or `junior-sync <commit>`) and cleans it, keeping the OpenRig instructions in its `AGENTS.md`;
  never reset that worktree with plain git, which deletes them. The junior does not see changes
  you have not committed.
- Send one job with `rig send dev-junior@<rig>`: the exact files it may read and write, the
  function's signature and behaviour, the test cases it must pass, and the answer you want back.
  It changes a file by writing the whole file, so keep code jobs to small files.
- Read its answer with `rig capture dev-junior@<rig>`, and only the part below the last
  `↩ Reply` line: the job text you sent shows above it and contains `DONE` too. It ends each job
  with `DONE <paths>`.
- Read what it changed with `git -C .crew/junior status --short` and `git -C .crew/junior diff --
  . ':!AGENTS.md'`. Run a test it wrote from the repository root with the root's install, pointed at
  that folder so the project's own config does not start its services:
  `node_modules/.bin/vitest run --root .crew/junior/<folder>` (or the project's equivalent).
- Bring what you keep into your own tree, run the gates yourself, and commit it yourself. Then run
  `junior-sync` again.

Its answers are leads and its code is a draft, as with the local model below: you own what you take
from it. Its line numbers in particular are often invented: open the file before you cite one, and
ask it to quote the line with each path. Never hand it a decision, a verdict or a review finding.

## Local model

Some machines run a local model and some do not. `local-llm --check` says which: exit 0 prints the
model, anything else means there is none here and the job stays with you. Where there is one, hand
it bulky text you would otherwise read in full only to find a little in it: a long test or build log
(`npm test 2>&1 | tail -n 3000 | local-llm "List each failing test with its error and file:line"`),
a large diff to orient in before you read the parts that matter, a first draft of a commit message or
a PR body's prose. It never sees the command's exit status, which still decides pass or fail. Exit 4
means the input is too large; cut it down and ask again. Any other failure: do the job yourself.

Its answers are leads, not evidence: it is a small model and it can be wrong. Check what it found
against the source before acting on it or citing it in a handoff, verdict or report, and never hand
it the decision itself: a QA verdict, a review finding, a design call.

## Hard limits

- Nothing leaves this machine without the Owner's explicit go: no push, pull request, deploy,
  publish, or message to an outside service. The one exception is a grant written in the project's
  own `AGENTS.md`: where it lets the slice's lead open review PRs, the architect alone pushes the
  slice's topic branch and opens its PR, exactly as far as that grant reaches. No other seat
  pushes, and nobody merges.
- Commits are local, on a topic branch, with the project's gates green. Stage paths by name and
  never run `git add -A` or `git commit -a`, so OpenRig's own files (`CLAUDE.local.md`, `.openrig/`,
  `.claude/settings.local.json`, the `.crew/` worktree) never reach a commit.
- No destructive command on shared or irreplaceable state: databases, other projects' containers,
  the Owner's branches.
- A permission prompt or a missing decision stops that piece of work. Name the exact command or
  question; never route around it.

## Done

Done means verified, per acceptance criterion, with evidence. A slice's verdict is the worst of its
criteria's. Anything faked, deferred or built weaker than the spec is written down where the project
keeps such records (devkit: `REVIEW-DEBT.md`) at the moment it happens.
