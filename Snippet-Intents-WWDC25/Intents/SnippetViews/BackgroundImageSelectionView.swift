//
//  BackgroundImageSelectionView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

struct BackgroundImageSelectionView: View {
    let postcard: PostcardDocument
    
    var body: some View {
        VStack(spacing: 20) {
            ImageSelectionHeader(
                title: "Add Background Image",
                systemImage: "photo.fill",
                color: .blue
            )
            
            ImageProgressIndicator(postcard: postcard, color: .blue)
            
            ImagePreview(
                imageData: postcard.backImageData,
                placeholderText: "No background selected",
                currentImageText: "Current Background"
            )
            
            HStack(spacing: 12) {
                Button(intent: SelectRandomImageIntent(postcard: postcard.toEntity, surface: .back)) {
                    ActionButtonLabel(title: "Generate", style: .primary(.blue))
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
