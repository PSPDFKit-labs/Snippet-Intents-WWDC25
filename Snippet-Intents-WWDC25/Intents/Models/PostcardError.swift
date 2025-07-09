//
//  PostcardError.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import Foundation
import AppIntents

enum PostcardError: Swift.Error, CustomLocalizedStringResourceConvertible {
    case notFound
    case exportFailed
    case updateFailed
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .notFound:
            return "Postcard not found"
        case .exportFailed:
            return "Failed to export postcard"
        case .updateFailed:
            return "Failed to update postcard"
        }
    }
} 