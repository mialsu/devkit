# crew

The Owner's four-seat OpenRig team, for any repository. Each project gets its own rig, named
`crew-<project>` after the repository folder, so two projects can run at once and their queues
never mix.

| Seat | Address | Job |
|---|---|---|
| architect | `orch-architect@crew-<project>` | shapes the goal into slices, routes them, reviews and reports; writes no feature code |
| builder | `dev-builder@crew-<project>` | builds one slice at a time, end to end |
| qa | `dev-qa@crew-<project>` | verifies each candidate the way a user hits it, per acceptance criterion |
| reviewer | `dev-reviewer@crew-<project>` | Codex: reviews each candidate's commits against the spec and the standards, alongside qa |

Each seat's role is in `agents/<seat>/guidance/role.md`, and the team rules are in `CULTURE.md`.
Both defer to the project's own `AGENTS.md`, and they name the devkit skill for each step instead
of restating the method.

## Use it

From the project's root, in a normal terminal. `crew-up` on your PATH is a link to `crew-up.sh`
in this folder.

    crew-up --plan     # what would start; starts nothing
    crew-up            # launch, or resume this project's stopped crew
    crew-up --fresh    # new seats, replacing a stopped crew
    env -u TMUX tmux attach-session -t '=orch-architect@crew-<project>'   # talk to the architect
    # leave a seat with Ctrl-b d; Ctrl-c twice quits its agent and leaves a bare shell
    rig down crew-<project>                                               # stop it

Every new launch copies this folder to `<workspace.root>/crew/<project>/` (by default under
`~/.openrig/workspace/`), sets the rig name and points the agents at the installed OpenRig, so an
edit here reaches the next launch. A resumed crew keeps the copy it started with. Two repositories
with the same folder name would share a rig name, so `crew-up` refuses the second one.

## What a launch changes in the project

OpenRig writes its runtime files into the repository: `.openrig/`, `.claude/settings.local.json`,
`.claude/skills/`, `.claude/plugins/`, and possibly `.agents/` and `.codex/`. Its instruction blocks
for the Claude seats go into `CLAUDE.local.md`. Your own Claude Code sessions in that repository
read these files too, and the settings file makes `acceptEdits` their default mode. List the paths
in the project's `.git/info/exclude`. Unlike the shipped teams, crew selects no MCP servers.

The Claude seats launch in Claude Code's auto mode (`permission_policy: builtin:auto` in
`rig.yaml`), so its classifier, not the Owner, decides routine commands. The project's `AGENTS.md`
hard limits still bind every seat. The Codex reviewer has no auto mode and launches at the floor.

## Codex's sandbox on Ubuntu 24.04 and later

At the floor the reviewer runs every command inside Codex's bubblewrap sandbox. Ubuntu 24.04 sets
`kernel.apparmor_restrict_unprivileged_userns = 1`, and with no AppArmor profile for bubblewrap the
sandbox can't start: every command fails inside it, Codex asks to run it outside, and the reviewer
stops at a prompt for each `cat`, `git show` and `rig whoami` (prep-planner, 2026-10-22). Check for
it from the reviewer's worktree. `codex sandbox` refuses `-C` and `-c` unless a
`--permission-profile` is named, so `cd` into the worktree first:

    cd .crew/review && codex sandbox -- head -1 README.md; cd -

On the broken host this prints `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`.

The fix is a profile that lets bubblewrap create user namespaces. Codex runs its own bundled
`bwrap`, not `/usr/bin/bwrap`, so the profile names both; the globs keep it matching across Node
and Codex upgrades under nvm:

    sudo tee /etc/apparmor.d/codex-bwrap >/dev/null <<'EOF'
    abi <abi/4.0>,
    include <tunables/global>

    profile codex-bwrap /{usr/bin/bwrap,home/*/.nvm/versions/node/*/lib/node_modules/@openai/codex/node_modules/@openai/codex-linux-x64/vendor/*/codex-resources/bwrap} flags=(unconfined) {
      userns,
    }
    EOF
    sudo apparmor_parser -r /etc/apparmor.d/codex-bwrap

It survives a reboot. A Codex installed outside nvm keeps its `bwrap` under another path; find it
with `find "$(npm root -g)/@openai" -name bwrap` and add it to the profile. A reviewer launched
before the fix keeps asking until it is relaunched, which is also the proof that the fix took:

    rig seat launch dev-reviewer@crew-<project> --fresh --stop --reason "Codex sandbox fixed"

The alternative is no sandbox: `rig seat set-permissions dev-reviewer@crew-<project> --mode
full_bypass --reason "<why>"` (plus `--operator` from a human shell) launches it with
`danger-full-access`, and then only `AGENTS.md`'s prose limits it. Prefer the profile.

## Review PRs

When a slice's QA verdicts and review are in, the architect writes its report as a PR body in
`/pr`'s shape (Summary visual, Evidence, Merge Danger) at `.crew/pr/<branch>.md`. It opens the PR
itself only where the project's `AGENTS.md` carries a standing grant for review PRs; nobody in the
crew merges. A grant reads like prep-planner's:

    **Standing grant (Owner, <date>) — review PRs:** an agent leading a slice (the crew's architect)
    may push that slice's own topic branch and open its pull request against `main` once the slice's
    QA verdicts and code review are in, with the body in `/pr`'s shape. Nothing else leaves under
    this grant: never push `main` or another branch, never force-push, never merge, close or approve
    a PR. Merging is the Owner's keystroke.

The Codex reviewer is the exception. OpenRig always writes a Codex seat's blocks into `AGENTS.md`
(`managed_blocks` takes only a `claude-code` key), and `AGENTS.md` is tracked. So `crew-up` gives the
reviewer its own worktree, `.crew/review/`, created detached at the project's `HEAD` on first launch
and listed in `.git/info/exclude` by `crew-up` itself; the blocks land in that copy, which nobody
commits from. `crew-up` also writes every seat's `cwd` as an absolute path into its copy of
`rig.yaml`, because `rig up --cwd` would override the reviewer's along with the rest.

## Local model

On a machine with a GPU, the seats hand bulky text jobs (long logs, large diffs, first drafts) to a
local Ollama model through `bin/local-llm`, and read its short answer instead of the whole input.
`CULTURE.md` says when. The crew is the same everywhere; only the machine decides. On every machine:

    ln -s ~/personal/devkit/openrig/crew/bin/local-llm ~/.local/bin/local-llm

and only on one with a local model:

    mkdir -p ~/.config/crew && echo gemma4:12b > ~/.config/crew/local-model
    ollama pull gemma4:12b    # needs Ollama 0.40 or later; 0.32 segfaults loading it

Without that file, `local-llm --check` exits 3 and the seats do every job themselves; `crew-up`
says which case it found. The context window is 32768 tokens, sent with each request, so Ollama's
own default needs no change; set `CREW_LOCAL_CTX` higher if the GPU has room.

## Change it

Edit a role, the culture or an agent's skills here, then check before the next launch:

    rig agent validate agents/<seat>/agent.yaml
    rig spec validate rig.yaml
    crew-up --plan

A new seat is a new folder under `agents/` plus a member in `rig.yaml`. Every running seat is a
Claude session, so one crew is three sessions on top of the kernel's three.
