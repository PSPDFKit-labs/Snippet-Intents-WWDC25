//
//  BackgroundImageSelectionView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

// MARK: - Background-specific Components

struct BackgroundSelectionHeader: View {
    var body: some View {
        ImageSelectionHeader(
            title: "Add Background Image",
            systemImage: "photo.fill",
            color: .blue
        )
    }
}

struct BackgroundProgressIndicator: View {
    let postcard: PostcardDocument
    
    var body: some View {
        ImageProgressIndicator(postcard: postcard, color: .blue)
    }
}

struct BackgroundImagePreview: View {
    let postcard: PostcardDocument
    
    var body: some View {
        ImagePreview(
            imageData: postcard.backImageData,
            placeholderText: "No background selected",
            currentImageText: "Current Background"
        )
    }
}

// MARK: - Main View

struct BackgroundImageSelectionView: View {
    let postcard: PostcardDocument
    
    var body: some View {
        VStack(spacing: 20) {
            BackgroundSelectionHeader()
            BackgroundProgressIndicator(postcard: postcard)
            BackgroundImagePreview(postcard: postcard)
            
            HStack(spacing: 12) {
                Button(intent: SelectRandomImageIntent(postcard: postcard.toEntity, surface: .back)) {
                    ActionButtonLabel(title: "Generate", style: .primary())
                }
                .buttonStyle(.plain)
                
                Button(intent: SelectCustomImageImageIntent(postcard: postcard.toEntity, surface: .back)) {
                    ActionButtonLabel(title: "Custom", style: .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .frame(maxWidth: 320)
    }
} 
