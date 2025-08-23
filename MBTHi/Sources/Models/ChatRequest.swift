//
//  ChatRequest.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

// MARK: - Request Models
struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let reasoningEffort: String?
    let stream: Bool
    
    enum CodingKeys: String, CodingKey {
        case model, messages, stream
        case reasoningEffort = "reasoning_effort"
    }
    
    init(model: String = APIConstants.Models.solarPro2, 
         messages: [ChatMessage], 
         reasoningEffort: String? = nil,
         stream: Bool = false) {
        self.model = model
        self.messages = messages
        self.reasoningEffort = reasoningEffort
        self.stream = stream
    }
}

struct ChatMessage: Codable {
    let role: String
    let content: String
    
    init(role: MessageRole, content: String) {
        self.role = role.rawValue
        self.content = content
    }
}

enum MessageRole: String, CaseIterable {
    case user = "user"
    case assistant = "assistant"
    case system = "system"
}

// MARK: - Response Models (Default)
struct ChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [ChatChoice]
    let usage: ChatUsage
    let systemFingerprint: String?
    
    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
}

struct ChatChoice: Codable {
    let index: Int
    let message: ChatMessage
    let logprobs: String?
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index, message, logprobs
        case finishReason = "finish_reason"
    }
}

struct ChatUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Response Models (Stream)
struct ChatStreamChunk: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String?
    let choices: [ChatStreamChoice]
    
    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices
        case systemFingerprint = "system_fingerprint"
    }
}

struct ChatStreamChoice: Codable {
    let index: Int
    let delta: ChatDelta
    let logprobs: String?
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index, delta, logprobs
        case finishReason = "finish_reason"
    }
}

struct ChatDelta: Codable {
    let role: String?
    let content: String?
}
