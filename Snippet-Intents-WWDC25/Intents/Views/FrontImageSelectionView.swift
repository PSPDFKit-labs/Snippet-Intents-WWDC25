//
//  FrontImageSelectionView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

// MARK: - Front-specific Components

struct FrontSelectionHeader: View {
    var body: some View {
        ImageSelectionHeader(
            title: "Add Front Image",
            systemImage: "photo.badge.plus",
            color: .green
        )
    }
}

struct FrontProgressIndicator: View {
    let postcard: PostcardEntity
    
    var body: some View {
        ImageProgressIndicator(postcard: postcard, color: .green)
    }
}

struct FrontImagePreview: View {
    let postcard: PostcardEntity
    
    var body: some View {
        ImagePreview(
            imageData: postcard.document.frontImageData,
            placeholderText: "No front image",
            currentImageText: "Current Front Image"
        )
    }
}

// MARK: - Main View

struct FrontImageSelectionView: View {
    let postcard: PostcardEntity
    
    var body: some View {
        VStack(spacing: 20) {
            FrontSelectionHeader()
            FrontProgressIndicator(postcard: postcard)
            FrontImagePreview(postcard: postcard)
            
            HStack(spacing: 12) {
                Button(intent: SelectRandomFrontImageIntent(postcard: postcard)) {
                    ActionButtonLabel(title: "Generate", style: .primary(.green))
                }
                .buttonStyle(.plain)
                
                Button(intent: SelectCustomImageImageIntent(postcard: postcard, surface: .front)) {
                    ActionButtonLabel(title: "Custom", style: .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .frame(maxWidth: 320)
    }
} 
