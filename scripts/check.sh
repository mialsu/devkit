#!/usr/bin/env bash
# check.sh — devkit's own gate set.
#
# devkit ships a harness (/harness) and, until this file existed, had none of its own: no
# CODING_STANDARDS.md, no CI, no lint on the 200-line script it distributes. The drift gate ran
# only because someone remembered to type it. That is the anti-pattern "a standard with no
# enforcer", committed by the repo that named it.
#
# This is a PROSE + BASH repo, so the gates are shaped for that: shell syntax, shellcheck, the
# drift gate on itself, skill frontmatter, and — the one that matters most here — dead
# cross-references. devkit is documents pointing at documents; a reference that stops resolving is
# its likeliest defect, and nothing else would catch it.
#
# Usage:
#   scripts/check.sh            # working tree + staged
#   scripts/check.sh --cached   # staged only (pre-commit); passed through to the drift gate

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2

fails=0
ok()    { printf '  ok    %s\n' "$1"; }
bad()   { fails=$((fails + 1)); printf '  FAIL  %s\n' "$1"; }
skipped(){ printf '  SKIP  %s\n' "$1"; }
group() { printf '\n%s\n' "$1"; }

# --- 1. shell syntax --------------------------------------------------------
group "1. shell syntax (bash -n)"
while IFS= read -r f; do
  if err="$(bash -n "$f" 2>&1)"; then ok "$f"; else bad "$f"; printf '%s\n' "$err" | sed 's/^/        /'; fi
done < <(git ls-files '*.sh')

# --- 2. shellcheck ----------------------------------------------------------
group "2. shellcheck"
if command -v shellcheck >/dev/null 2>&1; then
  tmp="$(mktemp)"
  while IFS= read -r f; do
    if shellcheck -S warning "$f" >"$tmp" 2>&1; then ok "$f"; else bad "$f"; sed 's/^/        /' "$tmp"; fi
  done < <(git ls-files '*.sh')
  rm -f "$tmp"
else
  skipped "shellcheck is NOT installed — this gate is not running (apt install shellcheck)"
fi

# --- 3. the drift gate, plus a smoke test on its awk program ----------------
# The vocabulary check is an awk program inside shell single quotes, so a stray apostrophe ANYWHERE
# inside it — a comment included — silently breaks it. `bash -n` does not catch that; only running
# it does. This check has caught it twice.
group "3. drift gate on devkit itself"
out="$(bash templates/scripts/drift-check.sh "$@" 2>&1)"; rc=$?
if printf '%s' "$out" | grep -qE '^(awk|gawk|mawk):|drift-check\.sh: line [0-9]+: '; then
  bad "the drift gate is BROKEN, not merely red — usually an apostrophe inside its single-quoted awk program"
  printf '%s\n' "$out" | grep -E '^(awk|gawk|mawk):|drift-check\.sh: line [0-9]+: ' | sed 's/^/        /'
elif [ "$rc" -ne 0 ]; then
  bad "drift gate reports violations"
  printf '%s\n' "$out" | sed 's/^/        /'
else
  ok "clean"
fi

# --- 4. skill frontmatter ---------------------------------------------------
# install.sh links a skill by its DIRECTORY name; the runtime resolves it by the frontmatter
# `name:`. A mismatch means the skill installs and then cannot be invoked — silently.
group "4. skill frontmatter (name: must equal the directory)"
while IFS= read -r sk; do
  dir="$(basename "$(dirname "$sk")")"
  if [ "$(head -1 "$sk")" != "---" ]; then bad "$sk — no YAML frontmatter"; continue; fi
  name="$(sed -n 's/^name:[[:space:]]*//p' "$sk" | head -1)"
  desc="$(sed -n 's/^description:[[:space:]]*//p' "$sk" | head -1)"
  [ -n "$desc" ] || bad "$sk — no description: (the runtime uses it to decide relevance)"
  if [ "$name" = "$dir" ]; then ok "$dir"; else bad "$sk — name: '$name' != directory '$dir'"; fi
done < <(git ls-files 'skills/*/SKILL.md')

# --- 5. every skill is advertised where a human looks -----------------------
group "5. every skill listed in README.md and install.sh"
while IFS= read -r sk; do
  n="$(basename "$(dirname "$sk")")"; missing=""
  grep -q -- "/$n" README.md  || missing="README.md"
  grep -q -- "/$n" install.sh || missing="$missing install.sh"
  if [ -z "$missing" ]; then ok "/$n"; else bad "/$n missing from:$missing"; fi
done < <(git ls-files 'skills/*/SKILL.md')

# --- 6. cross-references resolve --------------------------------------------
# Markdown links (unambiguously intra-repo), plus backticked paths under devkit's OWN top-level
# directories. `scripts/...` and `docs/...` are deliberately excluded: in this repo's prose they
# usually name a path inside a GENERATED project or another repo entirely
# (`scripts/drift-check.sh --cached` is what a project runs, not what devkit contains) — the same
# cross-repo ambiguity that makes `CONTEXT.md` mean two different files depending on who reads it.
# Placeholders (<domain>, NNNN, globs) are patterns, not paths, so they are skipped too.
group "6. cross-references resolve"
refs=0; dead=0
while IFS=$'\t' read -r src target; do
  [ -n "${target:-}" ] || continue
  case "$target" in
    http*|mailto:*|"#"*|"") continue ;;
    *"<"*|*">"*|*"*"*|*NNNN*|*"{"*|*'$'*|*"|"*) continue ;;
  esac
  target="${target%%#*}"; target="${target%% *}"; target="${target%/}"
  # A trailing line reference is evidence, not part of the path. CODING_STANDARDS.md REQUIRES
  # file:line for any claim about another repo, so `foo.sh:119-273` has to resolve as `foo.sh`
  # or the two rules contradict each other.
  case "$target" in *:[0-9]*) target="${target%%:[0-9]*}" ;; esac
  [ -n "$target" ] || continue
  case "$target" in
    /*) base="." ;;
    *)  base="$(dirname "$src")" ;;
  esac
  refs=$((refs + 1))
  [ -e "$base/$target" ] || [ -e "./$target" ] || { bad "$src → $target (does not exist)"; dead=$((dead + 1)); }
done < <(
  git ls-files '*.md' | while IFS= read -r f; do
    grep -oP '\]\(\K[^)]+'                                   "$f" 2>/dev/null | sed "s#^#$f\t#"
    grep -oP '`\K(templates|skills|profiles)/[^`]+'            "$f" 2>/dev/null | sed "s#^#$f\t#"
  done
)
[ "$dead" -eq 0 ] && ok "$refs references, all resolve"

# --- verdict ----------------------------------------------------------------
printf '\n'
if [ "$fails" -gt 0 ]; then
  printf 'check: %s failure(s).\n' "$fails"
  exit 1
fi
printf 'check: green.\n'

