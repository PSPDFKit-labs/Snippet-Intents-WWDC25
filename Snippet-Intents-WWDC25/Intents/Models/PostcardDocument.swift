//
//  PostcardDocumentNew.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import Foundation
import SwiftUI

struct PostcardDocument: Identifiable, Codable {
    let id: String
    var title: String
    var frontImageData: Data?
    var backImageData: Data?
    var greetingText: String
    var senderName: String
    var createdDate: Date
    var modifiedDate: Date
    var isComplete: Bool
    var fileName: String

    
    var fileURL: URL {
        PostcardDataStore.documentsDirectory.appendingPathComponent(fileName)
    }
    
    
    var progressPercentage: Double {
        return currentStage.progressValue
    }

    
    var currentStage: PostcardStage {
        let isGreetingsEmpty = greetingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if backImageData == nil || frontImageData == nil {
            return .backgroundImage
        }
        if frontImageData != nil && isGreetingsEmpty {
            return .frontImage
        }
        if isGreetingsEmpty {
            return .greetingText
        }
        if senderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .senderInfo
        }
        return .preview
    }
}

// MARK: - Extensions

extension PostcardDocument {
    var toEntity: PostcardEntity {
        return PostcardEntity(document: self)
    }
    
    init(title: String, greetingText: String = "", senderName: String = "") {
        self.id = UUID().uuidString
        self.title = title
        self.greetingText = greetingText
        self.senderName = senderName
        self.createdDate = Date()
        self.modifiedDate = Date()
        self.isComplete = false
        self.fileName = "\(title.replacingOccurrences(of: " ", with: "_"))_new_\(id).json"
    }
}
