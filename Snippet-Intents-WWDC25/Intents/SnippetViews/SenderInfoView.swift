//
//  SenderInfoInputView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

struct SenderInfoView: View {
    let postcard: PostcardEntity
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress indicator
            ProgressView(value: postcard.currentStage.progressValue)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.green)
            
            Text("Add sender information")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Image(systemName: "person.fill")
                .font(.system(size: 32))
                .foregroundStyle(.purple)
            
            Text("Step 4: Sender Info")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Current sender info preview
            VStack(alignment: .leading, spacing: 12) {
                
                VStack(alignment: .leading, spacing: 4) {
                    if postcard.senderName.isEmpty {
                        Text("No sender info yet")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .italic()
                    } else {
                        Text(postcard.senderName)
                            .font(.caption2)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Action button
            Button(intent: SetSenderInfoIntent(postcard: postcard)) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Add Sender Name")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .frame(maxWidth: 280)
    }
} 
