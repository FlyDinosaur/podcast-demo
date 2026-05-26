//
//  PoadcastApp.swift
//  Poadcast
//
//  Created by FlyDinosaur on 2026/5/26.
//

import SwiftUI

@main
struct PoadcastApp: App {
    @State private var appTabShellViewModel = AppTabShellViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(appTabShellViewModel: appTabShellViewModel)
        }
    }
}
