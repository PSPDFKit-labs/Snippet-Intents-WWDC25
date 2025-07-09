//
//  ContentView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var pendingShareURL: URL?
    @State private var showingShareSheet = false

    var body: some View {
        PostcardListView()
            .onAppear {
                checkForPendingShare()
            }
            .onChange(of: showingShareSheet) { _, newValue in
                if !newValue {
                    // Clear the pending share when sheet is dismissed
                    clearPendingShare()
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = pendingShareURL {
                    ShareSheet(activityItems: [url])
                }
            }
    }

    private func checkForPendingShare() {
        if UserDefaults.standard.bool(forKey: "shouldShowShareSheet"),
           let urlString = UserDefaults.standard.string(forKey: "pendingShareURL"),
           let url = URL(string: urlString) {

            pendingShareURL = url

            // Small delay to ensure the view is fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingShareSheet = true
            }
        }
    }



    private func clearPendingShare() {
        UserDefaults.standard.removeObject(forKey: "pendingShareURL")
        UserDefaults.standard.removeObject(forKey: "shouldShowShareSheet")
        pendingShareURL = nil
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
