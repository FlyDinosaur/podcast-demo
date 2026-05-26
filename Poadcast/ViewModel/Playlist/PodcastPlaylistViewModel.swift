import Foundation
import Observation

@MainActor
@Observable
final class PodcastPlaylistViewModel {
    private let localPlaylistRepository: LocalPlaylistRepository
    private let playlistDataController: PlaylistDataController
    private let playbackController: PlaybackController
    private let playlistRefreshController: PlaylistRefreshController

    var onPlaybackStateChangeClosure: (() -> Void)?

    private(set) var playlistViewStateModel = PlaylistViewState()

    /// Function: init(localPlaylistRepository:playlistDataController:playbackController:playlistRefreshController:)
    /// Parameters:
    ///   - localPlaylistRepository: The repository used for initial and subsequent playlist loads.
    ///   - playlistDataController: The local asset resolver used to shape row state.
    ///   - playbackController: The shared playback coordinator.
    ///   - playlistRefreshController: The refresh coordinator used by pull-to-refresh.
    /// Purpose: Creates the playlist screen state adapter for local data and shared playback.
    /// Returns: A configured `PodcastPlaylistViewModel` reference.
    init(
        localPlaylistRepository: LocalPlaylistRepository,
        playlistDataController: PlaylistDataController,
        playbackController: PlaybackController,
        playlistRefreshController: PlaylistRefreshController
    ) {
        self.localPlaylistRepository = localPlaylistRepository
        self.playlistDataController = playlistDataController
        self.playbackController = playbackController
        self.playlistRefreshController = playlistRefreshController
    }

    /// Function: loadPlaylistIfNeeded()
    /// Parameters: None.
    /// Purpose: Loads the local playlist once for the first screen presentation.
    /// Returns: None.
    func loadPlaylistIfNeeded() async {
        guard playlistViewStateModel.rowStateArray.isEmpty, !playlistViewStateModel.isInitialLoadingBool else {
            return
        }

        playlistViewStateModel.isInitialLoadingBool = true

        do {
            let playlistCollectionModel = try localPlaylistRepository.loadPlaylistCollection()
            applyPlaylistCollection(playlistCollectionModel)
            playlistViewStateModel.errorMessageString = nil
        } catch let errorValue {
            playlistViewStateModel.errorMessageString = errorValue.localizedDescription
        }

        playlistViewStateModel.isInitialLoadingBool = false
    }

    /// Function: handleEpisodeSelection(for:)
    /// Parameters:
    ///   - episodeModel: The episode tapped by the listener.
    /// Purpose: Routes playlist row taps into the shared playback controller and refreshes row state.
    /// Returns: None.
    func handleEpisodeSelection(for episodeModel: Episode) {
        let _ = playbackController.togglePlayback(for: episodeModel)
        synchronizePlaybackState()
        onPlaybackStateChangeClosure?()
    }

    /// Function: synchronizePlaybackState()
    /// Parameters: None.
    /// Purpose: Rebuilds row state so the playlist reflects the latest shared playback session.
    /// Returns: None.
    func synchronizePlaybackState() {
        playlistViewStateModel.rowStateArray = makeRowStateArray(
            episodeArray: playlistViewStateModel.playlistCollectionModel.episodeArray,
            playbackSessionModel: playbackController.playbackSessionModel
        )
        playlistViewStateModel.errorMessageString = playbackController.playbackSessionModel.playbackErrorString
    }

    /// Function: refreshPlaylist()
    /// Parameters: None.
    /// Purpose: Reloads local playlist content while preserving valid active playback when possible.
    /// Returns: None.
    func refreshPlaylist() async {
        playlistViewStateModel.playlistCollectionModel.isRefreshingBool = true
        playlistViewStateModel.rowStateArray = makeRowStateArray(
            episodeArray: playlistViewStateModel.playlistCollectionModel.episodeArray,
            playbackSessionModel: playbackController.playbackSessionModel
        )

        do {
            let refreshedPlaylistCollectionModel = try await playlistRefreshController.refreshPlaylistCollection(
                lastRefreshDate: Date()
            )
            playbackController.reconcilePlayback(with: refreshedPlaylistCollectionModel)
            applyPlaylistCollection(refreshedPlaylistCollectionModel)
            playlistViewStateModel.errorMessageString = playbackController.playbackSessionModel.playbackErrorString
        } catch let errorValue {
            playlistViewStateModel.playlistCollectionModel.isRefreshingBool = false
            playlistViewStateModel.errorMessageString = errorValue.localizedDescription
        }

        onPlaybackStateChangeClosure?()
    }

    /// Function: applyPlaylistCollection(_:)
    /// Parameters:
    ///   - playlistCollectionModel: The playlist collection that should become the current screen state.
    /// Purpose: Commits new playlist data and rebuilds the row presentation models.
    /// Returns: None.
    private func applyPlaylistCollection(_ playlistCollectionModel: PlaylistCollection) {
        playlistViewStateModel.playlistCollectionModel = playlistCollectionModel
        synchronizePlaybackState()
    }

    /// Function: makeRowStateArray(episodeArray:playbackSessionModel:)
    /// Parameters:
    ///   - episodeArray: The episode list to render.
    ///   - playbackSessionModel: The current shared playback session.
    /// Purpose: Maps playlist and playback data into the row state consumed by the SwiftUI view layer.
    /// Returns: An ordered array of `PlaylistRowState` values.
    private func makeRowStateArray(
        episodeArray: [Episode],
        playbackSessionModel: PlaybackSession
    ) -> [PlaylistRowState] {
        episodeArray.map { episodeModel in
            let isActiveBool = playbackSessionModel.activeEpisodeModel?.idUUID == episodeModel.idUUID
            let isPlayingBool = isActiveBool && playbackSessionModel.isPlayingBool

            return PlaylistRowState(
                episodeModel: episodeModel,
                isActiveBool: isActiveBool,
                isPlayingBool: isPlayingBool,
                isCoverAvailableBool: playlistDataController.isCoverAvailable(for: episodeModel),
                isAudioAvailableBool: playlistDataController.isAudioAvailable(for: episodeModel)
            )
        }
    }
}
