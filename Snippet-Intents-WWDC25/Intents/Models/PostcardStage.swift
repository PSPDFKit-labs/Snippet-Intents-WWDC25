//
//  PostcardStage.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import Foundation
import AppIntents

enum PostcardStage: String, CaseIterable, Codable, AppEnum {
    nonisolated static let typeDisplayRepresentation: TypeDisplayRepresentation = .init(stringLiteral: "Postcard Stage")

    static let caseDisplayRepresentations: [PostcardStage : DisplayRepresentation] = [
        .backgroundImage: .init(stringLiteral: "Background Image"),
        .frontImage: .init(stringLiteral: "Front Image"),
        .greetingText: .init(stringLiteral: "Greeting Text"),
        .senderInfo: .init(stringLiteral: "Sender Info"),
        .preview: .init(stringLiteral: "Preview"),
        .complete: .init(stringLiteral: "Complete"),
    ]

    case backgroundImage
    case frontImage
    case greetingText
    case senderInfo
    case preview
    case complete

    var displayName: String {
        switch self {
        case .backgroundImage: return "Background Image"
        case .frontImage: return "Front Image"
        case .greetingText: return "Greeting Text"
        case .senderInfo: return "Sender Info"
        case .preview: return "Preview"
        case .complete: return "Complete"
        }
    }
    
    var description: String {
        switch self {
        case .backgroundImage: return "Choose a background image for your postcard"
        case .frontImage: return "Add a decorative front image"
        case .greetingText: return "Write your greeting message"
        case .senderInfo: return "Add your name"
        case .preview: return "Your postcard is ready!"
        case .complete: return "Your postcard is complete!"
        }
    }
    
    var systemIcon: String {
        switch self {
        case .backgroundImage: return "photo.fill"
        case .frontImage: return "photo.badge.plus"
        case .greetingText: return "text.badge.plus"
        case .senderInfo: return "person.fill"
        case .preview: return "checkmark.circle.fill"
        case .complete: return "checkmark.circle.fill"
        }
    }
    
    var nextStage: PostcardStage {
        switch self {
        case .backgroundImage: return .frontImage
        case .frontImage: return .greetingText
        case .greetingText: return .senderInfo
        case .senderInfo: return .preview
        case .preview, .complete: return .complete
        }
    }
    
    var isComplete: Bool {
        return self == .complete
    }
    
    var progressValue: Double {
        switch self {
        case .backgroundImage: return 0.2
        case .frontImage: return 0.4
        case .greetingText: return 0.6
        case .senderInfo: return 0.8
        case .complete, .preview: return 1.0
        }
    }
    
} 
