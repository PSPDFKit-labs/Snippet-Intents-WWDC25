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
    
    
    /// Export a postcard from PostcardDocumentNew to PDF format
    func exportPostcard(_ postcard: PostcardDocument) async -> URL? {
        let pdfURL = createPDFURLNew(for: postcard)
        
        // Create PDF document
        let pdfDocument = PDFDocument()
        
        // Add front page
        if let frontPage = await createFrontPageNew(postcard: postcard) {
            pdfDocument.insert(frontPage, at: 0)
        }
        
        // Add back page
        if let backPage = await createBackPageNew(postcard: postcard) {
            pdfDocument.insert(backPage, at: pdfDocument.pageCount)
        }
        
        // Save PDF
        if pdfDocument.write(to: pdfURL) {
            logger.info("Exported new postcard PDF to: \(pdfURL.path)")
            return pdfURL
        } else {
            logger.error("Failed to export new postcard PDF")
            return nil
        }
    }
    
    
    /// Create the front page of the new postcard
    private func createFrontPageNew(postcard: PostcardDocument) async -> PDFPage? {
        let frontView = PostcardFrontPDFViewNew(postcard: postcard)
        return createPDFPage(from: frontView)
    }
    
    /// Create the back page of the new postcard
    private func createBackPageNew(postcard: PostcardDocument) async -> PDFPage? {
        let backView = PostcardBackPDFViewNew(postcard: postcard)
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

    
    /// Create a unique PDF URL for the new postcard
    private func createPDFURLNew(for postcard: PostcardDocument) -> URL {
        let documentsURL = PostcardDataStore.documentsDirectory
        let fileName = "\(postcard.title.replacingOccurrences(of: " ", with: "_"))_\(postcard.id).pdf"
        return documentsURL.appendingPathComponent(fileName)
    }
}


// MARK: - PDF Views for New Postcards

/// Front view optimized for PDF rendering (New)
struct PostcardFrontPDFViewNew: View {
    let postcard: PostcardDocument
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(Color.white)
                .frame(width: 432, height: 288)
            
            HStack(spacing: 0) {
                // Left side - Image (fills half the space, no padding)
                ZStack {
                    if let frontImageData = postcard.frontImageData,
                       let uiImage = UIImage(data: frontImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 216, height: 288)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 216, height: 288)
                    }
                }
                .frame(width: 216, height: 288)
                
                // Right side - Greeting Text
                VStack(alignment: .leading, spacing: 12) {
                    if !postcard.greetingText.isEmpty {
                        Text(postcard.greetingText)
                            .font(.system(size: 14, design: .serif))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    Spacer()
                    
                    // Sender name at bottom
                    if !postcard.senderName.isEmpty {
                        HStack {
                            Spacer()
                            Text("- \(postcard.senderName)")
                                .font(.system(size: 12, design: .serif))
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(width: 196, height: 268)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
        }
        .frame(width: 432, height: 288)
    }
}

/// Back view optimized for PDF rendering (New)
struct PostcardBackPDFViewNew: View {
    let postcard: PostcardDocument
    
    var body: some View {
        ZStack {
            // Full Background Image - no address area
            if let backImageData = postcard.backImageData,
                          let uiImage = UIImage(data: backImageData) {
            Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 432, height: 288)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 432, height: 288)
            }
        }
        .frame(width: 432, height: 288)
    }
}

