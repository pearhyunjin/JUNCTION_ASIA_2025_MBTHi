//
//  StockStatus.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//




// MARK: - 재고 상태 열거형
enum StockStatus {
    case healthy
    case warning
    case critical
    
    var color: Color {
        switch self {
        case .healthy: return .green
        case .warning: return .orange
        case .critical: return .red
        }
    }
    
    var text: String {
        switch self {
        case .healthy: return "충분"
        case .warning: return "부족"
        case .critical: return "위험"
        }
    }
    
    // Ingredient에서 상태 계산
    static func from(_ ingredient: Ingredient) -> StockStatus {
        if ingredient.currentStock <= 0 {
            return .critical
        } else if ingredient.isLowStock {
            return .warning
        } else {
            return .healthy
        }
    }
}
