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
- Boundaries: `<boundary cmd>` (see **Standards harness**)
- Drift: `scripts/drift-check.sh --cached`
- Live exercise: see below.

## Domain dial (default: **on for the rules domain only**)
- **On for:** simulation, combat, economy, progression, save versioning — the parts with rules a
  player can exploit, where "what must always be true" has a real answer.
- **Off for:** rendering, input, animation, asset plumbing, UI chrome. These are layers with
  conventions, not a domain, and modelling them produces vocabulary nobody speaks.
- **Invariants worth writing:** an economy that can't be farmed to infinity, a state machine that
  can't be re-entered mid-transition, a save that either loads or fails loudly (never half-loads),
  damage/resource maths that can't go negative or NaN.
- **Enforcers:** deterministic simulation tests and property tests do the work here — replay a
  fixed input sequence and assert the invariant every tick. Save-format invariants get a
  round-trip test per version.
- **`mapped` is rarely right.** Subsystems are not bounded contexts. Split only if the same word
  genuinely differs — a "Level" in the editor vs. a "Level" in progression.

## Design & accessibility (`/design-brief`)
Run `/design-brief` for **HUD and menus only** — whether the mechanic *feels* right is the live
exercise below, not a document. Be honest that this is the profile where a11y has the fewest
automated enforcers, which makes labelling them the whole job.
- **Enforcers that genuinely exist `[test]`:** remappable input (assert the binding layer has no
  hard-coded key), a subtitle/caption path (assert every voiced line has a caption entry), and text
  scale (assert the HUD renders at the largest supported size without clipping).
- **Honest `[review-only]`, and there are many:** colour-blind-safe palettes, no essential
  information carried by colour alone, flashing within safe thresholds, readable contrast over a
  moving background — which is the hard one, because the background changes every frame.
- **The live pass `[live]`:** play the slice once with **sound off** and once with the HUD's
  smallest legible scale. Both surface information the design was quietly delivering through a
  channel a player may not have.
- **What no gate catches:** whether the HUD is readable *while* playing, as opposed to readable in
  a screenshot. Only playing tells you, which is this profile's whole premise.

## Standards harness (`/harness`)
- **`CODING_STANDARDS.md`** at the repo root — the file `/code-review`'s Standards axis reads.
- **Boundary gate, Unity/C#:** **assembly definitions (`.asmdef`) are the real mechanism** — an
  illegal reference fails the compile, which beats any linter. Add architecture *tests*
  (NetArchTest / ArchUnitNET class) for the rules asmdefs can't express.
- **Boundary gate, Godot/GDScript:** `gdlint` (gdtoolkit) covers style, not structure — there is
  no import-boundary linter, so this is a grep-based `[script]`: no `get_node("../../..")` walking
  out of a scene, no system reaching directly into another system's nodes, signals across seams.
- **Boundary gate, Bevy/Rust:** crate boundaries plus `pub(crate)` visibility do the work the
  compiler already understands; `cargo-deny` for dependencies.
- **Drift gate:** `scripts/drift-check.sh`. Point `CONTEXT.md` at the **rules** — damage, economy,
  state machines, save versions — which is the part of a game with a real domain worth a glossary.
  Presentation naming doesn't need one.
- **What no harness here catches:** feel. Nothing static tells you the slice is fun; only playing
  it does (see **Verify like a user**).

## Dead code & duplication (`/prune`)
- **The engine is a caller no analyzer can see.** Unity's message methods (`Awake`, `Start`,
  `OnTriggerEnter`) and every `[SerializeField]` private field are invoked by the runtime, not from
  code; Godot wires callbacks through signals and `.tscn` node paths; Bevy registers systems by
  passing function items to `add_systems`. Roslyn's IDE0051/IDE0052 and Rust's `dead_code` lint will
  all call these dead. **Assume a hit inside engine-facing code is a false positive** and prove
  otherwise — this profile inverts `/prune`'s usual default.
- **Search the scenes, not just the scripts.** A `.tscn`, `.unity`, `.prefab` or `.meta` file
  references a script by path or GUID, so any grep that only reads source is lying to you.
- **Unused assets dominate the payoff, not unused code** — textures, audio, prefabs and animations
  nobody references are usually the biggest thing a sweep removes. Unity's dependency queries and
  the build report are the evidence; for Godot, resource paths in the scene files are.
- **Rust / Bevy:** `cargo-machete` on stable, or `cargo +nightly udeps`, for unused dependencies.
- **Duplication is often deliberate here.** Tuning variants, per-weapon behaviour that reads alike
  today, and copy-pasted numbers that will diverge next playtest all fail the same-reason-to-change
  test. Prefer duplication over a premature shared system, and say so in the report.

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
