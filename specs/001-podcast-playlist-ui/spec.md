# Feature Specification: Podcast Playlist UI

**Feature Branch**: `001-podcast-playlist-ui`

**Created**: 2026-05-26

**Status**: Draft

**Input**: User description: "我现在要制作一个音乐播客的播单界面，请你参考原型图以及下面描述的要求构建此界面的前端：1. 节目列表展示：使用 SwiftUI 实现一个列表，展示至少10条节目数据，每条节目包含：封面图、标题、主播名称、时长、音频地址，列表需要支持上下滑动浏览 2. 数据来源： 本项目中的data文件夹中，Image为封面图，Audio为音频文件，Info文件中保存了所有播客的信息，项目所有文件均保存在本地文件夹，对应URL应当为本地文件，不需要用https协议 3. 播放状态切换：点击任意节目条目时，该条目显示“正在播放”的视觉标识（对应条目背景高亮），同时，之前正在播放的条目恢复普通状态，即同一时间只有一条节目处于“播放中状态” 4. UI 适配：适配 iPhone 不同屏幕尺寸，支持深色模式适配 5. 实现一个简单的音频播放功能,点击节目后播放对应的音频文件 6. 添加一个“播放中”悬浮条，显示当前正在播放的节目标题(类似于底部悬浮播放悬窗) 7. 对列表添加下拉刷新功能（模拟刷新） 8. 底部Tab选项点击后切换到对应界面，同时播放播客不停止播放，保留播放悬浮窗。"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse and Play Local Episodes (Priority: P1)

As a listener, I want to browse a scrollable playlist of local podcast episodes and tap any episode to start playback, so I can immediately listen to content stored in the app bundle.

**Why this priority**: This is the core purpose of the feature. Without local episode browsing and playback, the screen provides no user value.

**Independent Test**: Can be fully tested by launching the app with bundled episode metadata and media files, scrolling the list, tapping an episode, and confirming the selected episode begins playback while the UI marks only that episode as active.

**Acceptance Scenarios**:

1. **Given** the app has at least 10 valid local episode records, **When** the listener opens the podcast tab, **Then** the app shows a vertically scrollable list of episode cards with cover image, title, host name, duration, and playback affordance for each item.
2. **Given** no episode is currently marked active, **When** the listener taps an episode card, **Then** that episode begins playing and the tapped card shows the active playback visual state.
3. **Given** one episode is already active, **When** the listener taps a different episode card, **Then** the newly tapped episode becomes the only active item and the previous item returns to its default state.

---

### User Story 2 - Keep Playback Across Navigation (Priority: P2)

As a listener, I want playback to continue while I switch between bottom tabs, so I can move around the app without interrupting the currently playing podcast.

**Why this priority**: Persistent playback and a visible mini-player preserve continuity and align with user expectations for audio apps.

**Independent Test**: Can be fully tested by starting playback from the list, switching among bottom tabs, and confirming audio continues while the floating playback bar remains visible with the current episode title.

**Acceptance Scenarios**:

1. **Given** an episode is currently playing, **When** the listener switches to another bottom tab, **Then** playback continues without restarting or stopping and the floating playback bar remains visible.
2. **Given** an episode is currently playing on a non-list tab, **When** the listener returns to the podcast list tab, **Then** the same episode remains marked as active and the floating playback bar still shows that episode.

---

### User Story 3 - Refresh and Read the Interface Comfortably (Priority: P3)

As a listener, I want the playlist screen to refresh on pull and remain readable in light or dark appearance on different iPhone sizes, so the interface feels modern and dependable.

**Why this priority**: Refresh feedback and adaptive presentation improve trust and day-to-day usability, but they are secondary to core playback.

**Independent Test**: Can be fully tested by pulling down on the list to trigger refresh feedback, viewing the screen in light and dark appearance, and verifying the layout remains usable on compact and larger iPhone screens.

**Acceptance Scenarios**:

1. **Given** the listener is on the playlist screen, **When** they pull down from the top of the list, **Then** the screen performs a simulated refresh and returns to the refreshed state without breaking playback or selection state.
2. **Given** the listener uses the app in light or dark appearance on supported iPhone screen sizes, **When** the playlist screen loads, **Then** text, controls, active states, and floating playback bar remain readable and appropriately styled.

### Edge Cases

