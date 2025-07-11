//
//  PostcardDataStoreNew.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import Foundation
import os.log
import Combine

class PostcardDataStore:@unchecked Sendable, ObservableObject {
    
    private let logger = Logger(subsystem: "com.snippet-intents-wwdc25", category: "PostcardDataStore")
    
    @Published var postcards: [PostcardDocument] = []
    
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Postcards")
    }
    
    init() {
        createDocumentsDirectoryIfNeeded()
        loadPostcards()
    }
    
    private func createDocumentsDirectoryIfNeeded() {
        let directory = Self.documentsDirectory
        
        if !FileManager.default.fileExists(atPath: directory.path) {
            do {
                try FileManager.default.createDirectory(
                    at: directory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                logger.info("Created new postcards directory at: \(directory.path)")
            } catch {
                logger.error("Failed to create new postcards directory: \(error.localizedDescription)")
            }
        }
    }
    
    func loadPostcards() {
        do {
            let directory = Self.documentsDirectory
            let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            postcards = files.compactMap { fileURL in
                guard fileURL.pathExtension == "json" else { return nil }
                
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let postcard = try decoder.decode(PostcardDocument.self, from: data)
                    return postcard
                } catch {
                    logger.error("Failed to decode postcard from \(fileURL.lastPathComponent): \(error)")
                    return nil
                }
            }.sorted { $0.modifiedDate > $1.modifiedDate }
            
            logger.info("Loaded \(self.postcards.count) new postcards")
        } catch {
            logger.error("Failed to load new postcards: \(error.localizedDescription)")
            postcards = []
        }
    }
    
    func addPostcard(_ postcard: PostcardDocument) throws {
        try savePostcard(postcard)
        
        if !postcards.contains(where: { $0.id == postcard.id }) {
            postcards.insert(postcard, at: 0)
        }
    }
    
    func updatePostcard(_ postcard: PostcardDocument) throws {
        var updatedPostcard = postcard
        updatedPostcard.modifiedDate = Date()
        
        try savePostcard(updatedPostcard)
        
        if let index = postcards.firstIndex(where: { $0.id == postcard.id }) {
            postcards[index] = updatedPostcard
        }
    }
    
    func deletePostcard(_ postcard: PostcardDocument) throws {
        let fileURL = postcard.fileURL
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
        
        postcards.removeAll { $0.id == postcard.id }
        logger.info("Deleted new postcard: \(postcard.title)")
    }
    
    func getPostcard(by id: String) -> PostcardDocument? {
        return postcards.first { $0.id == id }
    }
    
    private func savePostcard(_ postcard: PostcardDocument) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(postcard)
        try data.write(to: postcard.fileURL)
        
        logger.info("Saved new postcard: \(postcard.title)")
    }
}

// MARK: - Async Access

extension PostcardDataStore {
    func getPostcard(by id: String) async -> PostcardDocument? {
        return await MainActor.run {
            return getPostcard(by: id)
        }
    }
    
    func updatePostcard(_ postcard: PostcardDocument) async throws {
        try await MainActor.run {
            try updatePostcard(postcard)
        }
    }
    
    func addPostcard(_ postcard: PostcardDocument) async throws {
        try await MainActor.run {
            try addPostcard(postcard)
        }
    }
} 
