#!/usr/bin/env bash
# crew-up.sh: launch, resume or preview the crew team for one project.
#
#   crew-up               launch in the current repository, or resume its stopped crew
#   crew-up --plan        show what would start; starts nothing
#   crew-up --fresh       start new seats even when a stopped crew exists
#   crew-up [opts] DIR    use DIR instead of the current directory
#
# Each project gets its own rig, crew-<folder name>, so two projects can run at once and their
# queues never mix. A new launch copies this folder to <workspace.root>/crew/<project>/, sets the
# rig name and points the agents at the installed OpenRig. A resume uses the copy it started with.
set -euo pipefail

usage() { sed -n '2,11p' "$(readlink -f "${BASH_SOURCE[0]}")" | sed -E 's/^# ?//'; }

plan=0
fresh=0
target=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --plan) plan=1 ;;
    --fresh) fresh=1 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "crew-up: unknown option: $1" >&2; usage >&2; exit 2 ;;
    *)
      [ -z "$target" ] || { echo "crew-up: give at most one directory" >&2; exit 2; }
      target="$1" ;;
  esac
  shift
done

# Inside a Claude Code session, a daemon or tmux server started from here would hand that
# session's variables (CLAUDECODE, its session id and messaging socket, GIT_EDITOR=true) to every
# seat. Drop them for this process and everything it starts.
if [ "${CLAUDECODE:-}" = "1" ]; then
  while IFS= read -r var; do
    unset "$var"
  done < <(compgen -e | grep -E '^(CLAUDECODE|CLAUDE_CODE_[A-Z_]+|CLAUDE_EFFORT|CLAUDE_PID|AI_AGENT|COREPACK_ENABLE_AUTO_PIN|NoDefaultCurrentDirectoryInExePath)$')
  if [ "${GIT_EDITOR:-}" = "true" ]; then unset GIT_EDITOR; fi
fi

command -v rig >/dev/null 2>&1 || { echo "crew-up: rig is not on PATH" >&2; exit 1; }

start="${target:-$PWD}"
[ -d "$start" ] || { echo "crew-up: not a directory: $start" >&2; exit 2; }
root="$(git -C "$start" rev-parse --show-toplevel 2>/dev/null || (cd "$start" && pwd -P))"

slug="$(basename "$root" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//' | cut -c1-40 | sed -E 's/-+$//')"
[ -n "$slug" ] || { echo "crew-up: cannot derive a rig name from $root" >&2; exit 2; }
name="crew-$slug"

workspace="$(rig config get workspace.root 2>/dev/null || true)"
workspace="${workspace:-$HOME/.openrig/workspace}"
instance="$workspace/crew/$slug"
marker="$instance/.project-root"

if [ -f "$marker" ] && [ "$(cat "$marker")" != "$root" ]; then
  echo "crew-up: the rig name $name already belongs to $(cat "$marker")." >&2
  echo "crew-up: rename one of the two folders so each project gets its own crew." >&2
  exit 1
fi

# Exit 0 when `rig ps [filter] --json` lists a rig called $name.
listed() {
  rig ps "$@" --json 2>/dev/null | node -e '
    let s = "";
    process.stdin.on("data", (d) => { s += d; }).on("end", () => {
      let rows = [];
      try { const d = JSON.parse(s); rows = Array.isArray(d) ? d : (d.entries || d.rigs || []); } catch (e) { rows = []; }
      process.exit(rows.some((r) => r.name === process.argv[1]) ? 0 : 1);
    });' "$name"
}

next_steps() {
  echo
  if model="$(local-llm --check 2>/dev/null)"; then
    echo "Local model for bulky text jobs: $model"
  else
    echo "No local model on this machine; the seats do every job themselves."
  fi
  if ! command -v junior-sync >/dev/null 2>&1; then
    echo "junior-sync is not on PATH, so the seats cannot reset the junior's worktree; see README.md."
  fi
  echo
  echo "Talk to the architect, in a new terminal:"
  echo "  env -u TMUX tmux attach-session -t '=orch-architect@$name'"
  echo "Send it a goal from here:"
  echo "  rig send orch-architect@$name '<outcome, boundary, how to check>'"
  echo "Stop this crew:"
  echo "  rig down $name"
}

plan_flag=()
if [ "$plan" -eq 1 ]; then plan_flag=(--plan); fi
status=0

# `rig ps --json` lists stopped rigs too (its text view hides them), so ask for running ones.
if listed --filter status=running; then
  echo "$name is already running for $root."
  rig ps --nodes --rig "$name" || true
  next_steps
  exit 0
fi

