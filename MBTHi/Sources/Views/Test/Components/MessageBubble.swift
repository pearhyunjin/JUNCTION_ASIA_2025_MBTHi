//
//  MessageBubble.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    let isStreaming: Bool
    
    init(message: ChatMessage, isStreaming: Bool = false) {
        self.message = message
        self.isStreaming = isStreaming
    }
    
    var body: some View {
        HStack {
            if message.role == "user" { Spacer() }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.role == "user" ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.role == "user" ? .white : .primary)
                    .cornerRadius(12)
                
                if isStreaming {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.6)
                        Text("입력 중...")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if message.role == "assistant" { Spacer() }
        }
    }
}
