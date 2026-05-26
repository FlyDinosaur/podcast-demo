# Research: Podcast Playlist UI

## Decision 1: Use `AVPlayer` as the local audio playback engine

**Decision**: Use `AVPlayer` from `AVFoundation` to play local bundled audio files and switch the current item when the listener selects a new episode.

**Rationale**: `AVPlayer` is the standard Apple playback primitive for local audio assets, supports lightweight item replacement, and is sufficient for the requested simple playback behavior without introducing unnecessary media frameworks or custom buffering logic.

**Alternatives considered**:

- `AVAudioPlayer`: Simpler API, but less aligned with future extensibility if playback state or progress handling grows.
- Third-party audio libraries: Rejected because the feature scope is small and the project should remain dependency-light.

## Decision 2: Keep playback state in a shared app-level controller plus dedicated view models

**Decision**: Create a shared playback controller owned near the app root, with view models observing or delegating to it so that playback survives tab switches and the mini-player remains available across screens.

**Rationale**: Shared ownership at the tab-shell level prevents playback state from being destroyed when the playlist view hierarchy changes. This preserves MVVC boundaries: the controller manages audio/session flow, while view models adapt that shared state for playlist and mini-player presentation.

**Alternatives considered**:

- Storing playback state directly inside the playlist view: Rejected because the state would be tightly coupled to one screen and fragile across navigation.
- Global singletons with no injected ownership: Rejected because they weaken testability and obscure lifecycle management.

## Decision 3: Treat `data/Info`, `data/Image`, and `data/Audio` as bundled app resources

**Decision**: Load the metadata JSON from local bundled resources and resolve cover/audio references against bundled file names copied from the repository `data/` folders into the app target.

**Rationale**: The feature explicitly forbids remote URLs and requires local files only. Bundling the JSON, images, and audio into the app target provides deterministic offline behavior and keeps refresh behavior purely local.

**Alternatives considered**:

- Reading directly from arbitrary filesystem paths outside the app bundle: Rejected because it is brittle on iOS and does not match standard app packaging.
- Remote URLs with fallback caching: Rejected because the feature is frontend-only and explicitly local-file based.

## Decision 4: Simulate pull-to-refresh by reloading local metadata and revalidating the active item

**Decision**: Implement refresh as a local content reload with a short async delay to surface the refresh affordance, then rebuild the playlist while retaining the active playback session if the current episode still exists and remains valid.

**Rationale**: This matches the requested simulated refresh behavior while avoiding false expectations of network activity. Revalidation of the active item protects against future dataset edits without unnecessarily stopping playback.

**Alternatives considered**:

- No-op refresh that only dismisses the spinner: Rejected because it gives no meaningful state update path.
- Full playback reset on every refresh: Rejected because it violates the feature expectation that playback should remain stable.

## Decision 5: Use graceful visual and playback fallback for missing local assets

**Decision**: If an image is missing, show a stable placeholder image state. If an audio file is missing, keep the item visible but prevent or fail playback gracefully without crashing the app.

**Rationale**: The spec prioritizes resilience and usability. Users should still be able to browse the list even if one local asset is invalid.

**Alternatives considered**:

- Removing invalid items completely at render time: Rejected because silent disappearance makes dataset issues harder to understand.
- Crashing or hard-failing the screen on missing assets: Rejected because it violates the resilience requirement.
