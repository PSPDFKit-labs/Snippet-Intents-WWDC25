//
//  AddSenderInfoSnippetIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import SwiftUI

struct AddSenderInfoSnippetIntent: AppIntent & SnippetIntent {
    static let title: LocalizedStringResource = "Add Sender Info"
    
    @Parameter(title: "Postcard") var postcard: PostcardEntity
    @Dependency var dataStore: PostcardDataStore
    
    init() {}
    
    init(postcard: PostcardEntity) {
        self.postcard = postcard
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        // Fetch latest state
        guard let currentPostcard = await dataStore.getPostcard(by: postcard.id) else {
            throw PostcardError.notFound
        }
        
        return .result(
            dialog: IntentDialog("Add your name to the postcard"),
            view: SenderInfoInputView(postcard: currentPostcard.toEntity)
        )
    }
}

extension AddSenderInfoSnippetIntent {
    @MainActor
    static func reload() {
        // ControlCenter.shared.reloadAllControls()
    }
} 
