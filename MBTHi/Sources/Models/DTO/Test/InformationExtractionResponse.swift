//
//  InformationExtractionResponse.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

// MARK: - Information Extraction Models
struct InformationExtractionResponse: Codable {
    let rawResponse: String  // 전체 JSON을 String으로 저장
    let apiVersion: String?
    let confidence: Double?
    let documentType: String?
    
    init(rawResponse: String) {
        self.rawResponse = rawResponse
        
        // 기본 정보만 파싱 시도
        if let data = rawResponse.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            self.apiVersion = json["apiVersion"] as? String
            self.confidence = json["confidence"] as? Double
            self.documentType = json["documentType"] as? String
        } else {
            self.apiVersion = nil
            self.confidence = nil
            self.documentType = nil
        }
    }
}

// 나중에 상세 파싱이 필요할 때를 위한 구조체들 (선택사항)
struct ReceiptField: Codable {
    let id: Int
    let key: String
    let confidence: Double?
    let refinedValue: String?
    let type: String?
    let value: String?
    let properties: [ReceiptField]?
}

struct ReceiptExtractionDetail: Codable {
    let apiVersion: String
    let confidence: Double
    let documentType: String
    let fields: [ReceiptField]
    let metadata: ExtractionMetadata
    let mimeType: String
    let modelVersion: String
    let numBilledPages: Int
    let stored: Bool
}

struct ExtractionMetadata: Codable {
    let pages: [ExtractionPageInfo]
}

struct ExtractionPageInfo: Codable {
    let height: Int
    let page: Int
    let width: Int
}
