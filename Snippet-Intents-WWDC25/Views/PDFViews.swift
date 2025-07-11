//
//  Components.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 11/07/2025.
//

import Foundation
import SwiftUI

struct PostcardFrontPDFView: View {
    let postcard: PostcardDocument

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 432, height: 288)

            HStack(spacing: 0) {
                ZStack {
                    PostcardImageView(
                        imageData: postcard.frontImageData,
                        size: CGSize(width: 216, height: 288),
                        cornerRadius: 0
                    )
                }
                .frame(width: 216, height: 288)
                VStack(alignment: .leading, spacing: 12) {
                    if !postcard.greetingText.isEmpty {
                        Text(postcard.greetingText)
                            .font(.system(size: 14, design: .serif))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }

                    Spacer()

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

struct PostcardBackPDFView: View {
    let postcard: PostcardDocument

    var body: some View {
        ZStack {
            PostcardImageView(
                imageData: postcard.backImageData,
                size: CGSize(width: 432, height: 288),
                cornerRadius: 0
            )
        }
        .frame(width: 432, height: 288)
    }
}
