import Foundation

struct PlaylistRowState: Identifiable, Equatable {
    let episodeModel: Episode
    let isActiveBool: Bool
    let isPlayingBool: Bool
    let isCoverAvailableBool: Bool
    let isAudioAvailableBool: Bool

    var id: UUID {
        episodeModel.idUUID
    }

    var accessibilityStatusTextString: String {
        if isPlayingBool {
            return "正在播放"
        }

        if isActiveBool {
            return "已暂停"
        }

        if !isAudioAvailableBool {
            return "音频不可用"
        }

        return "可播放"
    }
}
