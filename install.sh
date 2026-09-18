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

# The method's rules live in two CLAUDE.md files that are deliberately NOT in this repo: devkit is
# public and those files are personal config -- a public method repo carrying one person's prose
# preferences is weaker as a showcase, and the template/instance split is one this repo already
# makes (see templates/CLAUDE.md). They travel in a private companion repo instead, and this links
# them so one `git pull` per repo updates every machine.
#
# Discovery is by $CLAUDE_CONFIG or by path, never by URL: a public repo must not carry a private
# remote. Absent the companion repo this is a no-op with a notice, so devkit stays usable by
# anyone who clones it.
link_rules() {
  local cc="" cand
  for cand in "${CLAUDE_CONFIG:-}" "$HOME/code/personal/claude-config" "$(dirname "$REPO")/claude-config"; do
    if [ -n "$cand" ] && [ -f "$cand/manifest.tsv" ]; then cc="$cand"; break; fi
  done
  if [ -z "$cc" ]; then
    echo "  no claude-config found -- skipping rule files"
    echo "  (clone it beside devkit, or export CLAUDE_CONFIG=/path/to/it)"
    return 0
  fi
  echo "  using $cc"

  local linked=0 skipped=0 src dest parent
  while IFS=$'\t' read -r src dest || [ -n "${src:-}" ]; do
    case "$src" in ''|'#'*) continue ;; esac
    [ -n "${dest:-}" ] || continue
    dest="${dest/#\$HOME/$HOME}"

    if [ ! -f "$cc/$src" ]; then
      echo "  warn: $src is in the manifest but missing from $cc" >&2
      continue
    fi

    parent="$(dirname "$dest")"
    if [ ! -d "$parent" ]; then
      echo "  skip $dest ($parent absent on this machine)"
      skipped=$((skipped+1)); continue
    fi

    # A real file here is somebody's existing rules. Never delete it silently -- ln -sfn would.
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
      if cmp -s "$dest" "$cc/$src"; then
        : # identical; replacing with a symlink loses nothing
      else
        mv "$dest" "$dest.before-devkit"
        echo "  kept your existing $(basename "$dest") as $(basename "$dest").before-devkit" >&2
      fi
    fi

    ln -sfn "$cc/$src" "$dest"
    linked=$((linked+1))
  done < "$cc/manifest.tsv"

  local noun="rule files"; [ "$linked" -eq 1 ] && noun="rule file"
  if [ "$skipped" -gt 0 ]; then
    echo "  linked $linked $noun, skipped $skipped not applicable to this machine"
  else
    echo "  linked $linked $noun"
  fi
}

echo "Installing devkit skills from $REPO"
for d in "${DESTS[@]}"; do link_into "$d"; done

echo "Enforcing the attribution rule"
set_no_attribution || echo "  warn: could not set includeCoAuthoredBy; do it by hand" >&2

echo "Linking rule files"
link_rules

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

Rule files (the CLAUDE.md pair) come from the private claude-config repo, not this one --
devkit is public and those files are personal. Clone it beside devkit, or export
CLAUDE_CONFIG, and re-run this script; without it you get the skills and no standing rules.

Read METHOD.md for the loop, PRINCIPLES.md for the spine.
NOTE
