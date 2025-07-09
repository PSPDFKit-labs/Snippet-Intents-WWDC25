//
//  SelectRandomFrontImageIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

struct SelectRandomFrontImageIntent: AppIntent {
    static let title: LocalizedStringResource = "Select Random Front Image"
    
    @Parameter var postcard: PostcardEntity
    @Dependency var dataStore: PostcardDataStore
    @Dependency var imageService: PostcardImageService
    
    init() {}
    
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
    
    func perform() async throws -> some IntentResult {
        guard var currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        
        // Add random front image
        currentPostcard.frontImageData = imageService.getRandomImage()
        currentPostcard.modifiedDate = Date()
        
        try await dataStore.updatePostcard(currentPostcard)
        
        // Reload the current snippet
        AddFrontImageSnippetIntent.reload()
        
        return .result()
    }
} 
