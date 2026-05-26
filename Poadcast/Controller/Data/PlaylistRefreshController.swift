import Foundation

struct PlaylistRefreshController {
    private let localPlaylistRepository: LocalPlaylistRepository
    private let refreshDelayNanosecondsUInt64: UInt64

    /// Function: init(localPlaylistRepository:refreshDelayNanosecondsUInt64:)
    /// Parameters:
    ///   - localPlaylistRepository: The repository used to reload local playlist data.
    ///   - refreshDelayNanosecondsUInt64: The simulated refresh delay in nanoseconds.
    /// Purpose: Creates the refresh coordinator used by the playlist screen.
    /// Returns: A configured `PlaylistRefreshController` value.
    init(
        localPlaylistRepository: LocalPlaylistRepository,
        refreshDelayNanosecondsUInt64: UInt64 = 1_200_000_000
    ) {
        self.localPlaylistRepository = localPlaylistRepository
        self.refreshDelayNanosecondsUInt64 = refreshDelayNanosecondsUInt64
    }

    /// Function: refreshPlaylistCollection(lastRefreshDate:)
    /// Parameters:
    ///   - lastRefreshDate: The prior refresh timestamp used when reloading data.
    /// Purpose: Simulates pull-to-refresh before returning a newly loaded playlist collection.
    /// Returns: A refreshed `PlaylistCollection` value.
    func refreshPlaylistCollection(lastRefreshDate: Date?) async throws -> PlaylistCollection {
        try await Task.sleep(nanoseconds: refreshDelayNanosecondsUInt64)
        return try localPlaylistRepository.loadPlaylistCollection(
            lastRefreshDate: lastRefreshDate ?? Date(),
            isRefreshingBool: false
        )
    }
}
