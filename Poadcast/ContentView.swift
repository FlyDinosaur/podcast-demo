//
//  ContentView.swift
//  Poadcast
//
//  Created by FlyDinosaur on 2026/5/26.
//

import SwiftUI

struct ContentView: View {
    let appTabShellViewModel: AppTabShellViewModel

    var body: some View {
        AppTabShellView(appTabShellViewModel: appTabShellViewModel)
    }
}

#Preview {
    ContentView(appTabShellViewModel: AppTabShellViewModel())
}
