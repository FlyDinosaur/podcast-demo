import Foundation

struct PlaylistCollection: Equatable {
    var episodeArray: [Episode]
    var lastRefreshDate: Date?
    var isRefreshingBool: Bool

    /// Function: init(episodeArray:lastRefreshDate:isRefreshingBool:)
    /// Parameters:
    ///   - episodeArray: The ordered episode models rendered in the playlist.
    ///   - lastRefreshDate: The most recent successful refresh timestamp.
    ///   - isRefreshingBool: Indicates whether a refresh flow is running.
    /// Purpose: Represents the current local playlist data set and refresh state.
    /// Returns: A configured `PlaylistCollection` value.
    init(
        episodeArray: [Episode] = [],
        lastRefreshDate: Date? = nil,
        isRefreshingBool: Bool = false
    ) {
        self.episodeArray = episodeArray
        self.lastRefreshDate = lastRefreshDate
        self.isRefreshingBool = isRefreshingBool
    }
}
