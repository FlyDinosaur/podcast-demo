import SwiftUI

struct PodcastHomeTabView: View {
    let podcastPlaylistViewModel: PodcastPlaylistViewModel

    var body: some View {
        NavigationStack {
            PodcastPlaylistView(podcastPlaylistViewModel: podcastPlaylistViewModel)
        }
    }
}

#Preview {
    PodcastHomeTabView(podcastPlaylistViewModel: AppTabShellViewModel().podcastPlaylistViewModel)
}
