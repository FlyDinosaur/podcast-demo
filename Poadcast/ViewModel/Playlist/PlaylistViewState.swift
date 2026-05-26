import Foundation

struct PlaylistViewState: Equatable {
    var playlistCollectionModel: PlaylistCollection
    var rowStateArray: [PlaylistRowState]
    var isInitialLoadingBool: Bool
    var errorMessageString: String?

    var isRefreshingBool: Bool {
        playlistCollectionModel.isRefreshingBool
    }

    var hasEpisodesBool: Bool {
        !rowStateArray.isEmpty
    }

    /// Function: init(playlistCollectionModel:rowStateArray:isInitialLoadingBool:errorMessageString:)
    /// Parameters:
    ///   - playlistCollectionModel: The currently loaded playlist data container.
    ///   - rowStateArray: The rendered row view state list.
    ///   - isInitialLoadingBool: Indicates whether the initial load is running.
    ///   - errorMessageString: The most relevant listener-facing error message.
    /// Purpose: Stores the playlist screen state used by the SwiftUI view layer.
    /// Returns: A configured `PlaylistViewState` value.
    init(
        playlistCollectionModel: PlaylistCollection = PlaylistCollection(),
        rowStateArray: [PlaylistRowState] = [],
        isInitialLoadingBool: Bool = false,
        errorMessageString: String? = nil
    ) {
        self.playlistCollectionModel = playlistCollectionModel
        self.rowStateArray = rowStateArray
        self.isInitialLoadingBool = isInitialLoadingBool
        self.errorMessageString = errorMessageString
    }
}
