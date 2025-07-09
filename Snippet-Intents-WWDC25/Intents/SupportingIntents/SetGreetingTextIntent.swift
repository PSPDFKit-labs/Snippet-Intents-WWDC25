//
//  UpdateGreetingTextIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

struct SetGreetingTextIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Greeting Text"

    @Parameter var postcard: PostcardEntity
    @Parameter(title: "Greeting Text") var greetingText: String
    @Dependency var dataStore: PostcardDataStore

    init() {}
    
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
    
    func perform() async throws -> some IntentResult & OpensIntent {
        guard var currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        
        // Update greeting text
        currentPostcard.greetingText = greetingText
        currentPostcard.modifiedDate = Date()
        
        try await dataStore.updatePostcard(currentPostcard)
        
        return .result(
            opensIntent: EditPostcardIntent(postcard: currentPostcard.toEntity, stage: .greetingText)
        )
    }
} 