if [ "$fresh" -eq 0 ] && listed --filter status=stopped; then
  echo "Resuming the stopped $name; its seats keep their conversations. Use --fresh for new seats."
  rig up "$name" --existing "${plan_flag[@]}" || status=$?
  if [ "$plan" -eq 0 ]; then rig ps --nodes --rig "$name" || true; next_steps; fi
  exit "$status"
fi

template="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
openrig="$(dirname "$(dirname "$(readlink -f "$(command -v rig)")")")"
shared="$openrig/daemon/specs/agents/shared"
[ -f "$shared/agent.yaml" ] || { echo "crew-up: OpenRig's shared agents are not at $shared" >&2; exit 1; }

# The Codex reviewer gets its own worktree: OpenRig writes a Codex seat's blocks into AGENTS.md,
# which the project tracks, and only a copy nobody commits from can take them.
git -C "$root" rev-parse --git-dir >/dev/null 2>&1 \
  || { echo "crew-up: $root is not a git repository; the reviewer needs a worktree of one" >&2; exit 1; }
review="$root/.crew/review"
# The junior gets one too, so a small model's writes land where only the seat that sent the job
# reads them, and never in the tree another seat is building in.
junior="$root/.crew/junior"
exclude="$(git -C "$root" rev-parse --path-format=absolute --git-path info/exclude)"
for tree in "$review" "$junior"; do
  [ -e "$tree" ] && continue
  if [ "$plan" -eq 1 ]; then
    echo "crew-up: would create the worktree $tree (detached at HEAD)"
  else
    grep -qxF '.crew/' "$exclude" 2>/dev/null || printf '%s\n' '.crew/' >> "$exclude"
    git -C "$root" worktree add --quiet --detach "$tree" HEAD
  fi
done

rm -rf -- "$instance"
mkdir -p -- "$instance"
cp -R -- "$template/rig.yaml" "$template/CULTURE.md" "$template/agents" "$instance/"
printf '%s\n' "$root" > "$marker"
sed -i -E "s/^name: crew\$/name: $name/" "$instance/rig.yaml"
# Absolute cwds instead of `rig up --cwd`, which would move the reviewer into the shared tree too.
sed -i -E "s#^( *cwd: )\"\\.\"\$#\\1\"$root\"#; s#^( *cwd: )\"\\.crew/review\"\$#\\1\"$review\"#; s#^( *cwd: )\"\\.crew/junior\"\$#\\1\"$junior\"#" "$instance/rig.yaml"
find "$instance/agents" -name agent.yaml -exec \
  sed -i -E "s#ref: path:[^[:space:]]*/@openrig/cli/daemon/specs/agents/shared\$#ref: path:$shared#" {} +

# The junior runs on Pi with the local model where this machine has one and Pi is installed, and on
# Claude Code with Haiku everywhere else. Both forms have file tools only and no shell: Pi through
# the settings and worktree gate written into its agent directory here (OpenRig writes none),
# Haiku through its Claude settings fragment.
if local_model="$(local-llm --check 2>/dev/null)" && command -v pi >/dev/null 2>&1; then
  junior_form="Pi on $local_model"
  sed -i -E "s#^( *model: )ollama/local\$#\\1ollama/$local_model#" "$instance/rig.yaml"
  pi_agent="${OPENRIG_HOME:-$HOME/.openrig}/state/pi/dev-junior@$name/agent"
  if [ "$plan" -eq 0 ]; then
    mkdir -p -- "$pi_agent/extensions"
    for f in settings.json models.json; do
      sed "s#__CREW_LOCAL_MODEL__#$local_model#g" "$template/agents/junior/pi/$f" > "$pi_agent/$f"
    done
    sed "s#__CREW_JUNIOR_ROOT__#$junior#" "$template/agents/junior/pi/extensions/worktree-only.ts" \
      > "$pi_agent/extensions/worktree-only.ts"
  fi
else
  junior_form="Claude Code on claude-haiku-5-5 (no local model or no pi here)"
  sed -i -E "s#^( *runtime: )pi\$#\\1claude-code#; s#^( *model: )ollama/local\$#\\1claude-haiku-5-5#" "$instance/rig.yaml"
fi
echo "Junior: $junior_form"
if ! out="$(rig spec validate "$instance/rig.yaml" 2>&1)"; then
  printf '%s\n' "$out" >&2
  exit 1
fi

echo "$name for $root"
rig up "$instance/rig.yaml" "${plan_flag[@]}" || status=$?
if [ "$plan" -eq 0 ]; then rig ps --nodes --rig "$name" || true; next_steps; fi
exit "$status"
