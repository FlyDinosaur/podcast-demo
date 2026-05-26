import Foundation

enum TabDestination: String, CaseIterable, Identifiable {
    case podcastHome
    case discover
    case profile

    var id: String {
        rawValue
    }

    var titleString: String {
        switch self {
        case .podcastHome:
            return "节目"
        case .discover:
            return "发现"
        case .profile:
            return "我的"
        }
    }

    var systemImageNameString: String {
        switch self {
        case .podcastHome:
            return "music.note.list"
        case .discover:
            return "sparkles"
        case .profile:
            return "person.crop.circle"
        }
    }

    var isPodcastHomeBool: Bool {
        self == .podcastHome
    }
}
