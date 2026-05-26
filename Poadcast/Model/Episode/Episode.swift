import Foundation

struct Episode: Identifiable, Equatable, Hashable, Sendable {
    let idUUID: UUID
    let titleString: String
    let hostString: String
    let durationString: String
    let coverAssetNameString: String
    let audioAssetNameString: String

    var id: UUID {
        idUUID
    }

    /// Function: init(idUUID:titleString:hostString:durationString:coverAssetNameString:audioAssetNameString:)
    /// Parameters:
    ///   - idUUID: The stable identifier for the episode.
    ///   - titleString: The listener-facing episode title.
    ///   - hostString: The presenter name shown in the interface.
    ///   - durationString: The human-readable duration label.
    ///   - coverAssetNameString: The bundled image asset file name.
    ///   - audioAssetNameString: The bundled audio asset file name.
    /// Purpose: Creates a single local episode model from decoded metadata.
    /// Returns: A configured `Episode` value.
    init(
        idUUID: UUID,
        titleString: String,
        hostString: String,
        durationString: String,
        coverAssetNameString: String,
        audioAssetNameString: String
    ) {
        self.idUUID = idUUID
        self.titleString = titleString
        self.hostString = hostString
        self.durationString = durationString
        self.coverAssetNameString = coverAssetNameString
        self.audioAssetNameString = audioAssetNameString
    }
}
