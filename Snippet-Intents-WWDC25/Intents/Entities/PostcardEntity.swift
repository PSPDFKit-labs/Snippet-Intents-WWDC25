//
//  PostcardEntityNew.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import AppIntents
import Foundation
import SwiftUI

struct PostcardEntity: AppEntity {
    nonisolated static let typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(
        name: "New Postcard",
        numericFormat: "\(placeholder: .int) new postcards"
    )
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: "Stage: \(currentStage.displayName)",
            image: .init(systemName: currentStage.systemIcon)
        )
    }
    
    static let defaultQuery = PostcardEntityQuery()
    
    @ComputedProperty
    nonisolated var id: String {
        document.id
    }
    
    @ComputedProperty
    var title: String {
        document.title
    }
    
    var currentStage: PostcardStage {
        document.currentStage
    }
    
    @ComputedProperty
    var greetingText: String {
        document.greetingText
    }
    
    @ComputedProperty
    var senderName: String {
        document.senderName
    }
    
    @ComputedProperty
    var isComplete: Bool {
        document.isComplete
    }
    
    // Internal document reference
    var document: PostcardDocument
    
    init(document: PostcardDocument) {
        self.document = document
    }
}

// MARK: - Entity Query


struct PostcardEntityQuery: EntityQuery, EntityStringQuery, EnumerableEntityQuery {
    @Dependency var dataStore: PostcardDataStore
    
    func entities(for identifiers: [PostcardEntity.ID]) async throws -> [PostcardEntity] {
        dataStore.loadPostcards()
        return dataStore.postcards
            .filter { identifiers.contains($0.id) }
            .map { $0.toEntity }
    }
    
    func suggestedEntities() async throws -> [PostcardEntity] {
        dataStore.loadPostcards()
        return Array(dataStore.postcards.prefix(5)).map { $0.toEntity }
    }
    
    func entities(matching string: String) async throws -> [PostcardEntity] {
        dataStore.loadPostcards()
        guard !string.isEmpty else { return dataStore.postcards.map { $0.toEntity } }
        
        return dataStore.postcards.filter { postcard in
            postcard.title.localizedCaseInsensitiveContains(string) ||
            postcard.greetingText.localizedCaseInsensitiveContains(string) ||
            postcard.senderName.localizedCaseInsensitiveContains(string)
        }.map { $0.toEntity }
    }
    
    func allEntities() async throws -> [PostcardEntity] {
        dataStore.loadPostcards()
        return dataStore.postcards.map { $0.toEntity }
    }
} 
