# Invariants — <PROJECT or CONTEXT NAME>

The rules this domain is not allowed to break, written in the words of `CONTEXT.md`. Each one
names the **enforcer that fails the moment it is violated**. An invariant that names no enforcer
is prose pretending to be a guarantee — see *the pseudo-artifact* in `ANTI-PATTERNS.md`, which is
the failure mode this file exists to prevent.

Exists only when the **domain dial** (METHOD.md) is `on`. A CRUD app's rules are its schema;
restating them here buys nothing and rots.

## Invariants are not acceptance criteria

They look alike and are not:

| | Acceptance criterion (`AC-n`, in the spec) | Invariant (`INV-n`, here) |
|---|---|---|
| Scope | one slice | the whole domain, every release |
| Lifetime | until `/verify-live` fills its verdict | until the domain itself changes |
| Violated means | the slice isn't done | there is a bug, whatever shipped it |
| Lives in | `specs/NNNN-*.md` — history once shipped | this file — read by every future session |

## Rules for this file

1. **5–10 per context.** Thirty means most are field validations wearing a costume. If you can't
   find five, the domain dial should be off.
2. **One line, and falsifiable.** State what must always hold *and* the concrete case that would
   prove it broken. "Bookings stay consistent" is not an invariant; "a Room never holds two
   Bookings whose nights overlap" is.
3. **Every one names its enforcer** — `test:<name>`, `constraint:<db object>`, `type:<name>`, or
   `[review-only]`. `[review-only]` is an honest label and a debt: it owes a `REVIEW-DEBT.md`
   entry the same day.
4. **One owner in code.** The same rule enforced in three places is three chances to drift. Name
   the single place that owns it; everywhere else calls that.
5. **Glossary words only.** If stating an invariant needs a word `CONTEXT.md` doesn't define, the
   word goes in `CONTEXT.md` first — then write the invariant.
6. **The Owner supplies these.** The agent may draft candidates from the code, ask, and challenge;
   but an invariant the Owner cannot state with this file closed is not theirs yet
   (PRINCIPLES #11). A list nobody can recite is the pseudo-artifact, not the model.

## Invariants

| # | Must always be true | Violated when | Enforced by | Owner in code |
|---|---|---|---|---|
| INV-1 | <the rule, one line, in glossary words> | <the concrete case that breaks it> | `test:<name>` / `constraint:<name>` / `[review-only]` | `path/to/file.ext` |

Referenced from three places, which is what makes it load-bearing rather than decorative:
- **the spec** — `Invariants touched: INV-2, INV-5`, so a slice declares what it can break;
- **the code** — a comment naming `INV-n` at its owner, so the next reader knows why the check exists;
- **`/verify-live`** — which *attacks* every invariant the slice touches instead of only walking the
  happy path.

The drift gate fails any new `INV-` row added here with an empty `Enforced by` cell.

## Retired invariants

An invariant that stopped being true is a **domain change**, not a deletion — the old rule is still
sitting in the old code, and the next session will re-derive it unless the retirement is written
down. Strike the id (`~~INV-3~~`) so it can never be reused.

| # | Was | Retired | Replaced by |
|---|---|---|---|
| ~~INV-0~~ | <the rule as it stood> | <YYYY-MM-DD, and why the domain changed> | INV-n / nothing |
