//
//  GreetingTextInputView.swift
//  Snippet-Intents-WWDC25
//
//  Created by Shadrach Mensah on 09/07/2025.
//

import SwiftUI
import AppIntents

struct GreetingTextView: View {
    let postcard: PostcardEntity
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "text.badge.plus")
                    .font(.system(size: 48))
                    .foregroundStyle(.orange)
                
                Text("Write your greeting message")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Progress indicator
            ProgressView(value: postcard.currentStage.progressValue)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.orange)
            
            // Current text preview
            VStack(spacing: 8) {
                Text("Current Greeting")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    if postcard.greetingText.isEmpty {
                        Text("Add your greeting message here...")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .italic()
                    } else {
                        Text(postcard.greetingText)
                            .font(.caption2)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Action buttons
            HStack(spacing: 12) {
                Button(intent: SetGreetingTextIntent(postcard: postcard)) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Add Greetings")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orange.opacity(0.1))
                    .foregroundStyle(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .frame(maxWidth: 320)
    }
} 
