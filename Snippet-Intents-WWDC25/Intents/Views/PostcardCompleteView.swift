//
//  PostcardCompleteView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

struct PostcardCompleteView: View {
    let postcard: PostcardEntity

    private let postcardSize = CGSize(width: UIScreen.main.bounds.width - 80, height: 120)
    
    var body: some View {
        VStack(spacing: 16) {
            // Success indicator
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.green)
            
            Text("Postcard Complete!")
                .font(.subheadline)
                .fontWeight(.bold)

            ProgressView(value: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.green)
            
            // Postcard preview with flip animation
            VStack(spacing: 12) {
                // Postcard View
                HStack(spacing: 8) {
                    PostcardBackPreview(document: postcard.document)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    PostcardFrontPreview(document: postcard.document)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
                }
                .frame(width: postcardSize.width, height: postcardSize.height)
                .background(Color.white)
                //.shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
            }
            
        }
        .padding()
        //.frame(maxWidth: 320)
    }
}

// MARK: - Postcard Preview Views

struct PostcardFrontPreview: View {
    let document: PostcardDocument
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // White background
                Color.white
                
                HStack(spacing: 0) {
                    // Left side - Front Image
                    if let frontImageData = document.frontImageData,
                       let uiImage = UIImage(data: frontImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: geometry.size.width * 0.5)
                            .overlay(
                                VStack(spacing: 4) {
                                    Image(systemName: "photo")
                                        .font(.title3)
                                        .foregroundStyle(.gray)
                                    Text("No Image")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                }
                            )
                    }
                    
                    // Right side - Greeting Text
                    VStack(alignment: .leading, spacing: 8) {
                        if document.greetingText.isEmpty {
                            Text("No greeting text")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .italic()
                        } else {
                            Text(document.greetingText)
                                .font(.system(size: 10, design: .serif))
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        
                        Spacer(minLength: 4)
                        
                        // Sender name at bottom
                        if !document.senderName.isEmpty {
                            HStack {
                                Spacer()
                                Text("- \(document.senderName)")
                                    .font(.system(size: 8, design: .serif))
                                    .italic()
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(8)
                    .frame(width: geometry.size.width * 0.5)
                }
            }
        }
    }
}

struct PostcardBackPreview: View {
    let document: PostcardDocument
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full Background Image
                if let backImageData = document.backImageData,
                   let uiImage = UIImage(data: backImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.white)
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                                Text("No Background")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                        )
                }
            }
        }
    }
} 
