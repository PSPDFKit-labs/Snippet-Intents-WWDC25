//
//  EditPostcardIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

struct EditPostcardIntent: AppIntent {
    static let title: LocalizedStringResource = "Edit Postcard"

    static let description = IntentDescription(
        "Creates a new postcard with guided interactive setup",
        categoryName: "Document Management"
    )

    static var parameterSummary: some ParameterSummary {
        Summary("Edit an existing postcard \(\.$postcard)")
    }

    @Parameter(title: "Title", description: "The title of your new postcard")
    var postcard: PostcardEntity

    @Dependency var dataStore: PostcardDataStore

    @Parameter(title: "Postcard Stage", description: "Stage to resume editing from")
    private var currentStage: PostcardStage?

    init(){}


    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        var stage = currentStage ?? postcard.currentStage
        while stage != .complete {
            try await resumeFrom(stage: stage)
            stage = stage.nextStage
        }
        return .result(opensIntent: ExportPostcardIntent(target: postcard))
    }

    private func resumeFrom(stage: PostcardStage) async throws {

        switch stage {
        case .backgroundImage:
            try await requestConfirmation(
                actionName: .continue,
                snippetIntent: AddBackgroundImageSnippetIntent(postcard: postcard)
            )
        case .frontImage:
            try await requestConfirmation(
                actionName: .continue,
                snippetIntent: AddFrontImageSnippetIntent(postcard: postcard)
            )
        case .greetingText:
            try await requestConfirmation(
                actionName: .continue,
                snippetIntent: AddGreetingTextSnippetIntent(postcard: postcard)
            )
        case .senderInfo:
            try await requestConfirmation(
                actionName: .continue,
                snippetIntent: AddSenderInfoSnippetIntent(postcard: postcard)
            )
        case .complete, .preview:
            try await requestConfirmation(
                actionName: .share,
                snippetIntent: PostcardCompleteSnippetIntent(postcard: postcard)
            )
        }
    }
}

extension EditPostcardIntent {
    init(postcard: PostcardEntity, stage: PostcardStage? = nil) {
        self.currentStage = stage
        self.postcard = postcard
    }
}
