import SwiftUI
import UIKit

struct MiniPlayerView: View {
    let miniPlayerViewModel: MiniPlayerViewModel

    var body: some View {
        if let activeEpisodeModel = miniPlayerViewModel.activeEpisodeModel {
            HStack(spacing: 14) {
                makeArtworkView(
                    episodeModel: activeEpisodeModel,
                    isCoverAvailableBool: miniPlayerViewModel.isCoverAvailableBool
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(activeEpisodeModel.titleString)
                        .font(.headline)
                        .lineLimit(1)

                    Text(miniPlayerViewModel.playbackErrorString ?? activeEpisodeModel.hostString)
                        .font(.subheadline)
                        .foregroundStyle(miniPlayerViewModel.playbackErrorString == nil ? Color.secondary : Color.orange)
                        .lineLimit(1)
                }

                Spacer(minLength: 12)

                Button(action: miniPlayerViewModel.togglePlayback) {
                    Image(systemName: miniPlayerViewModel.isPlayingBool ? "pause.fill" : "play.fill")
                        .font(.title3.weight(.bold))
                        .frame(width: 42, height: 42)
                        .background(.thinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(miniPlayerViewModel.isPlayingBool ? "暂停播放" : "继续播放")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 10)
        }
    }

    /// Function: makeArtworkView(episodeModel:isCoverAvailableBool:)
    /// Parameters:
    ///   - episodeModel: The episode currently shown by the mini-player.
    ///   - isCoverAvailableBool: Indicates whether a bundled cover image exists.
    /// Purpose: Builds the mini-player artwork with graceful placeholder fallback.
    /// Returns: A styled SwiftUI view for the artwork slot.
    @ViewBuilder
    private func makeArtworkView(
        episodeModel: Episode,
        isCoverAvailableBool: Bool
    ) -> some View {
        if isCoverAvailableBool, let coverImageValue = makeCoverUIImage(for: episodeModel.coverAssetNameString) {
            Image(uiImage: coverImageValue)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.7), Color.red.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "waveform")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                )
        }
    }

    /// Function: makeCoverUIImage(for:)
    /// Parameters:
    ///   - assetNameString: The bundled cover asset name to resolve.
    /// Purpose: Loads a local cover image from the application bundle for display.
    /// Returns: A `UIImage` when the asset is found; otherwise `nil`.
    private func makeCoverUIImage(for assetNameString: String) -> UIImage? {
        let assetPathString = assetNameString as NSString
        let fileNameString = assetPathString.deletingPathExtension
        let fileExtensionString = assetPathString.pathExtension

        guard let imageURLValue = Bundle.main.url(
            forResource: fileNameString,
            withExtension: fileExtensionString.isEmpty ? nil : fileExtensionString
        ) else {
            return nil
        }

        return UIImage(contentsOfFile: imageURLValue.path)
    }
}

#Preview {
    MiniPlayerView(miniPlayerViewModel: AppTabShellViewModel().miniPlayerViewModel)
        .padding()
}
