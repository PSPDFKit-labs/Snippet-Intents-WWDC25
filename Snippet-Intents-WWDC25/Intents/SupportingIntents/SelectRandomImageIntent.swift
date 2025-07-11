//
//  SelectRandomBackgroundImageIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

enum PostCardSurface: String, AppEnum {
    nonisolated static let typeDisplayRepresentation: TypeDisplayRepresentation = .init(stringLiteral: "Post card surface")

    static var caseDisplayRepresentations: [PostCardSurface : DisplayRepresentation] = [
        .front: .init(stringLiteral: "Front"),
        .back: .init(stringLiteral: "Back")
    ]
    case front
    case back
}

struct SelectRandomImageIntent: AppIntent {
    static let title: LocalizedStringResource = "Select Random Image"


    @Parameter var postcard: PostcardEntity

    @Dependency var dataStore: PostcardDataStore
    @Dependency var imageService: PostcardImageService

    @Parameter(default: .back)
    private var surface: PostCardSurface

    init() {}
    
    init(postcard: PostcardEntity, surface: PostCardSurface = .back) {
        self.surface = surface
        self.postcard = postcard
    }
    
    func perform() async throws -> some IntentResult {
        guard var currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        
        // Add random background image
        currentPostcard[keyPath: surface == .back ? \PostcardDocument.backImageData : \.frontImageData] = imageService.getRandomImage()
        currentPostcard.modifiedDate = Date()

        try await dataStore.updatePostcard(currentPostcard)

        // Reload the current snippet
        surface == .back ? AddBackgroundImageSnippetIntent.reload() : AddFrontImageSnippetIntent.reload()

        return .result()
    }
} 
