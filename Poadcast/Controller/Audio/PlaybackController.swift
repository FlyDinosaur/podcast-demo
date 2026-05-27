import AVFoundation
import Foundation
import Observation

@MainActor
@Observable
final class PlaybackController {
    private let playlistDataController: PlaylistDataController
    private let playerObject = AVPlayer()
    private var playbackEndedObserverObject: NSObjectProtocol?

    var onPlaybackSessionChangeClosure: (() -> Void)?

    private(set) var playbackSessionModel = PlaybackSession() {
        didSet {
            onPlaybackSessionChangeClosure?()
        }
    }

    /// Function: init(playlistDataController:)
    /// Parameters:
    ///   - playlistDataController: The controller used to resolve bundled media URLs.
    /// Purpose: Creates the shared playback coordinator responsible for one active audio session.
    /// Returns: A configured `PlaybackController` reference.
    init(playlistDataController: PlaylistDataController) {
        self.playlistDataController = playlistDataController
    }

    /// Function: togglePlayback(for:)
    /// Parameters:
    ///   - episodeModel: The episode the listener selected from the playlist.
    /// Purpose: Plays, pauses, or switches the shared AVPlayer session based on the selected episode.
    /// Returns: `true` when the requested playback change succeeds; otherwise `false`.
    @discardableResult
    func togglePlayback(for episodeModel: Episode) -> Bool {
        if playbackSessionModel.activeEpisodeModel?.idUUID == episodeModel.idUUID {
            return toggleCurrentPlayback()
        }

        guard let audioURLValue = playlistDataController.makeAudioURL(for: episodeModel) else {
            playbackSessionModel.playbackErrorString = "当前节目缺少可播放音频。"
            return false
        }

        let playerItemObject = AVPlayerItem(url: audioURLValue)
        observePlaybackDidEnd(for: playerItemObject)
        playerObject.replaceCurrentItem(with: playerItemObject)
        playerObject.play()
        playbackSessionModel = PlaybackSession(
            activeEpisodeModel: episodeModel,
            isPlayingBool: true,
            playbackErrorString: nil
        )
        return true
    }

    /// Function: toggleCurrentPlayback()
    /// Parameters: None.
    /// Purpose: Pauses or resumes playback for the current active episode when one exists.
    /// Returns: `true` when a current session exists and was toggled; otherwise `false`.
    @discardableResult
    func toggleCurrentPlayback() -> Bool {
        guard playbackSessionModel.activeEpisodeModel != nil else {
            return false
        }

        if playbackSessionModel.isPlayingBool {
            playerObject.pause()
            playbackSessionModel.isPlayingBool = false
        } else {
            if isCurrentItemFinishedBool {
                playerObject.seek(to: .zero)
            }

            playerObject.play()
            playbackSessionModel.isPlayingBool = true
        }

        playbackSessionModel.playbackErrorString = nil
        return true
    }

    /// Function: reconcilePlayback(with:)
    /// Parameters:
    ///   - playlistCollectionModel: The latest playlist collection after a refresh or reload.
    /// Purpose: Preserves a valid active session across playlist reloads and clears invalid playback safely.
    /// Returns: None.
    func reconcilePlayback(with playlistCollectionModel: PlaylistCollection) {
        guard let activeEpisodeModel = playbackSessionModel.activeEpisodeModel else {
            return
        }

        guard let refreshedEpisodeModel = playlistCollectionModel.episodeArray.first(where: { $0.idUUID == activeEpisodeModel.idUUID }) else {
            stopPlayback()
            playbackSessionModel.playbackErrorString = "节目已从列表中移除。"
            return
        }

        guard playlistDataController.isAudioAvailable(for: refreshedEpisodeModel) else {
            stopPlayback()
            playbackSessionModel.playbackErrorString = "刷新后未找到当前节目的音频文件。"
            return
        }

        playbackSessionModel.activeEpisodeModel = refreshedEpisodeModel
    }

    /// Function: stopPlayback()
    /// Parameters: None.
    /// Purpose: Stops the shared player and clears the active playback state.
    /// Returns: None.
    func stopPlayback() {
        removePlaybackEndedObserver()
        playerObject.pause()
        playerObject.replaceCurrentItem(with: nil)
        playbackSessionModel.activeEpisodeModel = nil
        playbackSessionModel.isPlayingBool = false
    }

    /// Function: observePlaybackDidEnd(for:)
    /// Parameters:
    ///   - playerItemObject: The player item that should trigger end-of-playback reconciliation.
    /// Purpose: Watches the active AVPlayer item and updates shared state when playback naturally reaches the end.
    /// Returns: None.
    private func observePlaybackDidEnd(for playerItemObject: AVPlayerItem) {
        removePlaybackEndedObserver()
        playbackEndedObserverObject = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItemObject,
            queue: .main
        ) { [weak self] _ in
            self?.handlePlaybackDidEnd()
        }
    }

    /// Function: removePlaybackEndedObserver()
    /// Parameters: None.
    /// Purpose: Removes any observer attached to the previously active AVPlayer item.
    /// Returns: None.
    private func removePlaybackEndedObserver() {
        guard let playbackEndedObserverObject else {
            return
        }

        NotificationCenter.default.removeObserver(playbackEndedObserverObject)
        self.playbackEndedObserverObject = nil
    }

    /// Function: handlePlaybackDidEnd()
    /// Parameters: None.
    /// Purpose: Converts a natural playback finish into a paused, ready-to-replay session and rewinds the player.
    /// Returns: None.
    private func handlePlaybackDidEnd() {
        playerObject.seek(to: .zero)
        playbackSessionModel.isPlayingBool = false
        playbackSessionModel.playbackErrorString = nil
    }

    /// Function: isCurrentItemFinishedBool
    /// Parameters: None.
    /// Purpose: Indicates whether the current AVPlayer item is already at its end and should be replayed from the start.
    /// Returns: `true` when the current item has reached the end; otherwise `false`.
    private var isCurrentItemFinishedBool: Bool {
        guard let currentItemObject = playerObject.currentItem else {
            return false
        }

        let durationSecondsValue = currentItemObject.duration.seconds
        let currentTimeSecondsValue = currentItemObject.currentTime().seconds

        guard durationSecondsValue.isFinite, currentTimeSecondsValue.isFinite, durationSecondsValue > 0 else {
            return false
        }

        return currentTimeSecondsValue >= durationSecondsValue - 0.05
    }
}
