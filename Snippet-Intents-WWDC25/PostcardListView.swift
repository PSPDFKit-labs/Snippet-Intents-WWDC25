//
//  PostcardListView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

struct PostcardListView: View {
    @EnvironmentObject private var dataStore: PostcardDataStore
    @State private var showingCreatePostcard = false
    @State private var newPostcardTitle = ""
    
    var body: some View {
        NavigationView {
            Group {
                if dataStore.postcards.isEmpty {
                    emptyStateView
                } else {
                    postcardListView
                }
            }
            .navigationTitle("Postcards")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingCreatePostcard = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreatePostcard) {
                createPostcardSheet
            }
            .onAppIntentExecution(ExportPostcardIntent.self) { intent in
                Task { await export(postcard: intent.target.document) }
            }
        }
        
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            
            Text("No Postcards Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create your first postcard to get started")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingCreatePostcard = true
            }) {
                Label("Create Postcard", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Postcard List
    
    private var postcardListView: some View {
        List {
            ForEach(dataStore.postcards) { postcard in
                NavigationLink(destination: PostcardView(postcard: postcard)) {
                    PostcardRowView(postcard: postcard)
                }
            }
            .onDelete(perform: deletePostcards)
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Create Postcard Sheet
    
    private var createPostcardSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Postcard Title")
                        .font(.headline)
                    
                    TextField("Enter a title for your postcard", text: $newPostcardTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                Spacer()
                
                Button(action: createPostcard) {
                    Text("Create Postcard")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(newPostcardTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .navigationTitle("New Postcard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingCreatePostcard = false
                        newPostcardTitle = ""
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func createPostcard() {
        let postcard = PostcardDocument(title: newPostcardTitle.trimmingCharacters(in: .whitespacesAndNewlines))
        
        do {
            try dataStore.addPostcard(postcard)
            showingCreatePostcard = false
            newPostcardTitle = ""
        } catch {
            print("Failed to create postcard: \(error)")
        }
    }
    
    private func deletePostcards(at offsets: IndexSet) {
        for index in offsets {
            let postcard = dataStore.postcards[index]
            do {
                try dataStore.deletePostcard(postcard)
            } catch {
                print("Failed to delete postcard: \(error)")
            }
        }
    }

    private func export(postcard: PostcardDocument) async {
        guard let pdfURL = await PostcardPDFService.shared.exportPostcard(postcard) else {
            print("Failed to export postcard: \(postcard.title)")
            return
        }

        // Share the PDF
        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }

}

// MARK: - Postcard Row View

struct PostcardRowView: View {
    let postcard: PostcardDocument
    
    var body: some View {
        HStack(spacing: 16) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 40)
                
                PostcardImageView(
                    imageData: postcard.frontImageData,
                    size: CGSize(width: 60, height: 40),
                    cornerRadius: 8,
                    placeholderIcon: "rectangle.and.pencil.and.ellipsis",
                    placeholderText: ""
                )
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(postcard.title)
                    .font(.headline)
                    .lineLimit(1)
                
                if !postcard.greetingText.isEmpty {
                    Text(postcard.greetingText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Text(postcard.modifiedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

        }
        .padding(.vertical, 4)
    }
}

