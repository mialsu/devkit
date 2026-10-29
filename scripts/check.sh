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

# --- 3b. the vocabulary check actually MATCHES ------------------------------
# The smoke test above proves the awk program runs. It cannot prove the matcher matches, and for
# a long time it did not: banned terms were stored whole while identifiers were compared segment
# by segment, so every multi-word entry in every project glossary was inert and the check printed
# clean forever. A gate that silently passes is worse than no gate, and only an assertion on real
# input catches it. Built as a throwaway repo because the gate reads GLOSSARY.md via git ls-files.
group "3b. vocabulary check behaviour (fires on what it must, ignores what it must not)"
vt="$(mktemp -d)"
(
  cd "$vt" || exit 2
  git init -q . && git config user.email t@t && git config user.name t
  printf '%s\n' '_Avoid_: run, step, flag, purchase, end customer, write_off, orderRow' > GLOSSARY.md
  : > seed.txt && git add -A && git commit -qm seed
  # MUST fire: one-segment, its plural, a two-segment term in all four spellings, a run inside a
  # longer identifier, and a snake_case / space-separated term written camelCase in the code.
  printf '%s\n' 'runTask' 'purchases' 'createPurchase' 'endCustomer' 'end_customer' \
                 'EndCustomers' 'endCustomerId' 'writeOff' 'orderRow' 'order_rows' > must.ts
  # MUST NOT fire: substring collisions the segment split exists to prevent, and plurals of terms
  # under the 5-letter floor.
  printf '%s\n' 'runtime' 'overrun' 'lockstep' 'setWindowFlags' 'flagship' 'Flags' \
                 'runs' 'steps' 'flags' 'stepper' > mustnot.ts
  git add -N must.ts mustnot.ts
) >/dev/null 2>&1
if [ ! -d "$vt/.git" ]; then
  skipped "could not build the throwaway repo — this check is not running"
else
  vout="$(cd "$vt" && bash "$OLDPWD/templates/scripts/drift-check.sh" 2>&1)"
  missed=""
  for want in runTask purchases createPurchase endCustomer end_customer EndCustomers \
              endCustomerId writeOff orderRow order_rows; do
    printf '%s' "$vout" | grep -q "must\.ts.*$want(" || missed="$missed $want"
  done
  wrong="$(printf '%s' "$vout" | grep 'mustnot\.ts' | sed 's/^/        /')"
  if [ -n "$missed" ]; then bad "banned words the check did NOT catch:$missed"; fi
  if [ -n "$wrong" ]; then bad "false positives — the segment split over-matched"; printf '%s\n' "$wrong"; fi
  [ -z "$missed" ] && [ -z "$wrong" ] && ok "10 must-fire, 10 must-not-fire"
fi
rm -rf "$vt"

# --- 3c. the size check waives the gate's own file, and only that file ------
# Every project copies the gate into its repo, and the gate is longer than the size cap it
# enforces, so check 6 used to flag it on the commit that added it. The waiver matches the RUNNING
# file, so this puts a copy inside the throwaway repo the way a project does. It runs that copy
# through a relative path out of a subdirectory, which the gate's own cd would otherwise invalidate.
group "3c. size check behaviour (still fires on a big new file, waives the gate's own)"
st="$(mktemp -d)"
(
  cd "$st" || exit 2
  git init -q . && git config user.email t@t && git config user.name t
  mkdir scripts src && cp "$OLDPWD/templates/scripts/drift-check.sh" scripts/
  seq 1 450 > src/big.ts
) >/dev/null 2>&1
if [ ! -f "$st/scripts/drift-check.sh" ]; then
  skipped "could not build the throwaway repo — this check is not running"
else
  sout="$(cd "$st/src" && bash ../scripts/drift-check.sh 2>&1)"
  sfail=0
  printf '%s\n' "$sout" | grep -qxF '     src/big.ts' || { sfail=1; bad "a 450-line new file was NOT flagged"; }
  printf '%s\n' "$sout" | grep -qxF '     scripts/drift-check.sh' && { sfail=1; bad "the gate flagged its own file"; }
  [ "$sfail" = 0 ] && ok "flags a 450-line new file, waives its own"
fi
rm -rf "$st"

# --- 3d. the diagram checks fire on the gap, whatever declares the schema ----
# Check 12 once fired only on a staged SQL migration, so a project whose schema is declared any
# other way had no check 12 at all; check 13 once read only the caption lines a diff added, so the
# rename it exists for went unseen. Both are asserted at a commit (--cached), where they run.
group "3d. diagram checks behaviour (12: unstaged ERD; 13: a rename no caption saw)"
dt="$(mktemp -d)"
(
  cd "$dt" || exit 2
  git init -q . && git config user.email t@t && git config user.name t
  mkdir -p docs src && printf 'erDiagram\n' > docs/schema.gen.md && : > src/store.ts
  printf '%s\n' '> **Code:** `src/store.ts`' 'Prose naming the **Code:** field is not a caption: `src/gone.ts`' > docs/architecture.md
  git add -A && git commit -qm seed
) >/dev/null 2>&1
if [ ! -d "$dt/.git" ]; then
  skipped "could not build the throwaway repo — this check is not running"
