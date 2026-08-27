# Principles — the non-negotiable spine

These govern every project, in every domain, at every weight. They are the part of a
heavyweight team-and-production agent-delivery framework that survives being resized for solo
work: not the machinery, the *discipline*. Each is short, absolute, and testable. If a skill or a profile ever
contradicts one of these, the principle wins.

1. **Done means verified, not "should work."** "It's wired / it builds / I think it works"
   is not done. Done is: you (or a background verifier) exercised it the way a user hits it,
   with evidence. What "the way a user hits it" means is set per domain in the profile.

2. **Gates before every commit.** A change lands only when the profile's gate set is green:
   typecheck/lint, tests, a clean build, the standards harness (boundaries + drift), and a live
   exercise. No "just this once." Green tests gate; they do not prove — the live exercise proves.
   And **a gate you haven't watched fail is not a gate**: you install one by breaking it on
   purpose once, seeing it go red, and reverting.

3. **Reuse before building.** Never rebuild a capability the language, framework, or an
   existing dependency already gives you. Look first, verify how it fits, then extend or
   consume it. The most expensive waste is re-implementing an engine you already own.

4. **Slice end-to-end.** Every unit of work cuts the whole stack and is demoable alone:
   data → logic → surface → words → *it actually does the thing*. No layers banked as
   "progress" that no one can exercise yet.

5. **Confessions over silence.** Every seam you faked, deferred, stubbed, or built weaker than
   the spec goes into `REVIEW-DEBT.md` at the moment you do it — never hidden, never a surprise
   later. A confession is free backlog, not shame.

6. **Verify claims against the code, never memory.** No claim — from a doc, a past session,
   an old TODO, or your own recollection — is acted on or marked done without checking the
   actual committed code, with file:line evidence. "This already exists" is a claim, not a fact.

7. **Write it down at the moment of decision.** Load-bearing or hard-to-reverse decisions get
   an ADR *with the rejected alternatives* when decided — not reconstructed later. Vocabulary
   goes in `CONTEXT.md`; deferrals go in the spec's non-goals; open product questions go in a
   questions file, never into a silent assumption.

8. **You decide; the agent recommends.** You are the Owner. Claude is the Foreman: it grounds
   itself, then asks one question at a time with a recommendation, and executes — but it never
   decides a product question alone, and never slides from shaping into building without your go.

9. **Refuse what you don't understand.** If the agent's plan or copy uses a word or a shape you
   can't explain back, that is a signal to stop and simplify, not to approve and move on. Your
   refusal is a feature of the process.

10. **The tracker is the truth, and it never overclaims.** Whatever you use to track work
    (issues, a local file, a board) is trusted only because nothing on it is marked done that
    isn't. An honest PARTIAL always beats an indefensible DONE.

---

*The weight dial (in METHOD.md) decides how much ceremony a given task gets. It never lets you
opt out of these ten — a one-file script still gets gated and verified; it just gets less
paperwork around it.*
