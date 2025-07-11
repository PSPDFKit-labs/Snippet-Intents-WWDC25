//
//  FrontImageSelectionView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

struct FrontImageSelectionView: View {
    let postcard: PostcardEntity
    
    var body: some View {
        VStack(spacing: 20) {
            ImageSelectionHeader(
                title: "Add Front Image",
                systemImage: "photo.badge.plus",
                color: .green
            )
            
            ImageProgressIndicator(postcard: postcard, color: .green)
            
            ImagePreview(
                imageData: postcard.document.frontImageData,
                placeholderText: "No front image",
                currentImageText: "Current Front Image"
            )
            
            HStack(spacing: 12) {
                Button(intent: SelectRandomImageIntent(postcard: postcard, surface: .front)) {
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
