//
//  PostcardView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import PhotosUI

struct PostcardView: View {
    @State var postcard: PostcardDocument
    @EnvironmentObject private var dataStore: PostcardDataStore
    @State private var isShowingBack = false
    @State private var isEditing = false
    @State private var frontImageItem: PhotosPickerItem?
    @State private var backImageItem: PhotosPickerItem?
    @State private var showingTextEditor = false
    
    
    // Standard postcard size (6" x 4" at 72 DPI)
    private let postcardSize = CGSize(width: 432, height: 288)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Postcard Container
                VStack(spacing: 24) {
                    // Postcard View with proper container
                    VStack(spacing: 0) {
                        if isShowingBack {
                            PostcardBackView(postcard: $postcard, isEditing: $isEditing, backImageItem: $backImageItem)
                        } else {
                            PostcardFrontView(postcard: $postcard, isEditing: $isEditing, frontImageItem: $frontImageItem, showingTextEditor: $showingTextEditor)
                        }
                    }
                    .frame(width: postcardSize.width * 0.85, height: postcardSize.height * 0.85)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                    .rotation3DEffect(
                        .degrees(isShowingBack ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.6), value: isShowingBack)
                    
                    // Side Indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(isShowingBack ? Color.secondary : Color.accentColor)
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(isShowingBack ? Color.accentColor : Color.secondary)
                            .frame(width: 8, height: 8)
                    }
                    .animation(.easeInOut(duration: 0.3), value: isShowingBack)
                }
                .padding(.top, 20)
                
                // Controls Section
                VStack(spacing: 24) {
                    // Flip Button
                    Button(action: {
                        isShowingBack.toggle()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isShowingBack ? "rectangle.portrait" : "rectangle.portrait.and.arrow.right")
                                .font(.title3)
                            Text(isShowingBack ? "Show Front" : "Show Back")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        //.background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: isEditing ? "checkmark" : "pencil")
                                    .font(.title3)
                                Text(isEditing ? "Done Editing" : "Edit Postcard")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundStyle(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { Task { await exportPostcard() }}) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                Text("Export as PDF")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
        }
        .navigationTitle(postcard.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .onChange(of: frontImageItem) { _, newItem in
            Task {
                if let newItem = newItem,
                   let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        postcard.frontImageData = data
                        savePostcard()
                    }
                }
            }
        }
        .onChange(of: backImageItem) { _, newItem in
            Task {
                if let newItem = newItem,
                   let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        postcard.backImageData = data
                        savePostcard()
                    }
                }
            }
        }
        .sheet(isPresented: $showingTextEditor) {
            PostcardTextEditor(postcard: $postcard, onSave: savePostcard)
        }
    }
    
    private func savePostcard() {
        postcard.modifiedDate = Date()
        try? dataStore.updatePostcard(postcard)
    }
    
    private func exportPostcard() async {
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

// MARK: - Postcard Front View

struct PostcardFrontView: View {
    @Binding var postcard: PostcardDocument
    @Binding var isEditing: Bool
    @Binding var frontImageItem: PhotosPickerItem?
    @Binding var showingTextEditor: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                
                HStack(spacing: .zero) {
                    ZStack {
                        if let frontImageData = postcard.frontImageData,
                           let uiImage = UIImage(data: frontImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width:geometry.size.width / 2, height: geometry.size.height)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.title2)
                                            .foregroundStyle(.gray)
                                        Text("Add Image")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                )
                        }
                        
                        if isEditing {
                            PhotosPicker(selection: $frontImageItem, matching: .images) {
                                Color.blue.opacity(0.3)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    )
                            }
                        }
                    }
                    
                    
                    // Right side - Greeting Text
                    ZStack {
                        VStack(alignment: .leading, spacing: 12) {
                            if postcard.greetingText.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "text.badge.plus")
                                        .font(.title2)
                                        .foregroundStyle(.gray)
                                    Text("Add Greeting")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                            } else {
                                Text(postcard.greetingText)
                                    .font(.system(size: 12, design: .serif))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding([.top])
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Text("- \(postcard.senderName)")
                                    .font(.system(size: 10, design: .serif))
                                    .italic()
                                    .foregroundStyle(.secondary)
                                    .padding([.trailing, .bottom])
                            }
                        }.padding(.leading, 12)
                        
                        if isEditing {
                            Button(action: { showingTextEditor = true }) {
                                Color.green.opacity(0.3)
                                    .overlay(
                                        Image(systemName: "pencil")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    )
                            }
                            .clipShape(Rectangle())
                            .padding(.leading, -12)
                        }
                    }
                    .frame(width: geometry.size.width * 0.5)
                }
                
            }
        }
    }
}

// MARK: - Postcard Back View

struct PostcardBackView: View {
    @Binding var postcard: PostcardDocument
    @Binding var isEditing: Bool
    @Binding var backImageItem: PhotosPickerItem?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full Background Image - no address area
                if let backImageData = postcard.backImageData,
                   let uiImage = UIImage(data: backImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(.white)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.title2)
                                    .foregroundStyle(.gray)
                                Text("Add Background")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        )
                }
                
                if isEditing {
                    PhotosPicker(selection: $backImageItem, matching: .images) {
                        Color.purple.opacity(0.3)
                            .overlay(
                                Image(systemName: "photo.fill")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Text Editors

struct PostcardTextEditor: View {
    @Binding var postcard: PostcardDocument
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var greetingText: String = ""
    @State private var senderName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Greeting Message") {
                    TextEditor(text: $greetingText)
                        .frame(minHeight: 100)
                }
                
                Section("Your Name") {
                    TextField("Sender Name", text: $senderName)
                }
            }
            .navigationTitle("Edit Text")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        postcard.greetingText = greetingText
                        postcard.senderName = senderName
                        onSave()
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            greetingText = postcard.greetingText
            senderName = postcard.senderName
        }
    }
}



