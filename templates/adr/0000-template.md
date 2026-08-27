# ADR-NNNN — <short title of the decision>

<1–3 sentences: what forced this, what we chose, and why. An ADR can be a single paragraph —
the value is recording *that* a decision was made and *why*, not filling in sections.>

## Rejected alternatives
The one section devkit makes **mandatory** (PRINCIPLES #7). It is what stops the decision being
re-proposed in six months, and it costs nothing: if a decision passed the three-part test below,
real alternatives existed by definition.
- **<alternative>** — rejected because <reason>.

## Optional sections
Include only when they add something. Most ADRs need none of them.
- **Status** — `proposed | accepted | superseded by ADR-NNNN`. Useful once decisions get revisited.
- **Consequences** — only for non-obvious downstream effects you'll have to live with.
- **Constraints not visible in the code** — "we can't use X because of Y".

---

## Conventions (from the installed `domain-modeling` skill — do not diverge)
- Lives in `docs/adr/`, sequentially numbered `0001-slug.md`. Scan for the highest number, add one.
- Created **lazily** — the directory appears when the first ADR is needed, not at bootstrap.
- Write it **at the moment of decision** (PRINCIPLES #7), never reconstructed later.

## Write one only when all three are true
1. **Hard to reverse** — changing your mind later has real cost.
2. **Surprising without context** — a future reader will ask "why on earth is it like this?"
3. **The result of a real trade-off** — genuine alternatives existed and you picked one.

If any is missing, skip it. Easy to reverse? You'll just reverse it. Not surprising? Nobody will
wonder. No real alternative? There's nothing to record beyond "we did the obvious thing."
