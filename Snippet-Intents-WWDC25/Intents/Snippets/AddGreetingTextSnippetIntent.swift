//
//  AddGreetingTextSnippetIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import SwiftUI

struct AddGreetingTextSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "Add Greeting Text"
    
    @Parameter var postcard: PostcardEntity
    @Dependency var dataStore: PostcardDataStore
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        // Fetch latest state
        guard let currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        
        return .result(
            view: GreetingTextView(postcard: currentPostcard.toEntity)
        )
    }
}

extension AddGreetingTextSnippetIntent {
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
} 
