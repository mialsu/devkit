#!/usr/bin/env bash
set -euo pipefail

# devkit installer.
# Symlinks devkit's OWN skills into the local skill directories so a `git pull`
# in this repo keeps them up to date. Matt Pocock's skills are NOT vendored here
# (devkit references them) — install those separately as his plugin so his
# updates flow to you; see the note printed at the end.

REPO="$(cd "$(dirname "$0")" && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

link_into() {
  local dest="$1"
  if [ -L "$dest" ]; then
    local resolved; resolved="$(readlink -f "$dest")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $dest is a symlink into this repo. Remove it and re-run." >&2
        return 1 ;;
    esac
  fi
  mkdir -p "$dest"
  local n=0
  while IFS= read -r -d '' skill_md; do
    local src name; src="$(dirname "$skill_md")"; name="$(basename "$src")"
    ln -sfn "$src" "$dest/$name"
    n=$((n+1))
  done < <(find "$REPO/skills" -name SKILL.md -print0)
  echo "  linked $n devkit skills into $dest"
}

echo "Installing devkit skills from $REPO"
for d in "${DESTS[@]}"; do link_into "$d"; done

cat <<'NOTE'

Done. devkit's skills are linked:
  /product-brief  /new-project  /harness  /crunch-domain
  /verify-live  /verify-claim  /confess  /ship

Next — install Matt Pocock's skills (devkit references them, so you get his updates):

  Claude Code plugin (recommended — updates when he ships a new version):
    /plugin marketplace add mattpocock/skills
    /plugin install mattpocock-skills@mattpocock

  or, from a local clone, run HIS link script:  skills/scripts/link-skills.sh

Then, in any project:  /new-project   (picks a domain profile and scaffolds it)
Read METHOD.md for the loop, PRINCIPLES.md for the spine.
NOTE
