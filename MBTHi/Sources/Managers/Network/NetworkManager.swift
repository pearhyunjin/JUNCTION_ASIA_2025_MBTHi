//
//  NetworkManager.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConstants.Network.timeoutRequest
        config.timeoutIntervalForResource = APIConstants.Network.timeoutResource
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - JSON Request (Async/Await)
    func requestJSON<T: Codable>(
        url: String,
        method: HTTPMethod = .POST,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        let request = try createJSONRequest(
            url: url,
            method: method,
            headers: headers,
            parameters: parameters
        )
        
        return try await performRequest(request: request, responseType: responseType)
    }
    
    // MARK: - Multipart Form Request (Async/Await)
    func requestMultipartForm<T: Codable>(
        url: String,
        headers: [String: String]? = nil,
        formData: [FormDataItem],
        responseType: T.Type
    ) async throws -> T {
        let request = try createMultipartRequest(url: url, headers: headers, formData: formData)
        return try await performRequest(request: request, responseType: responseType)
    }
    
    // MARK: - String Response Request (for Information Extraction)
    func requestMultipartFormAsString(
        url: String,
        headers: [String: String]? = nil,
        formData: [FormDataItem]
    ) async throws -> String {
        let request = try createMultipartRequest(url: url, headers: headers, formData: formData)
        return try await performStringRequest(request: request)
    }
    
    // MARK: - Streaming Request (AsyncStream)
    func requestStream(
        url: String,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil
    ) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task.detached { [weak self] in // weak self로 메모리 누수 방지
                guard let self = self else {
                    continuation.finish(throwing: NetworkError.invalidURL)
                    return
                }
                
                do {
                    let request = try self.createJSONRequest(
                        url: url,
                        method: .POST,
                        headers: self.createStreamHeaders(headers),
                        parameters: parameters
                    )
                    
                    try await self.performStreamRequest(request: request, continuation: continuation)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func createJSONRequest(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?,
        parameters: [String: Any]?
    ) throws -> URLRequest {
        guard let requestURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        var requestHeaders = headers ?? [:]
        if parameters != nil {
            requestHeaders["Content-Type"] = "application/json"
        }
        
        requestHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw NetworkError.encodingError
            }
        }
        
        return request
    }
    
    private func createMultipartRequest(
        url: String,
        headers: [String: String]?,
        formData: [FormDataItem]
    ) throws -> URLRequest {
        guard let requestURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.POST.rawValue
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = createMultipartFormData(boundary: boundary, formData: formData)
        return request
    }
    
    private func createStreamHeaders(_ headers: [String: String]?) -> [String: String] {
        var streamHeaders = headers ?? [:]
        streamHeaders["Content-Type"] = "application/json"
        streamHeaders["Accept"] = "text/event-stream"
        streamHeaders["Cache-Control"] = "no-cache"
        return streamHeaders
    }
    
    private func performRequest<T: Codable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func performStringRequest(request: URLRequest) async throws -> String {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
        }
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw NetworkError.noData
        }
        
        return responseString
    }
    
    private func performStreamRequest(
        request: URLRequest,
        continuation: AsyncThrowingStream<String, Error>.Continuation
    ) async throws {
        let (bytes, response) = try await session.bytes(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            continuation.finish(throwing: NetworkError.invalidResponse)
            return
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            continuation.finish(throwing: NetworkError.serverError(httpResponse.statusCode, "Server error"))
            return
        }
        
        try await processStreamingResponse(bytes: bytes, continuation: continuation)
    }
    
    private func processStreamingResponse(
        bytes: URLSession.AsyncBytes,
        continuation: AsyncThrowingStream<String, Error>.Continuation
    ) async throws {
        var dataBuffer = Data()
        var eventBuffer = ""
        
        for try await byte in bytes {
            dataBuffer.append(byte)
            
            // 개행 문자에서 UTF-8 디코딩 시도
            if byte == 10 { // \n
                if let line = String(data: dataBuffer, encoding: .utf8) {
                    eventBuffer += line
                    
                    // 빈 줄이면 이벤트 완료
                    if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if !eventBuffer.isEmpty {
                            await parseSSEEvent(eventBuffer, continuation: continuation)
                            eventBuffer = ""
                        }
                    }
                    dataBuffer = Data()
                } else {
                    // UTF-8 디코딩 실패 시 버퍼 크기 제한
                    if dataBuffer.count > 1024 { // 1KB 제한
                        dataBuffer = Data()
                    }
                }
            }
        }
        
        // 남은 이벤트 처리
        if !eventBuffer.isEmpty {
            await parseSSEEvent(eventBuffer, continuation: continuation)
        }
        
        continuation.finish()
    }
    
    private func parseSSEEvent(
        _ event: String,
        continuation: AsyncThrowingStream<String, Error>.Continuation
    ) async {
        let lines = event.components(separatedBy: .newlines)
        
        for line in lines {
            if line.hasPrefix("data: ") {
                let jsonString = String(line.dropFirst(6))
                
                if jsonString.trimmingCharacters(in: .whitespaces) == "[DONE]" {
                    continuation.finish()
                    return
                }
                
                if let data = jsonString.data(using: .utf8),
                   let streamChunk = try? JSONDecoder().decode(ChatStreamChunk.self, from: data),
                   let content = streamChunk.choices.first?.delta.content {
                    continuation.yield(content)
                }
            }
        }
    }
    
    private func createMultipartFormData(boundary: String, formData: [FormDataItem]) -> Data {
        var data = Data()
        
        for item in formData {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            switch item {
            case .text(let name, let value):
                data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)\r\n".data(using: .utf8)!)
                
            case .file(let name, let filename, let fileData, let mimeType):
                data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                data.append(fileData)
                data.append("\r\n".data(using: .utf8)!)
            }
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return data
    }
}
