//
//  UpstageChatService.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

class UpstageChatService {
    
    // MARK: - Default Response (Async/Await)
    func sendMessage(
        messages: [ChatMessage],
        reasoningEffort: String? = nil
    ) async throws -> ChatResponse {
        let headers = ["Authorization": "Bearer \(APIConstants.Keys.upstage)"]
        
        var parameters: [String: Any] = [
            "model": APIConstants.Models.solarPro2,
            "messages": messages.map { ["role": $0.role, "content": $0.content] },
            "stream": false
        ]
        
        if let reasoningEffort = reasoningEffort {
            parameters["reasoning_effort"] = reasoningEffort
        }
        
        return try await NetworkManager.shared.requestJSON(
            url: APIConstants.URLs.chatCompletions,
            method: .POST,
            headers: headers,
            parameters: parameters,
            responseType: ChatResponse.self
        )
    }
    
    // MARK: - Stream Response (AsyncStream)
    func sendMessageStream(
        messages: [ChatMessage],
        reasoningEffort: String? = nil
    ) -> AsyncThrowingStream<String, Error> {
        let headers = ["Authorization": "Bearer \(APIConstants.Keys.upstage)"]
        
        var parameters: [String: Any] = [
            "model": APIConstants.Models.solarPro2,
            "messages": messages.map { ["role": $0.role, "content": $0.content] },
            "stream": true
        ]
        
        if let reasoningEffort = reasoningEffort {
            parameters["reasoning_effort"] = reasoningEffort
        }
        
        return NetworkManager.shared.requestStream(
            url: APIConstants.URLs.chatCompletions,
            headers: headers,
            parameters: parameters
        )
    }
}
