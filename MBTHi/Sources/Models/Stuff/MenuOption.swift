//
//  MenuOption.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

@Model
final class MenuOption {
    @Attribute(.unique) var id: UUID
    var name: String
    var sellingPrice: Double
    
    // 1:1 관계 - Recipe는 필수
    var recipe: Recipe?
    
    init(
        id: UUID = UUID(),
        name: String,
        sellingPrice: Double
    ) {
        self.id = id
        self.name = name
        self.sellingPrice = sellingPrice
    }
}

// MARK: - Cost Calculations
extension MenuOption {
    /// 이 옵션의 실제 원가
    var actualCost: Double {
        guard let recipe = recipe else { return 0 }
        return recipe.costPerServing
    }
    
    /// 수익률 (백분율)
    var profitMargin: Double {
        guard sellingPrice > 0 else { return 0 }
        return ((sellingPrice - actualCost) / sellingPrice) * 100
    }
    
    /// 실제 수익금액
    var profitAmount: Double {
        return sellingPrice - actualCost
    }
}

// MARK: - Business Logic
extension MenuOption {
    /// 판매 가능 여부 (레시피 제작 가능 여부만 확인)
    var canSell: Bool {
        return recipe?.canMake ?? false
    }
    
    /// 가격 업데이트
    func updatePrice(_ newPrice: Double) {
        guard newPrice > 0 else { return }
        self.sellingPrice = newPrice
    }
}

// MARK: - Display Helpers
extension MenuOption {
    /// 가격 포맷팅 (한국 원화)
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: sellingPrice)) ?? "₩0"
    }
    
    /// 수익률 포맷팅
    var formattedProfitMargin: String {
        return String(format: "%.1f%%", profitMargin)
    }
    
    /// 수익금액 포맷팅
    var formattedProfitAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: profitAmount)) ?? "₩0"
    }
    
    /// 상태 표시 텍스트
    var statusText: String {
        return canSell ? "판매 가능" : "재료 부족"
    }
}

// MARK: - Analytics
extension MenuOption {
    /// 수익성 등급 (A, B, C, D, F)
    var profitabilityGrade: String {
        switch profitMargin {
        case 80...: return "A" // 매우 높음
        case 60..<80: return "B" // 높음
        case 40..<60: return "C" // 보통
        case 20..<40: return "D" // 낮음
        default: return "F" // 매우 낮음
        }
    }
    
    /// 고수익 메뉴 여부 (수익률 60% 이상)
    var isHighProfitItem: Bool {
        return profitMargin >= 60.0
    }
    
    /// 손실 메뉴 여부 (원가보다 낮은 판매가)
    var isLossItem: Bool {
        return sellingPrice < actualCost
    }
}
