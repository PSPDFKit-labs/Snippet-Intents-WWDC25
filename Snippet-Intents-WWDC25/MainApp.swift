//
//  Snippet_Intents_WWDC25App.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

@main
struct MainApp: App {
    @State private var dataStore = PostcardDataStore()
    private var imageService: PostcardImageService!

    init() {
        let intentDataStore = dataStore
        let imageService = PostcardImageService()
        AppDependencyManager.shared.add(dependency: intentDataStore)
        AppDependencyManager.shared.add(dependency: imageService)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}

struct Shortcuts: AppShortcutsProvider {
    /// The app shortcuts to expose to the system
    static var appShortcuts: [AppShortcut] {

        AppShortcut(
            intent: CreatePostcardIntent(),
            phrases: [
                "Create a new postcard in \(.applicationName)",
                "Start a new postcard in \(.applicationName)",
                "New postcard in \(.applicationName)"
            ],
            shortTitle: "Interactive Postcard",
            systemImageName: "wand.and.sparkles"
        )


    }
}
