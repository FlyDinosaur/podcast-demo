# Data Model: Podcast Playlist UI

## Entity: Episode

**Purpose**: Represents one podcast program displayed in the playlist and used for playback selection.

### Fields

| Field | Type | Description | Validation |
|------|------|-------------|------------|
| `id` | UUID | Unique episode identifier | Required; must be unique within the playlist |
| `title` | String | Display title shown in list and mini-player | Required; non-empty |
| `host` | String | Host or presenter name | Required; non-empty |
| `duration` | String | Human-readable duration label | Required; formatted for display |
| `coverAssetName` | String | Local bundled cover resource reference | Required; may fall back visually if file is missing |
| `audioAssetName` | String | Local bundled audio resource reference | Required for playback; invalid values must fail gracefully |

### Relationships

- One `PlaylistCollection` contains many `Episode` records.
- One `PlaybackSession` references zero or one active `Episode`.

### State Notes

- An episode can be displayed in either default or active visual state.
- An episode can remain list-visible even when one or both local assets are invalid.

## Entity: PlaylistCollection

**Purpose**: Holds the ordered set of valid episode records displayed on the podcast tab.

### Fields

| Field | Type | Description | Validation |
|------|------|-------------|------------|
| `episodeArray` | [Episode] | Ordered episodes for display | Must contain at least 10 valid items in prepared sample data |
| `lastRefreshDate` | Date | Most recent simulated refresh completion time | Optional until first refresh |
| `isRefreshingBool` | Bool | Indicates whether refresh UI should be active | Managed by refresh flow |

### Relationships

- Owns the list of `Episode` entities.
- Is read by the playlist view model and refreshed by the data controller.

### State Transitions

1. `idle` -> `refreshing` when pull-to-refresh begins
2. `refreshing` -> `idle` when local reload completes

## Entity: PlaybackSession

**Purpose**: Represents shared playback state for the active mini-player and playlist highlighting.

### Fields

| Field | Type | Description | Validation |
|------|------|-------------|------------|
| `activeEpisode` | Episode? | Currently selected episode | Optional when nothing is playing |
| `isPlayingBool` | Bool | Whether audio playback is actively running | Must remain consistent with player state |
| `playbackErrorString` | String? | Optional user-safe error state for invalid audio | Optional; set only on recoverable playback failure |

### Relationships

- References at most one `Episode`.
- Is coordinated by the audio controller and observed by playlist and mini-player view models.

### State Transitions

1. `empty` -> `playing` when a playable episode is selected
2. `playing(A)` -> `playing(B)` when a new episode replaces the current one
3. `playing` -> `error` if the selected audio asset cannot be loaded
4. `error` -> `playing` when the listener selects a valid episode
5. `playing` -> `empty` only when playback is explicitly cleared or the active episode becomes invalid and cannot continue

## Entity: TabDestination

**Purpose**: Represents the sections shown in the bottom navigation while sharing one playback session.

### Fields

| Field | Type | Description | Validation |
|------|------|-------------|------------|
| `id` | String | Stable tab identifier | Required; unique |
| `title` | String | Tab label shown to the user | Required |
| `isPodcastHomeBool` | Bool | Indicates whether the tab hosts the playlist | Exactly one tab should be the playlist home in this feature |

### Relationships

- Selected by a tab-shell view model.
- Shares the same `PlaybackSession` regardless of active tab.
