# Profile — Mobile full-stack

A mobile app plus its backend: the app, the API it talks to, and the data behind it, shipped as
one product. Everything in the web profile applies; the differences below are what matter.

## Stack defaults (adapt freely)
- App: React Native / Expo, Flutter, or native (Swift / Kotlin). TypeScript or the platform lang.
- Backend: a typed API (tRPC / GraphQL / REST) + a database, same discipline as the web profile.
- Tests: unit for logic, a component/widget layer, and a device/emulator run for the live walk.

## Gate set (green before every commit)
- Typecheck + lint (app and backend)
- Tests: unit + component/widget for the touched area; backend suite for touched endpoints
- Build: the app builds for at least one target (`expo prebuild` / `flutter build` / Xcode/Gradle)
  **and** the backend builds/migrates cleanly
- Boundaries: `<boundary cmd>` — app and backend checked separately (see **Standards harness**)
- Drift: `scripts/drift-check.sh --cached`
- Live exercise: see below

## Domain dial (default: **on**)
- **Why on:** an app with accounts, sync, or payments clears two triggers on day one.
- **Invariants worth writing:** what stays true across an offline edit and a later sync (the
  conflict rule *is* an invariant), what a token may do, and any local state the server can contradict.
- **The trap unique to this profile:** the **client/server split is not a context split.** It is one
  domain with two runtimes — split it and you get two half-models of the same rules, which is the
  duplication the boundary was meant to prevent. The shared package for domain types is the seam.
- **Enforcers:** the rule lives once, in the shared/domain package, and both runtimes call it.
  A rule implemented in Swift/Kotlin *and* on the server is two rules waiting to disagree.

## Design & accessibility (`/design-brief`)
Everything in the web profile applies. What differs is that the platform ships the assistive
technology, so the enforcer is a real screen reader rather than a browser extension.
- **`DESIGN.md`** covers the app's surfaces; the backend has none, so it appears only where a
  response shape *is* the surface (an error a user reads).
- **Enforcers that exist:** `eslint-plugin-react-native-a11y` for RN, Flutter's `Semantics` widgets
  plus its accessibility guideline tests (`meetsGuideline(textContrastGuideline)`) `[lint]` `[test]`;
  and on native, the platform accessibility inspector.
- **The live pass is the real gate `[live]`:** complete the primary flow with **TalkBack or
  VoiceOver on**, then again at the **largest system font size**. Both find things nothing static
  catches — an unlabelled icon button, a control announced as "button" and nothing else, text that
  truncates into meaninglessness at 200% type.
- **Touch targets:** 44x44pt (iOS) / 48x48dp (Android) minimum. A tap target measured in the
  designer's screenshot is not measured; check it on the smallest supported device.
- **What no gate catches:** gesture-only interactions with no accessible alternative, and a
  reachability problem on a large phone that every emulator hides.

## Standards harness (`/harness`)
- **`CODING_STANDARDS.md`** at the repo root — the file `/code-review`'s Standards axis reads.
- **Boundary gate, TS/RN:** `dependency-cruiser` via `/setup-ts-deep-modules`, run over the app
  and the backend as separate roots. The boundary that matters most here is the **app↔backend
  contract** — generate the client from one source of truth so skew becomes a typecheck failure
  rather than a runtime 500.
- **Boundary gate, Flutter/Dart:** `analysis_options.yaml` with `dart analyze`; import-boundary
  linting is thin in this ecosystem, so expect a grep-based check — and label it `[script]`, not
  `[lint]`, so nobody over-trusts it.
- **Boundary gate, native:** on the JVM/Kotlin side ArchUnit-style architecture *tests* are the
  mature option (Konsist if you want Kotlin-native — verify maturity first, per `/harness` step 1);
  on Swift, module targets are the real boundary, since SwiftLint has no import rules.
- **Drift gate:** `scripts/drift-check.sh` — run it over app and backend together, so a term that
  drifts on one side of the wire is caught against the other.
- **What no harness here catches:** permission-denied paths, offline behavior, and version skew
  between a shipped app and a moved backend. Those are `/verify-live`'s job.

## Tracer slice
`data → API → app screen → device → it actually does the thing`. A slice spans the backend and
the app together — a screen with no endpoint, or an endpoint no screen calls, is not a slice.
Ship the vertical, thin, working on a real device.

## Verify like a user (`/verify-live`)
Run the **built app on a device or emulator** (not just a component in isolation), tap through
the real flow as the real persona. Exercise the things phones break: **offline / flaky network,
small screens, permission prompts (camera, location, notifications), cold start, background→foreground.**
Capture screen recordings or frames. Verify the app against the *actually deployed* backend, not
a local mock, before `/ship`.

## What green tests can't prove here
- Behavior on real network conditions (loss, latency, airplane mode) vs the fast local API.
- Platform permission flows and their denied states.
- Layout on the smallest supported screen; safe-area / notch clipping.
- App ↔ backend version skew (an old app hitting a new API, or vice-versa).

## Definition of done
Installed and tapped through on a device (or a faithful emulator), against the deployed backend,
with the flow captured. Backend deployed and verified like the web profile. Store submission is
a separate, explicit `/ship` step.
