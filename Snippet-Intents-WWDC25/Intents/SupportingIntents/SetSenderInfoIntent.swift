//
//  UpdateSenderInfoIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents

struct SetSenderInfoIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Sender Info"

    @Parameter(title: "Postcard") var postcard: PostcardEntity
    @Parameter(title: "Sender Name") var senderName: String
    
    @Dependency var dataStore: PostcardDataStore
    
    init() {}
    
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        guard var currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        // Update sender name
        currentPostcard.senderName = senderName
        currentPostcard.modifiedDate = Date()
        
        
        // Return updated view based on current stage
        try await dataStore.updatePostcard(currentPostcard)
        
        return .result(
            opensIntent: EditPostcardIntent(postcard: currentPostcard.toEntity, stage: .senderInfo)
        )
        
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Update sender name to \(\.$senderName) for \(\.$postcard)")
    }
} 