else
  # Captured, then grepped from a here-string: `drift | grep -q` under pipefail fails the pipe when
  # grep exits at its first match (SIGPIPE), the defect check_lock had in the gate itself.
  drift() { (cd "$dt" && bash "$OLDPWD/templates/scripts/drift-check.sh" --cached 2>&1); }
  dfail=0
  out="$(drift)"; grep -q 'DRIFT' <<<"$out" && { dfail=1; bad "a clean repo with an ERD and a caption was flagged"; }
  printf 'erDiagram\n  a {\n  }\n' > "$dt/docs/schema.gen.md"
  out="$(drift)"; grep -q 'DRIFT · schema — docs/schema.gen.md' <<<"$out" || { dfail=1; bad "an unstaged regenerated ERD was NOT flagged"; }
  (cd "$dt" && git add docs/schema.gen.md)
  out="$(drift)"; grep -q 'DRIFT · schema' <<<"$out" && { dfail=1; bad "a staged ERD was flagged"; }
  (cd "$dt" && git mv src/store.ts src/kept.ts)
  out="$(drift)"; grep -q 'cites src/store.ts, which is not in the repo' <<<"$out" || { dfail=1; bad "a renamed file its caption still cites was NOT flagged"; }
  grep -q 'src/gone.ts' <<<"$out" && { dfail=1; bad "prose that names the caption field was read as a caption"; }
  [ "$dfail" = 0 ] && ok "12 fires on an unstaged ERD only; 13 catches a rename and skips prose"
fi
rm -rf "$dt"

# --- 3e. a project's own settings live beside the gate, not in it -------------
# Every project carries the gate byte-identical; what is its own goes in drift-check.local.sh. This
# proves the file is read and each of its hooks takes effect, from a copy inside a monorepo package,
# and asserts the two rules projects had patched into their copies before they came back here.
group "3e. drift-check.local.sh behaviour (settings, checks, package root, test cap, ADR names)"
lt="$(mktemp -d)"
(
  cd "$lt" || exit 2
  git init -q . && git config user.email t@t && git config user.name t
  mkdir -p pkg/scripts pkg/fixtures pkg/tests pkg/docs/adr
  cp "$OLDPWD/templates/scripts/drift-check.sh" pkg/scripts/
  cat > pkg/scripts/drift-check.local.sh <<'LOCAL'
DEVKIT_GATE=test
DRIFT_ROOT=package
MAX_NEW_TEST_FILE_LINES=600
local_settings() { SKIP_CONTENT="(^|/)fixtures/|$SKIP_CONTENT"; }
local_checks() { report "local — the project's own check ran" "none" "none"; }
LOCAL
  printf '{ "name": "pkg" }\n' > pkg/package.json
  : > pkg/docs/adr/0001-seed.md
  git add -A && git commit -qm seed
  seq 1 450 > pkg/fixtures/big.csv          # skipped by local_settings
  seq 1 450 > outside.ts                    # outside the package: not policed
  seq 1 500 > pkg/tests/store.test.ts       # under the test cap
  seq 1 450 > pkg/store.ts                  # over the cap: must fire
  printf '{\n  "name": "pkg",\n  "dependencies": {\n    "left-pad": "^1.3.0"\n  }\n}\n' > pkg/package.json
  printf 'An unrelated decision.\n' > pkg/docs/adr/0002-other.md
  git add -A
) >/dev/null 2>&1
if [ ! -f "$lt/pkg/scripts/drift-check.local.sh" ]; then
  skipped "could not build the throwaway repo — this check is not running"
else
  lfail=0
  out="$(cd "$lt" && bash pkg/scripts/drift-check.sh --cached 2>&1)"
  grep -q "DRIFT · local — the project's own check ran" <<<"$out" || { lfail=1; bad "local_checks did NOT run"; }
  grep -qxF '     store.ts' <<<"$out" || { lfail=1; bad "a 450-line file inside the package was NOT flagged"; }
  grep -q 'big.csv' <<<"$out" && { lfail=1; bad "local_settings' SKIP_CONTENT extension was ignored"; }
  grep -q 'outside.ts' <<<"$out" && { lfail=1; bad "DRIFT_ROOT=package policed a file outside the package"; }
  grep -q 'store.test.ts' <<<"$out" && { lfail=1; bad "a 500-line test file was flagged under a 600 test cap"; }
  grep -q 'gained a dependency no ADR names' <<<"$out" || { lfail=1; bad "an unrelated ADR waved a new dependency through"; }
  printf 'Uses `left-pad`.\n' > "$lt/pkg/docs/adr/0002-other.md"; (cd "$lt" && git add -A)
  out="$(cd "$lt" && bash pkg/scripts/drift-check.sh --cached 2>&1)"
  grep -q 'gained a dependency' <<<"$out" && { lfail=1; bad "a dependency an ADR names was still flagged"; }
  [ "$lfail" = 0 ] && ok "local settings and checks apply; package root, test cap and ADR names hold"
fi
rm -rf "$lt"

