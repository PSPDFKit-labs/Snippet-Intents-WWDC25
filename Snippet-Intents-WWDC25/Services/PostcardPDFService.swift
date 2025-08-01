//
//  PostcardPDFService.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import PDFKit
import os.log
import UIKit


class PostcardPDFService: @unchecked Sendable {
    static let shared = PostcardPDFService()
    
    private let logger = Logger(subsystem: "com.snippet-intents-wwdc25", category: "PostcardPDFService")
    
    // Standard postcard size in points (6" x 4" at 72 DPI)
    private let postcardSize = CGSize(width: 432, height: 288)
    
    private init() {}
    
    
    /// Export a postcard to PDF format
    func exportPostcard(_ postcard: PostcardDocument) async -> URL? {
        let pdfURL = createPDFURL(for: postcard)
        
        // Create PDF document
        let pdfDocument = PDFDocument()
        
        // Add front page
        if let frontPage = await createFrontPage(postcard: postcard) {
            pdfDocument.insert(frontPage, at: 0)
        }
        
        // Add back page
        if let backPage = await createBackPage(postcard: postcard) {
            pdfDocument.insert(backPage, at: pdfDocument.pageCount)
        }
        
        // Save PDF
        if pdfDocument.write(to: pdfURL) {
            logger.info("Exported postcard PDF to: \(pdfURL.path)")
            return pdfURL
        } else {
            logger.error("Failed to export postcard PDF")
            return nil
        }
    }
    
    
    /// Create the front page of the postcard
    private func createFrontPage(postcard: PostcardDocument) async -> PDFPage? {
        let frontView = PostcardFrontPDFView(postcard: postcard)
        return createPDFPage(from: frontView)
    }
    
    /// Create the back page of the postcard
    private func createBackPage(postcard: PostcardDocument) async -> PDFPage? {
        let backView = PostcardBackPDFView(postcard: postcard)
        return createPDFPage(from: backView)
    }
    
    /// Create a PDF page from a SwiftUI view
    private func createPDFPage<Content: View>(from view: Content) -> PDFPage? {
        let renderer = ImageRenderer(content: view)
        renderer.proposedSize = ProposedViewSize(postcardSize)
        
        guard let uiImage = renderer.uiImage else {
            logger.error("Failed to render SwiftUI view to UIImage")
            return nil
        }
        
        // Create PDF data from image
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: postcardSize), nil)
        UIGraphicsBeginPDFPage()
        
        guard UIGraphicsGetCurrentContext() != nil else {
            UIGraphicsEndPDFContext()
            logger.error("Failed to get PDF graphics context")
            return nil
        }
        
        // Draw the image into the PDF context
        uiImage.draw(in: CGRect(origin: .zero, size: postcardSize))
        UIGraphicsEndPDFContext()
        
        // Create PDF page from data
        guard let pdfDocument = PDFDocument(data: pdfData as Data),
              let page = pdfDocument.page(at: 0) else {
            logger.error("Failed to create PDF page from data")
            return nil
        }
        
        return page
    }

    
    /// Create a unique PDF URL for the postcard
    private func createPDFURL(for postcard: PostcardDocument) -> URL {
        let documentsURL = PostcardDataStore.documentsDirectory
        let fileName = "\(postcard.title.replacingOccurrences(of: " ", with: "_"))_\(postcard.id).pdf"
        return documentsURL.appendingPathComponent(fileName)
    }
}


// MARK: - PDF Views for Postcards

/// Front view optimized for PDF rendering

