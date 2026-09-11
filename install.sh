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

# The attribution hard rule needs an enforcer, not just a paragraph. Both CLAUDE.md files say
# the Owner is the sole author of record -- no Co-Authored-By trailer, no "Generated with" line --
# but the agent harness injects exactly that unless `includeCoAuthoredBy` is false, and it
# DEFAULTS TO TRUE. A rule that loses to a default every session is the "standard with no
# enforcer" anti-pattern, and it cost 15 commits on one project before anyone noticed.
#
# User level rather than per-project, deliberately: this is a property of the machine's harness,
# and a copy in every repo's .claude/settings.json would be one rule kept in N places.
set_no_attribution() {
  local settings="$HOME/.claude/settings.json"
  if ! command -v python3 >/dev/null 2>&1; then
    echo "  warn: no python3; set \"includeCoAuthoredBy\": false in $settings by hand" >&2
    return 0
  fi
  mkdir -p "$(dirname "$settings")"
  [ -s "$settings" ] || echo '{}' > "$settings"
  python3 - "$settings" <<'PY'
import json, pathlib, sys

path = pathlib.Path(sys.argv[1])
try:
    settings = json.loads(path.read_text() or "{}")
except json.JSONDecodeError as exc:
    sys.exit(f"  warn: {path} is not valid JSON ({exc}); left untouched")

if settings.get("includeCoAuthoredBy") is False:
    print("  includeCoAuthoredBy already false")
else:
    # Key order is preserved, so the rest of the file reads as its author left it.
    settings["includeCoAuthoredBy"] = False
    path.write_text(json.dumps(settings, indent=2) + "\n")
    print("  set includeCoAuthoredBy=false -- no Claude attribution in commits or PRs")
PY
}

echo "Installing devkit skills from $REPO"
for d in "${DESTS[@]}"; do link_into "$d"; done

echo "Enforcing the attribution rule"
set_no_attribution || echo "  warn: could not set includeCoAuthoredBy; do it by hand" >&2

cat <<'NOTE'

Done. devkit's skills are linked:
  /sketch  /product-brief  /new-project  /harness  /crunch-domain  /design-brief
  /verify-live  /verify-claim  /spike  /confess  /ship  /prune  /audit  /resume

Next — install Matt Pocock's skills (devkit references them, so you get his updates):

  Claude Code plugin (recommended — updates when he ships a new version):
    /plugin marketplace add mattpocock/skills
    /plugin install mattpocock-skills@mattpocock

  or, from a local clone, run HIS link script:  skills/scripts/link-skills.sh

Then, in any project:  /new-project   (picks a domain profile and scaffolds it)
Coming back to one:    /resume        (reads the last handoff, then checks what it claims)

Handoffs live in ~/.claude/handoffs/<project>/ — NOT /tmp, which most Linux boxes empty on
boot. METHOD.md's "Session handoffs" says why; it is the rule, this is just the reminder.

Attribution is now enforced, not just documented: ~/.claude/settings.json carries
`"includeCoAuthoredBy": false`, so the harness stops adding Co-Authored-By trailers to commits
and PR bodies. The rule itself lives in CLAUDE.md; this is what makes it hold.

Read METHOD.md for the loop, PRINCIPLES.md for the spine.
NOTE
