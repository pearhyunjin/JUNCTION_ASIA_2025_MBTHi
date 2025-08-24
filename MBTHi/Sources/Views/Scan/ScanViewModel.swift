//
//  ScanViewModel.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import AVFoundation
import PhotosUI

// MARK: - LLM 응답 파싱용 모델
struct LLMParsedResponse: Codable {
    let menus: [LLMParsedMenu]
}

struct LLMParsedMenu: Codable {
    let name: String
    let quantity: Int
}

// MARK: - ViewModel
@MainActor
final class SalesScanViewModel: ObservableObject {
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var sections: [ScannedSection] = []

    let camera = CameraController()

    // 주입받을 서비스
    private let ocrService: UpstageOCRService
    private let chatService: UpstageChatService

    init(ocrService: UpstageOCRService, chatService: UpstageChatService) {
        self.ocrService = ocrService
        self.chatService = chatService
    }

    /// OCR과 LLM을 사용한 판매내역 분석 파이프라인
    func runAnalysis(on imageData: Data) async {
        isProcessing = true
        errorMessage = nil
        defer { isProcessing = false }

        do {
            // 1. OCR: 이미지에서 텍스트 추출
            let ocrResponse = try await ocrService.processDocument(imageData: imageData)
            guard !ocrResponse.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                self.errorMessage = "이미지에서 텍스트를 찾을 수 없습니다."
                return
            }
            
            // 2. LLM: 텍스트에서 정보 추출
            let llmResponse = try await parseTextWithLLM(text: ocrResponse.text)
            guard let content = llmResponse.choices.first?.message.content else {
                self.errorMessage = "메뉴 정보를 분석하지 못했습니다."
                return
            }
            
            // 3. JSON 파싱: LLM 응답을 ScannedSection으로 변환
            let scannedSections = parseLLMResponse(jsonString: content)
            if scannedSections.isEmpty {
                self.errorMessage = "분석된 판매 내역이 없습니다."
            } else {
                self.sections = scannedSections
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// LLM을 호출하여 텍스트를 구조화된 JSON으로 변환
    private func parseTextWithLLM(text: String) async throws -> ChatResponse {
        let systemPrompt = "You are an assistant that extracts menu items and their quantities from raw text. Respond only with a JSON object in the format: {\"menus\": [{\"name\": \"item_name\", \"quantity\": item_quantity}]}. Do not include any other text or explanations."
        
        let messages = [
            ChatMessage(role: .system, content: systemPrompt),
            ChatMessage(role: .user, content: text)
        ]
        
        return try await chatService.sendMessage(messages: messages)
    }
    
    /// LLM이 생성한 JSON 문자열을 [ScannedSection]으로 파싱
    private func parseLLMResponse(jsonString: String) -> [ScannedSection] {
        // LLM 응답에서 JSON 부분만 추출 (마크다운 코드 블록 제거 등)
        let cleanJsonString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
        
        guard let data = cleanJsonString.data(using: .utf8) else { return [] }
        
        do {
            let parsedData = try JSONDecoder().decode(LLMParsedResponse.self, from: data)
            let menuItems = parsedData.menus.map {
                ScannedMenuItem(category: "미분류", name: $0.name, qty: $0.quantity)
            }
            
            if menuItems.isEmpty { return [] }
            
            return [ScannedSection(title: "스캔된 메뉴", items: menuItems)]
        } catch {
            print("LLM response JSON decoding error: \(error)")
            return []
        }
    }
}

// MARK: - UI용 모델
struct ScannedMenuItem: Identifiable, Hashable {
    let id = UUID()
    var category: String
    var name: String
    var qty: Int
}

struct ScannedSection: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var items: [ScannedMenuItem]
}