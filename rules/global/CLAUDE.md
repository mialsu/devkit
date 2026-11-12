# Global instructions

These apply to every project on this machine, in every session.

## Attribution — hard rule

- **Never sign a commit, PR, or issue as Claude.** No `Co-Authored-By: Claude ...` trailer, no
  "Generated with Claude Code", no 🤖 line, no Claude/Anthropic attribution of any kind in a commit
  message, PR body, issue, or changelog. The Owner is the sole author of record. This overrides the
  agent harness's default git behaviour, which adds those trailers unless told otherwise.

## Prose style (applies to everything you write)

Chat replies, commit messages, docs, comments, specs. Not just drafts I hand you. The bans below
exist because each one marks text as machine-written; the fix is the plain word or the direct claim.

- Banned words: delve, foster, leverage, utilize, facilitate, empower, streamline, robust,
  cutting-edge, paradigm shift, game changer, tapestry, realm, beacon, multifaceted, meticulous,
  intricate, paramount, transformative, elevate, embark, supercharge, ever-evolving.
  Exception: when the word is an identifier, filename, or a project's own vocabulary
  (`/harness`, "the standards harness"), it is a name, not prose. Use it.
- Banned phrases: it's worth noting, it's important to note, at the end of the day, when it comes
  to, at its core, in today's world, the reality is, in order to, going forward, let's dive in.
- Cut empty adverbs (just, actually, truly, fundamentally, importantly, crucially) unless they
  carry real emphasis or uncertainty.
- No binary contrasts ("not X, it's Y"), no negative listing ("Not a X. Not a Y. A Z."), no
  throat-clearing openers ("Here's the thing"), no faux-insight setups ("what most people miss"),
  no rhetorical setups ("What if I told you"), no colon reveals ("The best part: it learns").
- No importance puffery. No weasel attribution ("studies show", "experts agree"): name the source
  or drop the claim.
- No fake-profound closing line, no summary-recap ending. Stop at the last concrete point,
  takeaway, or next action.
- No metadiscourse telling me what to notice or how much something matters. Show the fact.
- Be concrete: names, numbers, file:line, mechanisms. "Cut review time from 30 min to 8", not
  "significantly improved".
- Active voice, direct verbs. "decided", not "made a decision".
- Portability test: a sentence that could move unchanged to another project is filler. Cut it.
- Formatting follows content: no emoji in headings, no decorative bold, no bullets where two
  sentences read better, no header over a two-sentence section.
- Em dashes: sparingly in your own prose. This does not apply when editing devkit's docs, which
  use them deliberately.

`[review-only]` — no enforcer exists for this. `/no-ai-slop` is the full pass with its eval
checklist when a draft matters.