- If an episode record points to a local cover image or audio file that cannot be found, the episode remains visible with a safe fallback visual state and the app does not crash.
- If the listener pulls to refresh while an episode is already playing, playback continues and the active episode remains consistent after refresh completes.
- If the local metadata source contains duplicate episode identifiers or fewer than 10 valid episodes, the app rejects invalid records and surfaces only valid unique episodes while keeping the interface usable.
- If the listener taps the episode that is already active, the app preserves a single active item and does not activate a second card.
- If a tab with no episode list is selected while nothing is currently playing, the floating playback bar stays hidden.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST present a podcast playlist screen containing at least 10 valid episode items sourced from the project's local metadata files.
- **FR-002**: Each episode item MUST display a cover image, episode title, host name, duration, and a visible playback affordance.
- **FR-003**: The episode list MUST support vertical scrolling so listeners can browse all available items on supported iPhone screen sizes.
- **FR-004**: The system MUST load episode metadata from the local `data/Info` source and resolve episode media references to local bundled files rather than remote network URLs.
- **FR-005**: The system MUST allow the listener to start playback by tapping an episode item.
- **FR-006**: The system MUST ensure that only one episode can appear in the active playing state at any time.
- **FR-007**: When a new episode starts playing, the previously active episode item MUST return to its default visual state.
- **FR-008**: The active episode item MUST display a distinct visual treatment indicating that it is currently playing.
- **FR-009**: The system MUST provide a floating playback bar above the bottom navigation area whenever an episode is currently active.
- **FR-010**: The floating playback bar MUST display the current episode title and remain visible across bottom-tab navigation until playback ends or is cleared.
- **FR-011**: Playback MUST continue uninterrupted when the listener switches between bottom tabs.
- **FR-012**: The bottom navigation MUST allow switching among the podcast list and other app sections without resetting the current playback session.
- **FR-013**: The playlist screen MUST support pull-to-refresh behavior that simulates reloading local content and returns the screen to a stable refreshed state.
- **FR-014**: A refresh action MUST NOT create a second active episode or interrupt the currently playing episode unless the current media record becomes invalid.
- **FR-015**: The interface MUST remain readable and visually consistent in both light and dark appearance modes.
- **FR-016**: The interface MUST adapt to common iPhone screen sizes without clipping episode information, primary controls, bottom navigation, or the floating playback bar.
- **FR-017**: The system MUST handle missing or invalid local media references gracefully by avoiding crashes and preserving the rest of the playlist experience.
- **FR-018**: The feature MUST define explicit Model, View, ViewModel, and Controller responsibilities for episode loading, playback state, navigation persistence, and refresh behavior.
- **FR-019**: The feature MUST be implementable with SwiftUI on iOS 17+ only.
- **FR-020**: The feature MUST remain within frontend-only scope and MUST NOT require backend implementation to complete the requested work.
- **FR-021**: All variable names MUST use camelCase and end with a type suffix.
- **FR-022**: Every function introduced by the feature MUST include a documentation block with function name, accepted parameters, purpose, and return value.

### Key Entities *(include if feature involves data)*

- **Episode**: A single podcast program item presented in the playlist, including a unique identifier, title, host name, duration label, local cover reference, and local audio reference.
- **Playback Session**: The currently selected listening state, including the active episode, whether playback is currently running, and the information needed to keep the floating playback bar and selection state synchronized across tabs.
- **Playlist Collection**: The ordered set of valid episode records loaded from local metadata for presentation in the list and for refresh reconciliation.
- **Tab Destination**: A user-selectable section in the bottom navigation that determines which primary screen is visible while sharing the same playback session.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of valid local episode records are shown in the playlist with the required fields, with no fewer than 10 playable items available in the prepared sample dataset.
- **SC-002**: In usability testing, listeners can start a selected episode from the playlist in no more than 2 taps.
- **SC-003**: In playback switching tests, the interface shows no more than 1 active episode item at any moment across 100% of tap sequences.
- **SC-004**: In navigation tests, playback continues successfully across all bottom-tab switches in 100% of tested transitions.
- **SC-005**: In visual checks on supported iPhone sizes and both appearance modes, no primary content, controls, or the floating playback bar are clipped or unreadable.
- **SC-006**: In refresh tests, the screen returns from the refresh state within 2 seconds while preserving the current playback session in 100% of cases where the active media remains valid.

## Assumptions

- The local metadata file in `data/Info` can be parsed into a unique episode collection without requiring network access or user authentication.
- The prepared sample content set for this feature will include at least 10 valid local episode records with matching image and audio assets.
- Other bottom tabs may initially contain placeholder content, but they still participate in shared navigation and must not stop active playback.
- The floating playback bar for this feature only needs to show the current episode title and persistent playback presence; advanced controls beyond basic current-state indication are out of scope.
- If a local media reference is invalid, the app favors graceful degradation over blocking the entire playlist.
- The project targets a SwiftUI frontend on iOS 17+ unless the user explicitly amends the constitution.
- Feature decomposition follows MVVC and maps to Model, View, ViewModel, and Controller groups.
