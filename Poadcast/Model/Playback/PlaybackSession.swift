import Foundation

struct PlaybackSession: Equatable {
    var activeEpisodeModel: Episode?
    var isPlayingBool: Bool
    var playbackErrorString: String?

    /// Function: init(activeEpisodeModel:isPlayingBool:playbackErrorString:)
    /// Parameters:
    ///   - activeEpisodeModel: The currently selected episode, if any.
    ///   - isPlayingBool: Indicates whether the shared player is actively playing.
    ///   - playbackErrorString: A safe-to-display playback error message.
    /// Purpose: Builds the shared playback session state observed throughout the app.
    /// Returns: A configured `PlaybackSession` value.
    init(
        activeEpisodeModel: Episode? = nil,
        isPlayingBool: Bool = false,
        playbackErrorString: String? = nil
    ) {
        self.activeEpisodeModel = activeEpisodeModel
        self.isPlayingBool = isPlayingBool
        self.playbackErrorString = playbackErrorString
    }
}
