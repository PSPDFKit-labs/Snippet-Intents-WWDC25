//
//  CreatePostcardIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

struct CreatePostcardIntent: AppIntent {
    static let title: LocalizedStringResource = "Create Postcard"
    
    static let description = IntentDescription(
        "Creates a new postcard with guided interactive setup",
        categoryName: "Document Management"
    )

    static var parameterSummary: some ParameterSummary {
        Summary("Create a new postcard named \(\.$title)")
    }

    @Parameter(title: "Title", description: "The title of your new postcard")
    var title: String

    @Dependency var dataStore: PostcardDataStore
    
    init(){}
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // Create the postcard document
        let postcard = PostcardDocument(title: title)
        
        // Save to data store
        try await dataStore.addPostcard(postcard)
        
        try await requestConfirmation(
            actionName: .continue,
                            snippetIntent: AddBackgroundImageSnippetIntent(postcard: postcard.toEntity)
        )
        
        try await requestConfirmation(
            actionName: .continue,
                            snippetIntent: AddFrontImageSnippetIntent(postcard: postcard.toEntity)
        )

        try await requestConfirmation(
            actionName: .continue,
                            snippetIntent: AddGreetingTextSnippetIntent(postcard: postcard.toEntity)
        )

        return .result()
    }
} 

