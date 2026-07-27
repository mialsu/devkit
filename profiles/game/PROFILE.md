# Profile — Game dev

Games (Godot, Unity, Bevy, LÖVE, raw engine, etc.). The big shift from the other profiles:
"works" is necessary but not sufficient — the slice also has to **feel right**, and only playing
it tells you that. Automated tests cover logic; playing covers fun.

## Stack defaults (adapt freely)
- An engine (Godot / Unity / Unreal) or a framework (Bevy / LÖVE / MonoGame).
- Source control with an LFS setup for binary assets; `.gitignore` for import caches / builds.
- Tests: unit tests for pure logic (damage math, state machines, save/load, procedural gen).

## Gate set (green before every commit)
- The project **opens in the engine with no import/script errors** and the console is clean.
- Lint/format for the scripting language (GDScript / C# / Rust) where tooling exists.
- Tests: the pure-logic suite for the touched systems.
- Build: a playable build of the target platform succeeds.
- Live exercise: see below.

## Tracer slice
`mechanic → input binding → on-screen feedback → it plays`. A slice is a single playable
mechanic loop — the player can *do the thing and see it respond*. Not "the inventory data model"
alone; the smallest thing that is fun (or informative) to play for ten seconds.

## Verify like a user (`/verify-live`)
**Build and play the slice** — in a build, not only in the editor, at least before `/ship`.
Capture a short clip or key frames. Then answer two questions honestly, in the confession:
1. Does it *work* (no crash, no error spam, frame budget sane)?
2. Does it *feel right* (responsive input, readable feedback, no jank)? "It runs but feels bad"
   is a PARTIAL, not a WORKS — record exactly what feels off.

## What green tests can't prove here
- Game feel: input latency, animation timing, juice, readability of feedback.
- Frame-rate under real load (many entities, particles) vs an empty test scene.
- Editor-only behavior that breaks in a packaged build (paths, resource loading).
- Save/load and versioning across builds; a save from an old build poisoning a new one.

## Definition of done
Built for the target, **played** in that build, clip/frames captured, and the feel verdict
recorded. A slice that runs but isn't fun yet ships as an honest PARTIAL with the feel notes as
next work — never as a silent "done".
