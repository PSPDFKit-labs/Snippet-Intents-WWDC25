//
//  OpenPostcardInAppIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

struct OpenPostcardInAppIntent: AppIntent {
    static let title: LocalizedStringResource = "Open in App"
    
    static let description = IntentDescription(
        "Opens the postcard in the main app for continued editing",
        categoryName: "Navigation"
    )
    
    @Parameter var postcard: PostcardEntity
    
    init() {}
    
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
    
    func perform() async throws -> some IntentResult & OpensIntent {
        // The app will handle opening to the correct postcard via userActivity or URL scheme
        return .result(value: true)
    }
} 
