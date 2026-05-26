import AVFoundation
import Foundation
import Observation

@MainActor
@Observable
final class PlaybackController {
    private let playlistDataController: PlaylistDataController
    private let playerObject = AVPlayer()

    private(set) var playbackSessionModel = PlaybackSession()

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
        playerObject.pause()
        playerObject.replaceCurrentItem(with: nil)
        playbackSessionModel.activeEpisodeModel = nil
        playbackSessionModel.isPlayingBool = false
    }
}
