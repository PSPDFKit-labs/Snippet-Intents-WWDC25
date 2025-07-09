//
//  ExportPostcardIntent.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation

struct ExportPostcardIntent: OpenIntent, TargetContentProvidingIntent {
    
    static let title: LocalizedStringResource = "Export Postcard as PDF from app"
    
    static let description = IntentDescription(
        "Exports the completed postcard as a PDF file and shows the system share sheet",
        categoryName: "Export"
    )
    
    @Parameter var target: PostcardEntity

    init() {}

    func perform() async throws -> some IntentResult {
        return .result()
    }
    
}

extension ExportPostcardIntent {
    init (target: PostcardEntity) {
        self.target = target
    }
}