# --- 3f. drift-ci.sh checks the range the event brought, or fails --------------
# Each project once resolved its CI range in its own workflow, and two of the three narrowed to the
# last commit when the base was missing. This asserts each base resolves as the header says, that
# an unknown base and a shallow clone fail instead, and that the range reaches the gate.
group "3f. drift-ci.sh behaviour (range per base; unknown base and shallow clone fail)"
ct="$(mktemp -d)"
(
  git init -q "$ct/repo" && cd "$ct/repo" && git config user.email t@t && git config user.name t
  mkdir scripts && cp "$OLDPWD/templates/scripts/drift-check.sh" "$OLDPWD/templates/scripts/drift-ci.sh" scripts/
  git add -A && git commit -qm seed
) >/dev/null 2>&1
if [ ! -f "$ct/repo/scripts/drift-ci.sh" ]; then
  skipped "could not build the throwaway repo — this check is not running"
else
  ci() { (cd "$ct/repo" && bash scripts/drift-ci.sh "$@" 2>&1); }
  cfail=0
  [ "$(ci --print '')" = "$(git hash-object -t tree /dev/null)...HEAD" ] || { cfail=1; bad "a root commit did not diff against the empty tree"; }
  (cd "$ct/repo" && echo x > a && git add a && git commit -qm second) >/dev/null 2>&1
  seed="$(git -C "$ct/repo" rev-parse HEAD~1)"
  [ "$(ci --print '')" = "HEAD~1...HEAD" ] || { cfail=1; bad "an empty base did not fall back to HEAD~1"; }
  [ "$(ci --print 0000000000000000000000000000000000000000)" = "HEAD~1...HEAD" ] || { cfail=1; bad "the all-zero base did not fall back to HEAD~1"; }
  [ "$(ci --print "$seed")" = "$seed...HEAD" ] || { cfail=1; bad "a known base was not used as the range"; }
  ci --print deadbeefdeadbeefdeadbeefdeadbeefdeadbeef >/dev/null && { cfail=1; bad "a base not in the clone did NOT fail"; }
  (cd "$ct/repo" && seq 1 450 > big.ts && git add big.ts && git commit -qm big) >/dev/null 2>&1
  out="$(ci "$seed")" && { cfail=1; bad "a 450-line file in the range did NOT fail the gate"; }
  grep -q 'big.ts' <<<"$out" || { cfail=1; bad "the gate did not name the file the range brought"; }
  git clone -q --depth 1 "file://$ct/repo" "$ct/shallow" >/dev/null 2>&1
  (cd "$ct/shallow" && bash scripts/drift-ci.sh >/dev/null 2>&1) && { cfail=1; bad "a shallow clone did NOT fail"; }
  [ "$cfail" = 0 ] && ok "each base resolves as documented; unknown base and shallow clone fail; the range reaches the gate"
fi
rm -rf "$ct"

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
# cross-repo ambiguity that makes `GLOSSARY.md` mean two different files depending on who reads it.
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

# --- 7. local-llm exit codes ------------------------------------------------
# Seats branch on local-llm's exit codes to decide whether to do a job themselves, so a changed
# code silently changes who does the work. The test needs node but no Ollama, model or GPU.
group "7. local-llm exit codes"
if command -v node >/dev/null 2>&1; then
  if lout="$(bash openrig/crew/bin/local-llm.test.sh 2>&1)"; then ok "openrig/crew/bin/local-llm.test.sh"
  else bad "openrig/crew/bin/local-llm.test.sh"; fi
  printf '%s\n' "$lout" | sed 's/^/      /'
else
  skipped "node is NOT installed — local-llm's exit codes are not being tested"
fi

# --- 8. the junior's worktree gate -------------------------------------------
# Pi has no sandbox, so worktree-only.ts is all that keeps the junior's file tools out of the
# Owner's home folder and the repository's hooks. Its check needs node 22.6+ for type stripping.
group "8. junior worktree gate"
if command -v node >/dev/null 2>&1; then
  gate=openrig/crew/agents/junior/pi/extensions/worktree-only.check.mts
  if gout="$(node --experimental-strip-types --no-warnings "$gate" 2>&1)"; then ok "$gate"
  else bad "$gate"; fi
  printf '%s\n' "$gout" | tail -n 1 | sed 's/^/      /'
else
  skipped "node is NOT installed — the junior's worktree gate is not being tested"
fi

# --- 9. junior-sync ----------------------------------------------------------
# Seats move and clean the junior's worktree with it; a version that drops OpenRig's AGENTS.md
# blocks leaves the junior without its instructions and no error. Needs git only.
group "9. junior-sync"
if jout="$(bash openrig/crew/bin/junior-sync.test.sh 2>&1)"; then ok "openrig/crew/bin/junior-sync.test.sh"
else bad "openrig/crew/bin/junior-sync.test.sh"; fi
printf '%s\n' "$jout" | tail -n 1 | sed 's/^/      /'

# --- verdict ----------------------------------------------------------------
printf '\n'
if [ "$fails" -gt 0 ]; then
  printf 'check: %s failure(s).\n' "$fails"
  exit 1
fi
printf 'check: green.\n'

