import SwiftUI
import UIKit

struct EpisodeRowView: View {
    @Environment(\.colorScheme) private var colorScheme

    let rowStateModel: PlaylistRowState
    let onTapAction: () -> Void

    var body: some View {
        Button(action: onTapAction) {
            HStack(spacing: 16) {
                makeArtworkView()

                VStack(alignment: .leading, spacing: 8) {
                    Text(rowStateModel.episodeModel.titleString)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    Text(rowStateModel.episodeModel.hostString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    HStack(spacing: 10) {
                        Label(rowStateModel.episodeModel.durationString, systemImage: "clock")
                            .font(.caption.weight(.medium))

                        if !rowStateModel.isAudioAvailableBool {
                            Label("音频缺失", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.orange)
                        } else if rowStateModel.isPlayingBool {
                            Label("播放中", systemImage: "waveform")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.pink)
                        } else if rowStateModel.isActiveBool {
                            Label("已暂停", systemImage: "pause.circle")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Spacer(minLength: 12)

                Image(systemName: rowStateModel.isPlayingBool ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(rowStateModel.isAudioAvailableBool ? .primary : .secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(makeBackgroundStyle())
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(makeBorderColor(), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(rowStateModel.episodeModel.titleString)，\(rowStateModel.accessibilityStatusTextString)")
    }

    /// Function: makeArtworkView()
    /// Parameters: None.
    /// Purpose: Builds the row artwork view with a bundled image or placeholder fallback.
    /// Returns: A styled SwiftUI view for the artwork slot.
    @ViewBuilder
    private func makeArtworkView() -> some View {
        if rowStateModel.isCoverAvailableBool,
           let coverImageValue = makeCoverUIImage(for: rowStateModel.episodeModel.coverAssetNameString) {
            Image(uiImage: coverImageValue)
                .resizable()
                .scaledToFill()
                .frame(width: 74, height: 74)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        } else {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.75), Color(red: 0.87, green: 0.31, blue: 0.27)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 74, height: 74)
                .overlay(
                    Image(systemName: "mic.fill")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.92))
                )
        }
    }

    /// Function: makeBackgroundStyle()
    /// Parameters: None.
    /// Purpose: Selects the row background styling for active and inactive playback states.
    /// Returns: A SwiftUI shape style used by the row background.
    private func makeBackgroundStyle() -> AnyShapeStyle {
        if rowStateModel.isActiveBool {
            return AnyShapeStyle(
                LinearGradient(
                    colors: colorScheme == .dark ? [
                        Color.orange.opacity(0.24),
                        Color.red.opacity(0.18),
                    ] : [
                        Color.orange.opacity(0.18),
                        Color.red.opacity(0.08),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }

        return AnyShapeStyle(
            colorScheme == .dark
                ? Color(red: 0.12, green: 0.13, blue: 0.16)
                : Color(.secondarySystemGroupedBackground)
        )
    }

    /// Function: makeBorderColor()
    /// Parameters: None.
    /// Purpose: Selects a border color that stays visible without creating a bright halo in dark mode.
    /// Returns: A `Color` value for the row outline.
    private func makeBorderColor() -> Color {
        if rowStateModel.isActiveBool {
            return colorScheme == .dark ? Color.orange.opacity(0.42) : Color.orange.opacity(0.55)
        }

        return colorScheme == .dark ? Color.white.opacity(0.08) : Color.primary.opacity(0.06)
    }

    /// Function: makeCoverUIImage(for:)
    /// Parameters:
    ///   - assetNameString: The bundled cover asset name to resolve.
    /// Purpose: Loads a local cover image from the application bundle for row rendering.
    /// Returns: A `UIImage` when the asset is found; otherwise `nil`.
    private func makeCoverUIImage(for assetNameString: String) -> UIImage? {
        guard let imageURLValue = PlaylistDataController.makeResolvedBundleURL(in: .main, for: assetNameString) else {
            return nil
        }

        return UIImage(contentsOfFile: imageURLValue.path)
    }
}

#Preview {
    let episodeModel = Episode(
        idUUID: UUID(),
        titleString: "预览节目",
        hostString: "主播 小林",
        durationString: "00:08",
        coverAssetNameString: "data/Image/Image01.png",
        audioAssetNameString: "data/Audio/test01.wav"
    )
    let rowStateModel = PlaylistRowState(
        episodeModel: episodeModel,
        isActiveBool: true,
        isPlayingBool: true,
        isCoverAvailableBool: false,
        isAudioAvailableBool: true
    )

    return EpisodeRowView(rowStateModel: rowStateModel, onTapAction: {})
        .padding()
}
