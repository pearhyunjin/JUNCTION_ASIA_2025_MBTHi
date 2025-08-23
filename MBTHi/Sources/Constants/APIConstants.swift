//
//  APIConstants.swift
//  MBTHi
//
//  Created by taeni on 8/23/25.
//

import Foundation

struct APIConstants {
    // MARK: - Base URLs
    struct URLs {
        static let upstageBase = "https://api.upstage.ai/v1"
        
        // Chat API (Chat + Reasoning 공통)
        static let chatCompletions = "\(upstageBase)/chat/completions"
        
        // OCR API
        static let documentDigitization = "\(upstageBase)/document-digitization"
        
        // Recipe API
        static let informationExtraction = "\(upstageBase)/information-extraction"
    }
    
    // MARK: - API Keys
    struct Keys {
        // 보안을 위해 실제 배포시에는 다음과 같이 사용
         static let upstage = Bundle.main.object(forInfoDictionaryKey: "UPSTAGE_API_KEY") as? String ?? ""
    }
    
    // MARK: - Models
    struct Models {
        static let solarPro2 = "solar-pro2"
        static let ocr = "ocr"
        static let receiptExtraction = "receipt-extraction"
    }
    
    // MARK: - Reasoning Effort Levels
    struct ReasoningEffort {
        static let low = "low"
        static let medium = "medium"
        static let high = "high"
    }
    
    // MARK: - Network Settings
    struct Network {
        static let timeoutRequest: TimeInterval = 30
        static let timeoutResource: TimeInterval = 60
        static let imageCompressionQuality: CGFloat = 0.8
    }
    
    // MARK: - UI Constants
    struct UI {
        static let maxImageHeight: CGFloat = 200
        static let maxResultHeight: CGFloat = 300
        static let buttonSize = CGSize(width: 100, height: 80)
    }
}
