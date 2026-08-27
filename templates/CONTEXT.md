# <PROJECT>

<One or two sentences: what this context is and why it exists.>

This file is the project's **ubiquitous language** — the words the domain, the docs, the
conversation, and the code all use. It is a glossary and **nothing else**: no implementation
detail, no file paths, no decisions (those are ADRs), no scope (that's the spec).

Format and rules: devkit adopts the format of the installed `domain-modeling` skill verbatim
(`~/.claude/skills/domain-modeling/CONTEXT-FORMAT.md`) so the skill that maintains this file and
the template that seeds it can never drift apart. Two devkit additions are noted below.

## Language

**<Term>**:
<What it IS, in one or two sentences. Not what it does.>
_Avoid_: <the other words people reach for for this same concept>
_Unresolved_: <optional — the part of this term still fuzzy. Resolve before it causes a bug.>

## How this file is enforced

- `_Avoid_:` is **machine-checked**. `scripts/drift-check.sh` fails a diff that introduces one of
  these words as an identifier — the language stops being a suggestion. Escape a genuine false
  positive with a `drift-ok:` comment on the line, which leaves the exemption greppable.
- **What belongs under `_Avoid_`:** a word someone would plausibly reach for *as the name of this
  concept*. Not a word the platform owns (`target` collides with the DOM's `e.target`), not one a
  dependency owns (an auth library's `user`), and not one of your own enum values or button labels.
  The gate matches identifiers, so a term whose every hit turns out to be a value or a piece of copy
  is a glossary bug, not a code bug. And if a banned word turns out to name a *different, real*
  concept, the fix is to promote it to a term of its own — that is the gate earning its keep.
- `_Unresolved_:` is devkit's second addition (the skill's format has no equivalent). It keeps a
  known-fuzzy term visible *as a term* instead of exiling the ambiguity to a separate file.
  An `_Unresolved_` term is a question for the Owner, never an assumption for the agent.

## Multiple contexts

Most projects have one. When this one grows a second — the same word meaning genuinely different
things to different actors — the convention is a `CONTEXT-MAP.md` at the repo root listing each
context, where it lives, and how they relate; each context then owns its own `CONTEXT.md` beside
its code. Don't pre-split: one context until a word actually collides.
