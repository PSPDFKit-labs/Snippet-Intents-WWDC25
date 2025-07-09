//
//  SharedImageSelectionComponents.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

// MARK: - Shared Components

struct ImageSelectionHeader: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 32))
                .foregroundStyle(color)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct ImageProgressIndicator: View {
    let progressValue: Double
    let color: Color
    
    init(postcard: PostcardDocument, color: Color) {
        self.progressValue = postcard.currentStage.progressValue
        self.color = color
    }
    
    init(postcard: PostcardEntity, color: Color) {
        self.progressValue = postcard.currentStage.progressValue
        self.color = color
    }
    
    var body: some View {
        ProgressView(value: progressValue)
            .progressViewStyle(LinearProgressViewStyle())
            .tint(color)
    }
}

struct ImagePreview: View {
    let imageData: Data?
    let placeholderText: String
    let currentImageText: String
    
    var body: some View {
        if let imageData = imageData,
           let image = UIImage(data: imageData) {
            VStack(spacing: 8) {
                Text(currentImageText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.1))
                .frame(width: 250, height: 120)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.badge.plus")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        Text(placeholderText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
}

enum ActionButtonStyle {
    case primary(Color = .blue)
    case secondary
    
    func backgroundColor(for color: Color = .blue) -> Color {
        switch self {
        case .primary(let primaryColor):
            return primaryColor.opacity(0.1)
        case .secondary:
            return .gray.opacity(0.1)
        }
    }
    
    func foregroundColor(for color: Color = .blue) -> Color {
        switch self {
        case .primary(let primaryColor):
            return primaryColor
        case .secondary:
            return .primary
        }
    }
}

struct ActionButtonLabel: View {
    let title: String
    let systemImage: String
    let style: ActionButtonStyle
    
    init(title: String, style: ActionButtonStyle) {
        self.title = title
        self.style = style
        switch style {
        case .primary:
            self.systemImage = "shuffle"
        case .secondary:
            self.systemImage = "folder"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(style.backgroundColor())
        .foregroundStyle(style.foregroundColor())
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
} 
