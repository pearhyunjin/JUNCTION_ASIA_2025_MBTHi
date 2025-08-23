//
//  ChatView.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var useStreaming: Bool = true
    @State private var useReasoning: Bool = false
    @State private var reasoningLevel: String = APIConstants.ReasoningEffort.high
    @State private var currentStreamingText: String = ""
    
    private let chatService = UpstageChatService()
    
    var body: some View {
        NavigationView {
            VStack {
                // 메시지 목록
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(messages.enumerated()), id: \.offset) { index, message in
                                MessageBubble(message: message)
                                    .id(index)
                            }
                            
                            // 스트리밍 중인 메시지
                            if isLoading && !currentStreamingText.isEmpty {
                                MessageBubble(
                                    message: ChatMessage(role: .assistant, content: currentStreamingText),
                                    isStreaming: true
                                )
                                .id("streaming")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo(messages.count - 1, anchor: .bottom)
                        }
                    }
                }
                
                // 입력 영역
                VStack(spacing: 10) {
                    // 설정 옵션들
                    HStack(spacing: 20) {
                        Toggle("스트리밍", isOn: $useStreaming)
                            .font(.caption)
                        
                        Toggle("추론 모드", isOn: $useReasoning)
                            .font(.caption)
                        
                        if useReasoning {
                            Picker("추론 수준", selection: $reasoningLevel) {
                                Text("Low").tag(APIConstants.ReasoningEffort.low)
                                Text("Medium").tag(APIConstants.ReasoningEffort.medium)
                                Text("High").tag(APIConstants.ReasoningEffort.high)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .font(.caption)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 메시지 입력
                    HStack {
                        TextField("메시지를 입력하세요...", text: $messageText)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(messageText.isEmpty || isLoading ? Color.gray : Color.blue)
                                .clipShape(Circle())
                        }
                        .disabled(messageText.isEmpty || isLoading)
                    }
                    .padding()
                }
            }
            .navigationTitle("AI 채팅")
            .alert("오류", isPresented: .constant(errorMessage != nil)) {
                Button("확인") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private func sendMessage() {
        let userMessage = ChatMessage(role: .user, content: messageText)
        messages.append(userMessage)
        
        messageText = ""
        isLoading = true
        currentStreamingText = ""
        
        let reasoningEffort = useReasoning ? reasoningLevel : nil
        
        if useStreaming {
            sendStreamingMessage(reasoningEffort: reasoningEffort)
        } else {
            sendNormalMessage(reasoningEffort: reasoningEffort)
        }
    }
    
    private func sendNormalMessage(reasoningEffort: String?) {
        Task {
            do {
                let response = try await chatService.sendMessage(
                    messages: messages,
                    reasoningEffort: reasoningEffort
                )
                await MainActor.run {
                    if let assistantMessage = response.choices.first?.message {
                        messages.append(assistantMessage)
                    }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
    private func sendStreamingMessage(reasoningEffort: String?) {
        Task {
            do {
                let stream = chatService.sendMessageStream(
                    messages: messages,
                    reasoningEffort: reasoningEffort
                )
                
                for try await chunk in stream {
                    await MainActor.run {
                        currentStreamingText += chunk
                    }
                }
                
                await MainActor.run {
                    if !currentStreamingText.isEmpty {
                        let assistantMessage = ChatMessage(role: .assistant, content: currentStreamingText)
                        messages.append(assistantMessage)
                        currentStreamingText = ""
                    }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    currentStreamingText = ""
                    isLoading = false
                }
            }
        }
    }
}
