# Personal projects — devkit method

Every project under `~/code/personal` follows the **devkit method** (this repo's `./devkit`).
This file auto-loads for any session launched anywhere in this tree; a project's own `AGENTS.md`
(its rules for every agent, which its `CLAUDE.md` imports) stacks on top and wins on specifics.
Precedence when docs disagree: the Owner's live instructions > a project's `AGENTS.md` and
`CLAUDE.md` > this file.

## Hard limits (immutable, every personal project)
- Never push, open a PR, deploy, publish, or release without an explicit go. Local commits are
  fine; anything that leaves this machine is a deliberate keystroke (the Owner's merge, or an explicit go).
- Never spend money, add API keys, or send anything to a real external recipient without asking.
- Never run a destructive command on shared or irreplaceable state.
- **Never sign a commit, PR, or issue as Claude.** No `Co-Authored-By: Claude ...` trailer, no
  "Generated with Claude Code", no 🤖 line, no Claude/Anthropic attribution of any kind in a commit
  message, PR body, issue, or changelog. The Owner is the sole author of record. This overrides the
  agent harness's default git behaviour, which adds those trailers unless told otherwise.
- When a permission layer refuses an action, stop and stage it — do not work around it.

## The method (always on)
@~/code/personal/devkit/PRINCIPLES.md
@~/code/personal/devkit/METHOD.md
@~/code/personal/devkit/ANTI-PATTERNS.md

## Working here
- Bootstrap a new project with **`/new-project`** (picks a domain profile, lays down its own
  `AGENTS.md` with a thin `CLAUDE.md` that imports it, `GLOSSARY.md`, `REVIEW-DEBT.md`, and gate
  commands). Greenfield idea first? **`/product-brief`**.
- The loop's own commands: `/architect`, `/mandate`, `/verify-live`, `/confess`, `/verify-claim` (devkit) and
  the Matt Pocock chain (`/grill-with-docs` → `/to-spec` → `/implement` → `/code-review`).
- Real rules in the project (money, scheduling, permissions, state machines)? The **domain dial**
  in `METHOD.md` says whether to run **`/crunch-domain`** → `GLOSSARY.md` + `INVARIANTS.md`. Default
  off; the glossary is always on.
- Does the project have a **surface** (screens, or a CLI's output contract)? **`/design-brief`** →
  `DESIGN.md`: surfaces reconciled against the MVP cut, states citing the brief, and every
  accessibility rule naming its enforcer. The look, the copy and the wireframes are
  `ui-ux-pro-max`'s job; "which layout wins" is `/prototype`'s.
- Repo grown a trail? **`/prune`** — dead files, exports, imports, deps, env vars and commented-out
  blocks, each **proven** dead before it is deleted (env vars are reported, never deleted — the
  proof lives outside the repo). Duplication comes second, and "kept duplicated, deliberately" is a
  valid answer; the design work goes to `/improve-codebase-architecture`.
- Before the project meets real users: **`/audit`** — every finding carries a verdict (`exploited` /
  `reachable` / `suspected`) with file:line, ranked by reachability before severity, starting at
  `INVARIANTS.md` because broken authorization is the bug a solo app actually ships. Static and
  local only; nothing deployed is touched, and no code leaves this machine.
- Domain profiles live in `./devkit/profiles/` (web, mobile-fullstack, game, cli-tools, library).

- Session over, or starting cold? **`/handoff`** (mp) writes one, **`/pickup`** (dk) reads it back
  and checks its claims. Where they live and why not `/tmp` is `METHOD.md`'s *Session handoffs* —
  stated once, there, because it travels with the repo and this file does not.
