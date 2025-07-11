//
//  SelectCustomImageIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation
import UniformTypeIdentifiers


struct SelectCustomImageImageIntent: AppIntent {
    static let title: LocalizedStringResource = "Select Random Background"

    @Parameter var postcard: PostcardEntity
    @Dependency var dataStore: PostcardDataStore
    @Dependency var imageService: PostcardImageService

    @Parameter(
        title: "Image File",
        description: "The File of image",
        supportedContentTypes: [.jpeg, .png, .heic, .image]
    )
    var imageFile: IntentFile

    @Parameter(default: .back)
    private var surface: PostCardSurface

    init() {}

    init(postcard: PostcardEntity, surface: PostCardSurface) {
        self.surface = surface
        self.postcard = postcard
    }

    func perform() async throws -> some IntentResult & OpensIntent {
        guard var currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }

        currentPostcard[keyPath: surface == .back ? \PostcardDocument.backImageData : \.frontImageData] = imageFile.data
        currentPostcard.modifiedDate = Date()

        try await dataStore.updatePostcard(currentPostcard)


        return .result(opensIntent: EditPostcardIntent(postcard: currentPostcard.toEntity, stage: surface == .front ? .frontImage : .backgroundImage))
    }
}
