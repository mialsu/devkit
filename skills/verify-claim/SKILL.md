---
name: verify-claim
description: Adversarially check a claim that something "already works" or "already exists" against the actual committed code, returning file:line evidence. Use before trusting any doc, old TODO, past-session assertion, or your own memory about what the codebase does — especially before marking an inherited task done.
---

No claim is a fact until the code says so. Boards and docs rot when "this already exists" is
believed instead of checked. This skill turns a claim into a verdict backed by evidence.

## Procedure
1. **State the claim precisely** — what capability is asserted to exist or work, and what would
   count as it being true (the acceptance shape).
2. **Read the actual code, not memory or status.** `git grep` / read the relevant files at the
   committed ref (for shipped work, the deployed/released ref — never the dirty working tree,
   which proves nothing about what users have). Trace the real call path, not the name that
   merely looks right.
3. **Where behavior is claimed, exercise it** (hand off to `/verify-live` for the user-facing
   part). Code presence proves wiring; only a live exercise proves behavior.
4. **Return a verdict:**
   - **MET** — with file:line anchors for every code assertion and evidence for every behavior
     assertion.
   - **PARTIAL** — met to here, and *exactly* this is missing (that gap becomes a new task).
   - **NOT MET** — the claim is false; here is what's actually there.

State any seam weaker than the claim's letter up front, before anyone asks. A defensible PARTIAL
always beats an indefensible MET. Do not close, merge, or trust anything on a claim alone.

Best run as a background verifier agent so its investigation doesn't pollute the main context.
