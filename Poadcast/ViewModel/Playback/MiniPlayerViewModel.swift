import Foundation
import Observation

@MainActor
@Observable
final class MiniPlayerViewModel {
    private let playbackController: PlaybackController
    private let playlistDataController: PlaylistDataController

    var onPlaybackStateChangeClosure: (() -> Void)?

    private(set) var activeEpisodeModel: Episode?
    private(set) var isPlayingBool: Bool
    private(set) var playbackErrorString: String?
    private(set) var isCoverAvailableBool: Bool
    private(set) var isDismissedByUserBool: Bool

    var isVisibleBool: Bool {
        activeEpisodeModel != nil && !isDismissedByUserBool
    }

    /// Function: init(playbackController:playlistDataController:)
    /// Parameters:
    ///   - playbackController: The shared playback coordinator.
    ///   - playlistDataController: The loader used to validate cover availability.
    /// Purpose: Creates the mini-player presentation state adapter for the root shell.
    /// Returns: A configured `MiniPlayerViewModel` reference.
    init(
        playbackController: PlaybackController,
        playlistDataController: PlaylistDataController
    ) {
        self.playbackController = playbackController
        self.playlistDataController = playlistDataController
        self.activeEpisodeModel = nil
        self.isPlayingBool = false
        self.playbackErrorString = nil
        self.isCoverAvailableBool = false
        self.isDismissedByUserBool = false
        syncFromPlaybackController()
    }

    /// Function: syncFromPlaybackController()
    /// Parameters: None.
    /// Purpose: Copies the latest shared playback session into mini-player presentation state.
    /// Returns: None.
    func syncFromPlaybackController() {
        let previousEpisodeID = activeEpisodeModel?.idUUID
        let playbackSessionModel = playbackController.playbackSessionModel
        activeEpisodeModel = playbackSessionModel.activeEpisodeModel
        isPlayingBool = playbackSessionModel.isPlayingBool
        playbackErrorString = playbackSessionModel.playbackErrorString
        isCoverAvailableBool = playbackSessionModel.activeEpisodeModel.map {
            playlistDataController.isCoverAvailable(for: $0)
        } ?? false

        let currentEpisodeID = activeEpisodeModel?.idUUID
        if currentEpisodeID == nil {
            isDismissedByUserBool = false
        } else if currentEpisodeID != previousEpisodeID {
            isDismissedByUserBool = false
        }
    }

    /// Function: togglePlayback()
    /// Parameters: None.
    /// Purpose: Toggles playback for the current active episode from the floating mini-player.
    /// Returns: None.
    func togglePlayback() {
        _ = playbackController.toggleCurrentPlayback()
        syncFromPlaybackController()
        onPlaybackStateChangeClosure?()
    }

    /// Function: dismissMiniPlayer()
    /// Parameters: None.
    /// Purpose: Hides the mini-player until playback switches to another episode or the current session ends.
    /// Returns: None.
    func dismissMiniPlayer() {
        guard activeEpisodeModel != nil else {
            return
        }

        isDismissedByUserBool = true
    }
}
