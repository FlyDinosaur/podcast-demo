# Implementation Plan: Podcast Playlist UI

**Branch**: `001-podcast-playlist-ui` | **Date**: 2026-05-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-podcast-playlist-ui/spec.md`

**Note**: This plan covers Phase 0 research and Phase 1 design artifacts for the local podcast playlist frontend.

## Summary

Build a SwiftUI-based podcast playlist experience that reads episode metadata and local media references from the repository `data/` directory, renders a scrollable list with a single active playback state, plays bundled audio, preserves playback through bottom-tab navigation, and keeps a persistent mini-player visible above the tab bar. Implementation will follow the project's MVVC constitution with explicit separation between local content loading, playback/session coordination, screen rendering, and tab-level navigation.

## Technical Context

**Language/Version**: Swift 5.0 in the current Xcode project, targeting iOS APIs compatible with the constitution baseline of iOS 17+

**Primary Dependencies**: SwiftUI, AVFoundation, Observation, Foundation

**Storage**: Local bundled files from `data/Info`, `data/Image`, and `data/Audio`; in-memory playback and selection state

**Testing**: Manual UI verification on iPhone simulators plus targeted unit tests for local metadata parsing and playback-state transitions when a test target is added

**Target Platform**: iPhone-first iOS app, with the current Xcode target set above the constitution minimum

**Project Type**: SwiftUI mobile app frontend

**Performance Goals**: Initial playlist render under 1 second for the prepared local sample set; refresh feedback completes in about 2 seconds; scrolling remains visually smooth for at least 10 locally sourced items

**Constraints**: Frontend-only scope; MVVC required; code must live under `Model/`, `View/`, `ViewModel/`, and `Controller/`; single active playback item; local file references only; dark mode support; playback must survive tab switching

**Scale/Scope**: One primary playlist screen, one shared mini-player, one tab shell with placeholder companion tabs, and a prepared local dataset of at least 10 episode records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Pass: MVVC responsibilities are explicitly planned for episode loading, playback/session state, list rendering, mini-player rendering, refresh behavior, and tab coordination.
- Pass: The planned source tree uses dedicated `Poadcast/Model/`, `Poadcast/View/`, `Poadcast/ViewModel/`, and `Poadcast/Controller/` groups with no mixed-responsibility files.
- Pass: Scope remains frontend only; local bundled content replaces any backend or remote media dependency.
- Pass: All new variable names will follow camelCase with a type suffix.
- Pass: Every new function will include a required documentation block.
- Pass: All UI work is planned in SwiftUI and remains compatible with the constitution baseline of iOS 17+.

## Project Structure

### Documentation (this feature)

```text
specs/001-podcast-playlist-ui/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── playlist-ui-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
Poadcast/
├── Model/
│   ├── Episode/
│   ├── Playback/
│   └── Repository/
├── View/
│   ├── Playlist/
│   ├── Shared/
│   └── Tabs/
├── ViewModel/
│   ├── Playlist/
│   ├── Playback/
│   └── Tabs/
└── Controller/
    ├── Audio/
    ├── Data/
    └── Navigation/

data/
├── Audio/
├── Image/
└── Info/
```

**Structure Decision**: Use the constitution-mandated iOS SwiftUI MVVC structure. `Model` owns episode and playback domain types plus local repository abstractions. `View` contains playlist cards, mini-player, and tab shell UI. `ViewModel` exposes observable playlist, playback, and tab state. `Controller` handles audio engine orchestration, local file resolution, refresh coordination, and tab-level session persistence.

## Phase 0: Research

1. Confirm the recommended playback engine for a simple local-audio SwiftUI app.
2. Confirm the best approach for exposing app-wide playback state across tabs without breaking SwiftUI ownership boundaries.
3. Confirm the local content packaging approach for JSON metadata, images, and audio files stored in the repository `data/` folders.
4. Confirm the refresh strategy for simulating reload while preserving current playback state.
5. Confirm fallback behavior for missing local assets.

## Phase 1: Design

1. Define the domain model for episode records, list state, playback session state, and tab destinations.
2. Define the UI contract for the playlist screen, episode row states, mini-player visibility rules, and cross-tab persistence behavior.
3. Define quickstart steps for preparing local assets, wiring them into the Xcode target, and validating the feature manually.
4. Update `AGENTS.md` so future work references this plan directly.

## Post-Design Constitution Check

- Pass: Design artifacts keep state and coordination split across MVVC layers rather than concentrating it in a single SwiftUI view.
- Pass: Planned filesystem layout maps one-to-one to the four constitution groups.
- Pass: The design remains frontend-only and assumes all content is bundled locally.
- Pass: Naming and documentation requirements remain explicit implementation gates.
- Pass: No UIKit, storyboard, or backend dependency was introduced during planning.

## Complexity Tracking

No constitution violations identified. No exceptions or complexity waivers are required.
