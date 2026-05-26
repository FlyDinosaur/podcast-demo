import Foundation

struct LocalPlaylistRepository {
    private let playlistDataController: PlaylistDataController

    /// Function: init(playlistDataController:)
    /// Parameters:
    ///   - playlistDataController: The controller responsible for decoding local playlist resources.
    /// Purpose: Creates a repository wrapper around local bundled playlist data.
    /// Returns: A configured `LocalPlaylistRepository` value.
    init(playlistDataController: PlaylistDataController) {
        self.playlistDataController = playlistDataController
    }

    /// Function: loadPlaylistCollection(lastRefreshDate:isRefreshingBool:)
    /// Parameters:
    ///   - lastRefreshDate: The latest refresh timestamp to preserve in the returned collection.
    ///   - isRefreshingBool: The refresh state to apply to the returned collection.
    /// Purpose: Loads the current playlist collection from bundled local resources.
    /// Returns: A fully populated `PlaylistCollection` value.
    func loadPlaylistCollection(
        lastRefreshDate: Date? = nil,
        isRefreshingBool: Bool = false
    ) throws -> PlaylistCollection {
        let episodeArray = try playlistDataController.loadEpisodeArray()
        return PlaylistCollection(
            episodeArray: episodeArray,
            lastRefreshDate: lastRefreshDate,
            isRefreshingBool: isRefreshingBool
        )
    }
}
