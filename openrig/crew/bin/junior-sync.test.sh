#!/usr/bin/env bash
# junior-sync.test.sh: junior-sync moves and cleans the junior's worktree and keeps OpenRig's blocks.
#
# Builds a throwaway repository with a .crew/junior worktree, gives the worktree what a job and
# OpenRig leave behind, then moves it to a commit that also changes AGENTS.md: the case a plain
# merge left in conflict. Exits 1 on any check that fails.
set -uo pipefail

sync="$(cd "$(dirname "$0")" && pwd)/junior-sync"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
fails=0
check() { if eval "$2"; then printf '  ok    %s\n' "$1"; else printf '  FAIL  %s\n' "$1"; fails=$((fails + 1)); fi; }

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
repo="$tmp/repo"
git init -q "$repo" && cd "$repo" || exit 2
printf '# Project\nrules\n' > AGENTS.md && echo one > f.txt
git add -A && git commit -qm one
git worktree add -q --detach .crew/junior HEAD
printf '# Project\nrules\nmore rules\n' > AGENTS.md && echo two > f.txt
git commit -qam two

j="$repo/.crew/junior"
printf '\n<!-- BEGIN OpenRig MANAGED BLOCK: role.md -->\nyou are the junior\n<!-- END OpenRig MANAGED BLOCK: role.md -->\n' >> "$j/AGENTS.md"
echo edited > "$j/f.txt"
echo stray > "$j/new.ts"

out="$("$sync" 2>&1)"; code=$?
check "exits 0" "[ $code -eq 0 ]"
check "worktree at the main tree's HEAD" "[ \"\$(git -C '$j' rev-parse HEAD)\" = \"\$(git rev-parse HEAD)\" ]"
check "the job's edit is gone" "[ \"\$(cat '$j/f.txt')\" = two ]"
check "the job's new file is gone" "[ ! -e '$j/new.ts' ]"
check "the commit's AGENTS.md change is there" "grep -q 'more rules' '$j/AGENTS.md'"
check "OpenRig's block is kept" "grep -q 'you are the junior' '$j/AGENTS.md'"
check "no conflict markers" "! grep -qE '^(<<<<<<<|>>>>>>>)' '$j/AGENTS.md'"
check "only AGENTS.md differs" "[ \"\$(git -C '$j' status --short)\" = ' M AGENTS.md' ]"

"$sync" >/dev/null 2>&1
check "a second run keeps one copy of the block" "[ \"\$(grep -c 'BEGIN OpenRig' '$j/AGENTS.md')\" -eq 1 ]"

[ "$fails" -eq 0 ] || { printf '%s\n' "$out"; echo "junior-sync: $fails check(s) failed"; exit 1; }
echo "junior-sync: all checks pass"
