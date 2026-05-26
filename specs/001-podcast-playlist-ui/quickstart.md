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

## Manual Verification

1. Launch the app and open the podcast tab.
2. Verify at least 10 episode rows render with cover, title, host, duration, and playback affordance.
3. Tap one episode and confirm audio starts plus exactly one row enters active state.
4. Tap a different episode and confirm the previous row returns to default while the new one becomes active.
5. Switch between bottom tabs and confirm playback continues and the mini-player remains visible.
6. Return to the podcast tab and confirm the active row still matches the mini-player.
7. Pull to refresh and confirm the list reloads without breaking valid active playback.
8. Test in both light and dark appearance and on at least one compact and one larger iPhone simulator.

## Notes

- The repository currently has empty `data/` subdirectories, so sample content must be added before end-to-end verification can pass.
- If local assets are intentionally missing during development, verify placeholder and graceful-failure paths instead of allowing crashes.
