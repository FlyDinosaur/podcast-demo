import SwiftUI
import UIKit

struct MiniPlayerView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var dragOffsetY: CGFloat = 0

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
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(glassTintColor.opacity(colorScheme == .dark ? 0.22 : 0.34))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(miniPlayerBorderColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.28 : 0.08), radius: 16, x: 0, y: 10)
            .offset(y: max(0, dragOffsetY))
            .opacity(makeMiniPlayerOpacity())
            .gesture(makeDismissGesture())
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
        guard let imageURLValue = PlaylistDataController.makeResolvedBundleURL(in: .main, for: assetNameString) else {
            return nil
        }

        return UIImage(contentsOfFile: imageURLValue.path)
    }

    /// Function: miniPlayerBorderColor
    /// Parameters: None.
    /// Purpose: Provides a subtle outline that avoids bright white edges around the rounded mini-player.
    /// Returns: A `Color` value for the mini-player border.
    private var miniPlayerBorderColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.primary.opacity(0.08)
    }

    /// Function: glassTintColor
    /// Parameters: None.
    /// Purpose: Adds a soft color cast above the blur so the mini-player keeps a controlled translucent tone.
    /// Returns: A `Color` value for the glass tint overlay.
    private var glassTintColor: Color {
        colorScheme == .dark
            ? Color(red: 0.16, green: 0.18, blue: 0.24)
            : Color.white
    }

    /// Function: makeDismissGesture()
    /// Parameters: None.
    /// Purpose: Enables the listener to drag the floating mini-player downward to hide it.
    /// Returns: A configured `some Gesture` value.
    private func makeDismissGesture() -> some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .onChanged { value in
                dragOffsetY = max(0, value.translation.height)
            }
            .onEnded { value in
                let shouldDismissBool = value.translation.height > 56 || value.predictedEndTranslation.height > 96

                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                    dragOffsetY = 0
                }

                if shouldDismissBool {
                    miniPlayerViewModel.dismissMiniPlayer()
                }
            }
    }

    /// Function: makeMiniPlayerOpacity()
    /// Parameters: None.
    /// Purpose: Softens the mini-player while it is being dragged downward to dismiss.
    /// Returns: A `Double` opacity value for the floating player.
    private func makeMiniPlayerOpacity() -> Double {
        let progressValue = min(max(dragOffsetY / 120, 0), 1)
        return 1 - (progressValue * 0.24)
    }
}

#Preview {
    MiniPlayerView(miniPlayerViewModel: AppTabShellViewModel().miniPlayerViewModel)
        .padding()
}
