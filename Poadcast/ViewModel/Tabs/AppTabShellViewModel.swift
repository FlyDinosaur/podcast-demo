import Foundation
import Observation

@MainActor
@Observable
final class AppTabShellViewModel {
    private let tabNavigationController: TabNavigationController
    private let playbackController: PlaybackController

    let podcastPlaylistViewModel: PodcastPlaylistViewModel
    let miniPlayerViewModel: MiniPlayerViewModel

    var selectedTabDestination: TabDestination {
        get {
            tabNavigationController.selectedTabDestination
        }
        set {
            tabNavigationController.selectTab(destination: newValue)
        }
    }

    /// Function: init()
    /// Parameters: None.
    /// Purpose: Composes the root shell dependencies shared across playlist, mini-player, and tab navigation.
    /// Returns: A configured `AppTabShellViewModel` reference.
    init() {
        let playlistDataController = PlaylistDataController()
        let localPlaylistRepository = LocalPlaylistRepository(playlistDataController: playlistDataController)
        let playbackController = PlaybackController(playlistDataController: playlistDataController)
        let playlistRefreshController = PlaylistRefreshController(localPlaylistRepository: localPlaylistRepository)
        let tabNavigationController = TabNavigationController()

        self.tabNavigationController = tabNavigationController
        self.playbackController = playbackController
        self.podcastPlaylistViewModel = PodcastPlaylistViewModel(
            localPlaylistRepository: localPlaylistRepository,
            playlistDataController: playlistDataController,
            playbackController: playbackController,
            playlistRefreshController: playlistRefreshController
        )
        self.miniPlayerViewModel = MiniPlayerViewModel(
            playbackController: playbackController,
            playlistDataController: playlistDataController
        )
        self.podcastPlaylistViewModel.onPlaybackStateChangeClosure = { [weak self] in
            self?.synchronizeSharedPlaybackState()
        }
        self.miniPlayerViewModel.onPlaybackStateChangeClosure = { [weak self] in
            self?.synchronizeSharedPlaybackState()
        }
    }

    /// Function: synchronizeSharedPlaybackState()
    /// Parameters: None.
    /// Purpose: Pushes shared playback updates into child view models that render active state.
    /// Returns: None.
    func synchronizeSharedPlaybackState() {
        podcastPlaylistViewModel.synchronizePlaybackState()
        miniPlayerViewModel.syncFromPlaybackController()
    }
}
