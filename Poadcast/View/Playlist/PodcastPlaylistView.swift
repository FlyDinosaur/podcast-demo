import SwiftUI

struct PodcastPlaylistView: View {
    let podcastPlaylistViewModel: PodcastPlaylistViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                makeHeaderSection()

                if podcastPlaylistViewModel.playlistViewStateModel.isInitialLoadingBool {
                    ProgressView("正在加载节目")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 80)
                } else if let errorMessageString = podcastPlaylistViewModel.playlistViewStateModel.errorMessageString,
                          !podcastPlaylistViewModel.playlistViewStateModel.hasEpisodesBool {
                    ContentUnavailableView(
                        "节目暂时不可用",
                        systemImage: "waveform.badge.exclamationmark",
                        description: Text(errorMessageString)
                    )
                    .padding(.top, 80)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(podcastPlaylistViewModel.playlistViewStateModel.rowStateArray) { rowStateModel in
                            EpisodeRowView(rowStateModel: rowStateModel) {
                                podcastPlaylistViewModel.handleEpisodeSelection(for: rowStateModel.episodeModel)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 120)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.95, blue: 0.91),
                    Color(.systemGroupedBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("播客节目")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await podcastPlaylistViewModel.refreshPlaylist()
        }
        .task {
            await podcastPlaylistViewModel.loadPlaylistIfNeeded()
        }
    }

    /// Function: makeHeaderSection()
    /// Parameters: None.
    /// Purpose: Builds the playlist header with the latest refresh context and screen copy.
    /// Returns: A composed SwiftUI view for the screen header.
    @ViewBuilder
    private func makeHeaderSection() -> some View {
            VStack(alignment: .leading, spacing: 10) {
            Text("今天想听点什么？")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text("精选本地节目可离线播放，切换标签页时会保持当前播放状态。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let lastRefreshDate = podcastPlaylistViewModel.playlistViewStateModel.playlistCollectionModel.lastRefreshDate {
                Text("最近刷新：\(lastRefreshDate.formatted(date: .omitted, time: .shortened))")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            if let errorMessageString = podcastPlaylistViewModel.playlistViewStateModel.errorMessageString,
               podcastPlaylistViewModel.playlistViewStateModel.hasEpisodesBool {
                Label(errorMessageString, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        PodcastPlaylistView(podcastPlaylistViewModel: AppTabShellViewModel().podcastPlaylistViewModel)
    }
}
