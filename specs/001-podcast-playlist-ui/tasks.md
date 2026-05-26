# Tasks: Podcast Playlist UI

**Input**: Design documents from `/specs/001-podcast-playlist-ui/`

**Prerequisites**: `plan.md` (required), `spec.md` (required for user stories), `research.md`, `data-model.md`, `contracts/`

**Tests**: Manual simulator verification from `specs/001-podcast-playlist-ui/quickstart.md` is required. Dedicated automated tests are not generated here because the specification does not require TDD and the repository does not yet include a `PoadcastTests/` target.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (`US1`, `US2`, `US3`)
- Every task includes exact file paths

## Path Conventions

- App source: `Poadcast/`
- Models: `Poadcast/Model/`
- Views: `Poadcast/View/`
- View models: `Poadcast/ViewModel/`
- Controllers: `Poadcast/Controller/`
- Bundled local content: `data/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the filesystem layout and bundle the local podcast assets into the app target.

- [X] T001 Create MVVC feature folders under `Poadcast/Model/Episode/`, `Poadcast/Model/Playback/`, `Poadcast/Model/Repository/`, `Poadcast/View/Playlist/`, `Poadcast/View/Shared/`, `Poadcast/View/Tabs/`, `Poadcast/ViewModel/Playlist/`, `Poadcast/ViewModel/Playback/`, `Poadcast/ViewModel/Tabs/`, `Poadcast/Controller/Audio/`, `Poadcast/Controller/Data/`, and `Poadcast/Controller/Navigation/`
- [X] T002 Update `Poadcast.xcodeproj/project.pbxproj` so `data/Info/info.json`, `data/Image/`, and `data/Audio/` are copied into the `Poadcast` app bundle resources
- [X] T003 [P] Replace the starter root wiring in `Poadcast/PoadcastApp.swift` and `Poadcast/ContentView.swift` with a feature entry point that can host shared playlist, playback, and tab dependencies

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build the shared domain, loading, playback, and shell infrastructure required by all user stories.

**⚠️ CRITICAL**: No user story work should start until this phase is complete.

- [X] T004 Define the shared domain entities in `Poadcast/Model/Episode/Episode.swift`, `Poadcast/Model/Playback/PlaybackSession.swift`, `Poadcast/Model/Repository/PlaylistCollection.swift`, and `Poadcast/Model/Playback/TabDestination.swift`
- [X] T005 [P] Implement bundled metadata decoding and local asset validation in `Poadcast/Controller/Data/PlaylistDataController.swift` and `Poadcast/Model/Repository/LocalPlaylistRepository.swift`
- [X] T006 [P] Implement the shared `AVPlayer` session coordinator in `Poadcast/Controller/Audio/PlaybackController.swift` for play, pause, replace-current-item, and invalid-audio fallback handling
- [X] T007 Create the shared tab-shell state and dependency composition in `Poadcast/ViewModel/Tabs/AppTabShellViewModel.swift` and `Poadcast/View/Tabs/AppTabShellView.swift`
- [X] T008 Connect the app root to the shared shell and mini-player host in `Poadcast/ContentView.swift` and `Poadcast/PoadcastApp.swift`, preserving MVVC boundaries and the function documentation requirement

**Checkpoint**: Foundation ready. User stories can now be implemented against stable local data, playback coordination, and tab-shell ownership.

---

## Phase 3: User Story 1 - Browse and Play Local Episodes (Priority: P1) 🎯 MVP

**Goal**: Render a scrollable list of bundled podcast episodes and allow the listener to start or pause a single active episode from the playlist.

**Independent Test**: Launch the app on the `节目` tab, verify at least 10 local episodes render, tap one episode to start playback and highlight only that row, then tap the same row again to pause without activating another item.

- [X] T009 [P] [US1] Implement playlist-facing state models in `Poadcast/Model/Repository/PlaylistRowState.swift` and `Poadcast/ViewModel/Playlist/PlaylistViewState.swift`
- [X] T010 [P] [US1] Build episode-row and playlist screen UI in `Poadcast/View/Playlist/EpisodeRowView.swift` and `Poadcast/View/Playlist/PodcastPlaylistView.swift`
- [X] T011 [P] [US1] Implement list loading, row selection, and single-active-item logic in `Poadcast/ViewModel/Playlist/PodcastPlaylistViewModel.swift`
- [X] T012 [US1] Wire playlist interactions to the shared playback controller in `Poadcast/Controller/Audio/PlaybackController.swift`, `Poadcast/ViewModel/Playlist/PodcastPlaylistViewModel.swift`, and `Poadcast/View/Playlist/PodcastPlaylistView.swift`
- [X] T013 [US1] Integrate the finished playlist screen into `Poadcast/View/Tabs/AppTabShellView.swift` and `Poadcast/ContentView.swift` so the `节目` tab is fully functional with local playback

**Checkpoint**: User Story 1 is functional and independently testable as the MVP podcast list and playback experience.

---

## Phase 4: User Story 2 - Keep Playback Across Navigation (Priority: P2)

**Goal**: Preserve the active playback session while switching between the three bottom tabs and keep the floating mini-player visible across those tabs.

**Independent Test**: Start playback from the playlist, switch between `节目`, `发现`, and `我的`, confirm audio does not stop, and verify the mini-player remains visible with the same episode title and play/pause behavior.

- [X] T014 [P] [US2] Build the persistent floating mini-player UI in `Poadcast/View/Shared/MiniPlayerView.swift`
- [X] T015 [P] [US2] Implement mini-player presentation state and playback toggling in `Poadcast/ViewModel/Playback/MiniPlayerViewModel.swift`
- [X] T016 [P] [US2] Create the three-tab destination views in `Poadcast/View/Tabs/PodcastHomeTabView.swift`, `Poadcast/View/Tabs/DiscoverPlaceholderView.swift`, and `Poadcast/View/Tabs/ProfilePlaceholderView.swift`
- [X] T017 [US2] Update `Poadcast/View/Tabs/AppTabShellView.swift`, `Poadcast/ViewModel/Tabs/AppTabShellViewModel.swift`, and `Poadcast/Controller/Navigation/TabNavigationController.swift` so tab switches preserve the shared playback session and keep `MiniPlayerView` mounted above the tab bar

**Checkpoint**: User Story 2 works independently with persistent playback and shared mini-player behavior across navigation.

---

## Phase 5: User Story 3 - Refresh and Read the Interface Comfortably (Priority: P3)

**Goal**: Add simulated pull-to-refresh, graceful asset fallback, and iPhone-ready adaptive styling for light and dark appearances.

**Independent Test**: Pull to refresh on the playlist while a valid episode is active, verify playback remains consistent after the refresh completes, then check the UI in light and dark mode on compact and larger iPhone simulators for clipping or unreadable states.

- [X] T018 [P] [US3] Implement simulated refresh and active-item reconciliation in `Poadcast/Controller/Data/PlaylistRefreshController.swift` and `Poadcast/ViewModel/Playlist/PodcastPlaylistViewModel.swift`
- [X] T019 [P] [US3] Add missing-cover and missing-audio fallback behavior in `Poadcast/View/Playlist/EpisodeRowView.swift`, `Poadcast/View/Shared/MiniPlayerView.swift`, and `Poadcast/Controller/Audio/PlaybackController.swift`
- [X] T020 [P] [US3] Apply adaptive spacing, typography, and appearance-aware styling in `Poadcast/View/Playlist/PodcastPlaylistView.swift`, `Poadcast/View/Playlist/EpisodeRowView.swift`, `Poadcast/View/Shared/MiniPlayerView.swift`, and `Poadcast/Assets.xcassets/AccentColor.colorset/Contents.json`
- [X] T021 [US3] Enable SwiftUI `.refreshable` integration and finalize refresh-safe playlist rendering in `Poadcast/View/Playlist/PodcastPlaylistView.swift` and `Poadcast/ViewModel/Playlist/PodcastPlaylistViewModel.swift`

**Checkpoint**: User Story 3 is independently testable with refresh behavior, resilient local-asset handling, and appearance/device adaptation.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Finish integration quality, manual verification, and feature-facing documentation updates.

- [X] T022 [P] Audit all newly added files under `Poadcast/` for camelCase-plus-type-suffix variable naming and required function documentation blocks, then fix any violations in place
- [X] T023 [P] Update `specs/001-podcast-playlist-ui/quickstart.md` with the final simulator verification flow, asset-bundling notes, and any implementation-specific caveats discovered during development
- [ ] T024 Run the end-to-end manual checklist from `specs/001-podcast-playlist-ui/quickstart.md` against the finished app and record the results in `specs/001-podcast-playlist-ui/tasks.md`

## Manual Verification Status

- `2026-05-26`: `xcodebuild -project Poadcast.xcodeproj -scheme Poadcast -destination 'generic/platform=iOS' -derivedDataPath /private/tmp/PoadcastDerivedData CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build` confirmed Swift compilation reached the app build pipeline and copied `data/Info/info.json`, `data/Image/*`, and `data/Audio/*` into the app bundle.
- `2026-05-26`: End-to-end simulator validation is still pending because the CLI environment cannot access a working CoreSimulator service, causing asset-catalog thinning to fail with `No available simulator runtimes for platform iphonesimulator`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1: Setup** has no dependencies and starts immediately.
- **Phase 2: Foundational** depends on Phase 1 and blocks all story work.
- **Phase 3: User Story 1** depends on Phase 2.
- **Phase 4: User Story 2** depends on Phase 2 and integrates the shared playback session established for US1.
- **Phase 5: User Story 3** depends on Phase 2 and extends the playlist flow introduced in US1.
- **Phase 6: Polish** depends on the completion of all desired user stories.

### User Story Dependencies

- **US1 (P1)**: No dependency on other stories once foundational work is complete.
- **US2 (P2)**: Depends on the shared playback infrastructure from Phase 2 and should be validated after US1 provides a functional playback source.
- **US3 (P3)**: Depends on the playlist and playback flow from US1 because refresh reconciliation and adaptive styling are applied to that finished screen.

### Within Each User Story

- View models should be ready before final interaction wiring.
- Shared controllers may be extended only after the participating story-specific UI and state shapes are defined.
- A story is complete only after its independent manual test passes.

## Parallel Opportunities

- `T003` can run in parallel with `T001` once the feature directory plan is understood.
- `T005` and `T006` can run in parallel after `T004`.
- In **US1**, `T009`, `T010`, and `T011` can run in parallel before `T012`.
- In **US2**, `T014`, `T015`, and `T016` can run in parallel before `T017`.
- In **US3**, `T018`, `T019`, and `T020` can run in parallel before `T021`.
- In **Polish**, `T022` and `T023` can run in parallel before `T024`.

---

## Parallel Example: User Story 1

```bash
Task: "Implement playlist-facing state models in Poadcast/Model/Repository/PlaylistRowState.swift and Poadcast/ViewModel/Playlist/PlaylistViewState.swift"
Task: "Build episode-row and playlist screen UI in Poadcast/View/Playlist/EpisodeRowView.swift and Poadcast/View/Playlist/PodcastPlaylistView.swift"
Task: "Implement list loading, row selection, and single-active-item logic in Poadcast/ViewModel/Playlist/PodcastPlaylistViewModel.swift"
```

## Parallel Example: User Story 2

```bash
Task: "Build the persistent floating mini-player UI in Poadcast/View/Shared/MiniPlayerView.swift"
Task: "Implement mini-player presentation state and playback toggling in Poadcast/ViewModel/Playback/MiniPlayerViewModel.swift"
Task: "Create the three-tab destination views in Poadcast/View/Tabs/PodcastHomeTabView.swift, Poadcast/View/Tabs/DiscoverPlaceholderView.swift, and Poadcast/View/Tabs/ProfilePlaceholderView.swift"
```

## Parallel Example: User Story 3

```bash
Task: "Implement simulated refresh and active-item reconciliation in Poadcast/Controller/Data/PlaylistRefreshController.swift and Poadcast/ViewModel/Playlist/PodcastPlaylistViewModel.swift"
Task: "Add missing-cover and missing-audio fallback behavior in Poadcast/View/Playlist/EpisodeRowView.swift, Poadcast/View/Shared/MiniPlayerView.swift, and Poadcast/Controller/Audio/PlaybackController.swift"
Task: "Apply adaptive spacing, typography, and appearance-aware styling in Poadcast/View/Playlist/PodcastPlaylistView.swift, Poadcast/View/Playlist/EpisodeRowView.swift, Poadcast/View/Shared/MiniPlayerView.swift, and Poadcast/Assets.xcassets/AccentColor.colorset/Contents.json"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Validate the manual test for US1 before expanding the shell.

### Incremental Delivery

1. Deliver US1 to establish the core playlist and single-item playback flow.
2. Layer US2 on top of the shared playback controller to preserve session state across tabs.
3. Finish with US3 so refresh behavior and adaptive polish are applied to a working interface instead of being built against placeholders.

### Suggested MVP Scope

- **MVP**: Phase 1, Phase 2, and Phase 3 only.
- **Next increment**: Phase 4 for persistent playback shell behavior.
- **Final increment**: Phase 5 plus Phase 6 polish.

## Notes

- All tasks follow the required checklist format: checkbox, task ID, optional `[P]`, required story label for story tasks, and exact file paths.
- Manual verification should use the prepared local assets in `data/Info/info.json`, `data/Image/`, and `data/Audio/`.
