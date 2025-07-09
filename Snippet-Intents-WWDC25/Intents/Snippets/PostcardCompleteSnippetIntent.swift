//
//  PostcardCompleteSnippetIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import SwiftUI

struct PostcardCompleteSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "Postcard Complete"
    
    @Parameter var postcard: PostcardEntity
    @Dependency var dataStore: PostcardDataStore
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        guard let currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        
        return .result(
            view: PostcardCompleteView(postcard: currentPostcard.toEntity)
        )
    }
}

extension PostcardCompleteSnippetIntent {
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
} 
