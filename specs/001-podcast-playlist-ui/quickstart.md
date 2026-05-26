# Quickstart: Podcast Playlist UI

## Goal

Implement and verify the local podcast playlist interface described in `spec.md` using the MVVC structure defined in `plan.md`.

## Prerequisites

1. Keep all feature code inside `Poadcast/Model`, `Poadcast/View`, `Poadcast/ViewModel`, and `Poadcast/Controller`.
2. Prepare at least 10 episode entries in a JSON metadata file under `data/Info`.
3. Place matching local cover assets under `data/Image` and audio files under `data/Audio`.
4. Add the JSON, image, and audio files to the Xcode target as bundled resources.

## Suggested Implementation Order

1. Create domain models for `Episode`, playlist state, playback session, and tab destination.
2. Add a local repository/data controller that loads and validates bundled metadata plus local resource references.
3. Add an audio controller backed by `AVPlayer` for play and item switching.
4. Build playlist and mini-player view models that adapt shared playback state for the UI.
5. Build the tab shell, podcast list screen, episode card view, and floating mini-player in SwiftUI.
6. Add simulated pull-to-refresh and active-item reconciliation.
7. Add placeholder companion tabs that preserve the shared playback session.

## Implemented Structure

1. `Poadcast/Model` now contains the episode, playback session, playlist collection, and playlist row state models.
2. `Poadcast/Controller/Data` loads `data/Info/info.json`, validates local asset availability, and simulates pull-to-refresh.
3. `Poadcast/Controller/Audio` owns the shared `AVPlayer` session and exposes the single active playback state used by the playlist and mini-player.
4. `Poadcast/ViewModel` composes the shared tab shell, playlist, and mini-player state adapters.
5. `Poadcast/View` contains the playlist screen, episode row, floating mini-player, and the three-tab shell.
6. `Poadcast.xcodeproj` now bundles `data/Info/info.json`, `data/Image/*`, and `data/Audio/*` into the app target through the synchronized `data/` group.

## Manual Verification

1. Launch the app and open the podcast tab.
2. Verify at least 10 episode rows render with cover, title, host, duration, and playback affordance.
3. Tap one episode and confirm audio starts plus exactly one row enters active state.
4. Tap a different episode and confirm the previous row returns to default while the new one becomes active.
5. Switch between bottom tabs and confirm playback continues and the mini-player remains visible.
6. Return to the podcast tab and confirm the active row still matches the mini-player.
7. Pull to refresh and confirm the list reloads without breaking valid active playback.
8. Test in both light and dark appearance and on at least one compact and one larger iPhone simulator.
9. Tap an item whose assets are intentionally missing during development and confirm the row stays visible while the UI falls back gracefully.

## Build Notes

1. A CLI build can be checked with `xcodebuild -project Poadcast.xcodeproj -scheme Poadcast -destination 'generic/platform=iOS' -derivedDataPath /private/tmp/PoadcastDerivedData CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build`.
2. In this environment, Swift compilation and resource-copy steps succeed, but asset-catalog thinning still depends on a working CoreSimulator service. If the command fails with `No available simulator runtimes for platform iphonesimulator`, open the project in Xcode and run the app from the IDE instead.

## Notes

- The repository already contains 13 sample episodes in `data/Info/info.json` with matching local cover and audio files.
- If local assets are intentionally missing during development, verify placeholder and graceful-failure paths instead of allowing crashes.
