# crew

The Owner's three-seat OpenRig team, for any repository. Each project gets its own rig, named
`crew-<project>` after the repository folder, so two projects can run at once and their queues
never mix.

| Seat | Address | Job |
|---|---|---|
| architect | `orch-architect@crew-<project>` | shapes the goal into slices, routes them, reviews and reports; writes no feature code |
| builder | `dev-builder@crew-<project>` | builds one slice at a time, end to end |
| qa | `dev-qa@crew-<project>` | verifies each candidate the way a user hits it, per acceptance criterion |

Each seat's role is in `agents/<seat>/guidance/role.md`, and the team rules are in `CULTURE.md`.
Both defer to the project's own `CLAUDE.md`, and they name the devkit skill for each step instead
of restating the method.

## Use it

From the project's root, in a normal terminal. `crew-up` on your PATH is a link to `crew-up.sh`
in this folder.

    crew-up --plan     # what would start; starts nothing
    crew-up            # launch, or resume this project's stopped crew
    crew-up --fresh    # new seats, replacing a stopped crew
    env -u TMUX tmux attach-session -t '=orch-architect@crew-<project>'   # talk to the architect
    rig down crew-<project>                                               # stop it

Every new launch copies this folder to `<workspace.root>/crew/<project>/` (by default under
`~/.openrig/workspace/`), sets the rig name and points the agents at the installed OpenRig, so an
edit here reaches the next launch. A resumed crew keeps the copy it started with. Two repositories
with the same folder name would share a rig name, so `crew-up` refuses the second one.

## What a launch changes in the project

OpenRig writes its runtime files into the repository: `.openrig/`, `.claude/settings.local.json`,
`.claude/skills/`, `.claude/plugins/`, and possibly `.agents/` and `.codex/`. Its instruction blocks
go into `CLAUDE.local.md`. Your own Claude Code sessions in that repository read these files too,
and the settings file makes `acceptEdits` their default mode. List the paths in the project's
`.git/info/exclude`. Unlike the shipped teams, crew selects no MCP servers.

## Change it

Edit a role, the culture or an agent's skills here, then check before the next launch:

    rig agent validate agents/<seat>/agent.yaml
    rig spec validate rig.yaml
    crew-up --plan

A new seat is a new folder under `agents/` plus a member in `rig.yaml`. Every running seat is a
Claude session, so one crew is three sessions on top of the kernel's three.
