import SwiftUI

struct AppTabShellView: View {
    let appTabShellViewModel: AppTabShellViewModel

    var body: some View {
        @Bindable var bindableShellViewModel = appTabShellViewModel

        TabView(selection: $bindableShellViewModel.selectedTabDestination) {
            PodcastHomeTabView(podcastPlaylistViewModel: appTabShellViewModel.podcastPlaylistViewModel)
                .tabItem {
                    Label(TabDestination.podcastHome.titleString, systemImage: TabDestination.podcastHome.systemImageNameString)
                }
                .tag(TabDestination.podcastHome)

            DiscoverPlaceholderView()
                .tabItem {
                    Label(TabDestination.discover.titleString, systemImage: TabDestination.discover.systemImageNameString)
                }
                .tag(TabDestination.discover)

            ProfilePlaceholderView()
                .tabItem {
                    Label(TabDestination.profile.titleString, systemImage: TabDestination.profile.systemImageNameString)
                }
                .tag(TabDestination.profile)
        }
        .overlay(alignment: .bottom) {
            if appTabShellViewModel.miniPlayerViewModel.isVisibleBool {
                MiniPlayerView(miniPlayerViewModel: appTabShellViewModel.miniPlayerViewModel)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 84)
            }
        }
        .onAppear {
            appTabShellViewModel.synchronizeSharedPlaybackState()
        }
        .onChange(of: bindableShellViewModel.selectedTabDestination) { _, _ in
            appTabShellViewModel.synchronizeSharedPlaybackState()
        }
    }
}

#Preview {
    AppTabShellView(appTabShellViewModel: AppTabShellViewModel())
}
