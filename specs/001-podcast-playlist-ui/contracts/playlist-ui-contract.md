# UI Contract: Podcast Playlist UI

## Purpose

Define the user-facing behavior, state inputs, and rendering expectations for the podcast playlist feature so implementation and review can validate the same contract.

## Screen Contract

### Playlist Tab

**Inputs**

- Ordered `episodeArray`
- Current `PlaybackSession`
- `isRefreshingBool`

**Behavior**

- Render a vertically scrollable episode list.
- Show at least the following fields per row: cover image, title, host, duration, playback affordance.
- Allow tapping any row to request playback for that episode.
- Show exactly one active row visual state at a time.
- Support pull-to-refresh that locally reloads data and resolves back to a stable list state.

**Outputs**

- `selectEpisode(id)`
- `refreshPlaylist()`

### Floating Mini-Player

**Visibility Rule**

- Visible only when `PlaybackSession.activeEpisode` is not `nil`.

**Displayed Content**

- Current episode title
- Current playback-presence state

**Behavior**

- Persists above the tab bar across all tab destinations.
- Reflects the same active episode as the playlist highlight.

## Row State Contract

### Default State

- Neutral background and border treatment
- Standard playback affordance
- No "currently playing" emphasis

### Active State

- Distinct background or border highlight
- Visible "currently playing" emphasis
- Matches the current `PlaybackSession.activeEpisode`

### Invalid Asset State

- Missing cover image falls back to placeholder visual content
- Missing audio asset does not crash the screen and must not create a false second active row

## Navigation Contract

- Bottom tabs switch visible content without resetting the shared playback session.
- Returning to the playlist tab restores the same active row and mini-player state if playback is still valid.
- Tabs other than the playlist may use placeholder content during this feature, but they must participate in the shared shell.

## Refresh Contract

- Refresh may briefly show loading feedback for simulated reload behavior.
- Refresh reloads local metadata instead of performing a network request.
- Refresh preserves the active playback session when the active episode remains present and valid after reload.
