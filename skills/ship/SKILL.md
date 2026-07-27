---
name: ship
description: Run the per-domain publish checklist — the explicit, Owner-initiated gate between "done on my machine" and "released to the world". Use when the user says "ship", "publish", "release", "deploy", "cut a version", or "put it out".
disable-model-invocation: true
---

Publishing is always an explicit Owner keystroke — never something the agent slides into. This
skill stages the release and stops for your go at the gate. Read `profiles/<domain>/PROFILE.md`
for the domain's exact publish steps and definition of done.

## Before anything leaves the machine
1. **Freshness** — merge the mainline (if collaborating) and re-run the full gate set on the
   merged result; upstream breaks are common.
2. **Every task in this batch is verified** — `/verify-live` returned WORKS, or is honestly
   marked PARTIAL/blocked. Nothing marked done on a claim alone (`/verify-claim`).
3. **REVIEW-DEBT.md is current** — this release's confessions are recorded and you've seen them.
4. **Gates green** — the profile's full set, on the exact artifact you're about to publish.

## The publish (per profile — examples)
- **web / mobile-fullstack** → build the production artifact, deploy, then verify the *deployed*
  thing like a user (not localhost): the released URL/app, real login, version string matches.
- **cli-tools / library** → version bump + changelog, tag, build the distributable, publish to
  the registry, then install it *from the registry into a clean environment* and run it.
- **game** → build the target platform, run the built artifact (not the editor), confirm it
  launches and the slice plays.

## Definition of done
Done is the profile's done: released **and exercised in its released form**, with the evidence
and the version/tag recorded. "Uploaded" is not "done" until you've run the uploaded thing.
Report the release with its version/tag, what was verified, and the standing confessions.
