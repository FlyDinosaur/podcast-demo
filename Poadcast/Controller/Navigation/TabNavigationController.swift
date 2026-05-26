import Foundation
import Observation

@MainActor
@Observable
final class TabNavigationController {
    var selectedTabDestination: TabDestination

    /// Function: init(selectedTabDestination:)
    /// Parameters:
    ///   - selectedTabDestination: The initially selected app tab.
    /// Purpose: Creates the navigation coordinator that keeps the current tab selection stable.
    /// Returns: A configured `TabNavigationController` reference.
    init(selectedTabDestination: TabDestination = .podcastHome) {
        self.selectedTabDestination = selectedTabDestination
    }

    /// Function: selectTab(destination:)
    /// Parameters:
    ///   - destination: The destination that should become active.
    /// Purpose: Updates the shared tab selection for the root shell.
    /// Returns: None.
    func selectTab(destination: TabDestination) {
        selectedTabDestination = destination
    }
}
