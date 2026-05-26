import Foundation

enum PlaylistDataControllerError: LocalizedError {
    case missingMetadataFile
    case invalidMetadata

    var errorDescription: String? {
        switch self {
        case .missingMetadataFile:
            return "未找到本地节目数据文件。"
        case .invalidMetadata:
            return "节目数据格式无效。"
        }
    }
}

struct PlaylistDataController {
    private let bundleValue: Bundle
    private let decoderJSON: JSONDecoder

    /// Function: init(bundleValue:decoderJSON:)
    /// Parameters:
    ///   - bundleValue: The bundle that stores the podcast metadata and media assets.
    ///   - decoderJSON: The JSON decoder used for the metadata file.
    /// Purpose: Creates the resource loader used by repository and playback coordination layers.
    /// Returns: A configured `PlaylistDataController` value.
    init(bundleValue: Bundle = .main, decoderJSON: JSONDecoder = JSONDecoder()) {
        self.bundleValue = bundleValue
        self.decoderJSON = decoderJSON
    }

    /// Function: loadEpisodeArray()
    /// Parameters: None.
    /// Purpose: Decodes the bundled metadata file into episode domain models.
    /// Returns: An ordered array of `Episode` values.
    func loadEpisodeArray() throws -> [Episode] {
        let metadataURLValue = bundleValue.url(forResource: "info", withExtension: "json")
            ?? bundleValue.url(forResource: "info", withExtension: "json", subdirectory: "Info")
            ?? bundleValue.url(forResource: "info", withExtension: "json", subdirectory: "data/Info")

        guard let metadataURLValue else {
            throw PlaylistDataControllerError.missingMetadataFile
        }

        let metadataData = try Data(contentsOf: metadataURLValue)

        do {
            let payloadArray = try decoderJSON.decode([EpisodePayload].self, from: metadataData)
            return payloadArray.map(makeEpisodeModel(from:))
        } catch let decodingErrorValue {
            _ = decodingErrorValue
            throw PlaylistDataControllerError.invalidMetadata
        }
    }

    /// Function: makeImageURL(for:)
    /// Parameters:
    ///   - episodeModel: The episode whose cover asset should be resolved.
    /// Purpose: Locates a bundled cover image URL for the provided episode if it exists.
    /// Returns: A bundled image `URL`, or `nil` when the asset cannot be found.
    func makeImageURL(for episodeModel: Episode) -> URL? {
        makeBundleURL(for: episodeModel.coverAssetNameString)
    }

    /// Function: makeAudioURL(for:)
    /// Parameters:
    ///   - episodeModel: The episode whose audio asset should be resolved.
    /// Purpose: Locates a bundled audio file URL for the provided episode if it exists.
    /// Returns: A bundled audio `URL`, or `nil` when the asset cannot be found.
    func makeAudioURL(for episodeModel: Episode) -> URL? {
        makeBundleURL(for: episodeModel.audioAssetNameString)
    }

    /// Function: isCoverAvailable(for:)
    /// Parameters:
    ///   - episodeModel: The episode whose cover asset should be checked.
    /// Purpose: Indicates whether a local cover image is available in the bundle.
    /// Returns: `true` when the cover image exists; otherwise `false`.
    func isCoverAvailable(for episodeModel: Episode) -> Bool {
        makeImageURL(for: episodeModel) != nil
    }

    /// Function: isAudioAvailable(for:)
    /// Parameters:
    ///   - episodeModel: The episode whose audio asset should be checked.
    /// Purpose: Indicates whether a local audio file is available in the bundle.
    /// Returns: `true` when the audio file exists; otherwise `false`.
    func isAudioAvailable(for episodeModel: Episode) -> Bool {
        makeAudioURL(for: episodeModel) != nil
    }

    /// Function: makeEpisodeModel(from:)
    /// Parameters:
    ///   - payloadModel: The decoded metadata payload for one episode.
    /// Purpose: Normalizes metadata paths into the domain episode model used by the app.
    /// Returns: A configured `Episode` value.
    private func makeEpisodeModel(from payloadModel: EpisodePayload) -> Episode {
        Episode(
            idUUID: payloadModel.idUUID,
            titleString: payloadModel.titleString,
            hostString: payloadModel.hostString,
            durationString: payloadModel.durationString,
            coverAssetNameString: makeNormalizedAssetNameString(from: payloadModel.coverImageURLString),
            audioAssetNameString: makeNormalizedAssetNameString(from: payloadModel.audioURLString)
        )
    }

    /// Function: makeBundleURL(for:)
    /// Parameters:
    ///   - assetNameString: The stored asset path or file name from the playlist metadata.
    /// Purpose: Resolves a file name against the application bundle using either direct path or base name lookup.
    /// Returns: A bundled file `URL`, or `nil` when lookup fails.
    private func makeBundleURL(for assetNameString: String) -> URL? {
        let normalizedAssetNameString = makeNormalizedAssetNameString(from: assetNameString)
        let assetPathString = normalizedAssetNameString as NSString
        let fileNameString = assetPathString.deletingPathExtension
        let fileExtensionString = assetPathString.pathExtension
        let subdirectoryArray = normalizedAssetNameString
            .split(separator: "/")
            .dropLast()
            .map(String.init)
        let subdirectoryString = subdirectoryArray.isEmpty ? nil : subdirectoryArray.joined(separator: "/")

        if let directURLValue = bundleValue.url(
            forResource: fileNameString,
            withExtension: fileExtensionString.isEmpty ? nil : fileExtensionString,
            subdirectory: subdirectoryString
        ) {
            return directURLValue
        }

        return bundleValue.url(
            forResource: fileNameString,
            withExtension: fileExtensionString.isEmpty ? nil : fileExtensionString
        )
    }

    /// Function: makeNormalizedAssetNameString(from:)
    /// Parameters:
    ///   - rawPathString: The raw asset path value decoded from the playlist metadata.
    /// Purpose: Converts bundle-relative metadata paths into clean bundle lookup names.
    /// Returns: A normalized asset path string.
    private func makeNormalizedAssetNameString(from rawPathString: String) -> String {
        var normalizedPathString = rawPathString.trimmingCharacters(in: .whitespacesAndNewlines)

        while normalizedPathString.hasPrefix("/") {
            normalizedPathString.removeFirst()
        }

        return normalizedPathString
    }
}

private struct EpisodePayload: Decodable {
    let idUUID: UUID
    let titleString: String
    let hostString: String
    let durationString: String
    let coverImageURLString: String
    let audioURLString: String

    private enum CodingKeys: String, CodingKey {
        case idUUID = "id"
        case titleString = "title"
        case hostString = "host"
        case durationString = "duration"
        case coverImageURLString = "coverImageURL"
        case audioURLString = "audioURL"
    }
}
