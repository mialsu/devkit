#!/usr/bin/env bash
# local-llm.test.sh — local-llm's exit codes, which seats branch on to decide whether to do a job
# themselves: 0 ran, 2 usage, 3 no usable model here, 4 input too large.
#
# Needs node, and nothing else: no Ollama, no model, no GPU. Every case runs with an empty HOME,
# CREW_LOCAL_MODEL unset and OLLAMA_HOST pointed at a closed port, so no case can reach a real
# Ollama on this machine. The too-large case runs with no model configured on purpose: the size
# guard has to fire before the model lookup, and if it ever moved after it this case would get 3.
#
# Usage: openrig/crew/bin/local-llm.test.sh    exits 1 when any case fails

set -uo pipefail
llm="$(cd "$(dirname "$0")" && pwd)/local-llm"

home="$(mktemp -d)"
trap 'rm -rf "$home"' EXIT
run() { env -u CREW_LOCAL_MODEL HOME="$home" OLLAMA_HOST=127.0.0.1:1 "$@"; }

fails=0
# expect <code> <name> — compares against the exit status of the command just run.
expect() {
  local got=$? want=$1 name=$2
  if [ "$got" -eq "$want" ]; then
    printf '  ok    %-28s expected %s, got %s\n' "$name" "$want" "$got"
  else
    fails=$((fails + 1))
    printf '  FAIL  %-28s expected %s, got %s\n' "$name" "$want" "$got"
  fi
}

out="$(run "$llm" --version)"
expect 0 "--version"
if [ "$out" != "local-llm 0.1.0" ]; then
  fails=$((fails + 1))
  printf '  FAIL  %-28s expected "local-llm 0.1.0", got "%s"\n' "--version output" "$out"
fi

run "$llm" </dev/null >/dev/null 2>&1
expect 2 "no instruction"

printf '' | run "$llm" "summarise" >/dev/null 2>&1
expect 2 "empty stdin"

echo "a short input" | run "$llm" "summarise" >/dev/null 2>&1
expect 3 "no model configured"

# A 2100-token window leaves 52 tokens for input after the reserve; 600 characters is about 200.
head -c 600 /dev/zero | tr '\0' x | run env CREW_LOCAL_CTX=2100 "$llm" "summarise" >/dev/null 2>&1
expect 4 "too large, no model"

[ "$fails" -eq 0 ] || { printf 'local-llm.test: %s failure(s).\n' "$fails"; exit 1; }
