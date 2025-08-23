//
//  IngredientUnit.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//


enum IngredientUnit: String, CaseIterable, Codable {
    case gram = "g"
    case kilogram = "kg"
    case milliliter = "ml"
    case liter = "L"
    case piece = "개"
    case tablespoon = "큰술"
    case teaspoon = "작은술"
    case cup = "컵"
    case slice = "조각"
    case bag = "봉지"
    case bottle = "병"
    case pack = "팩"
    
    var displayName: String {
        return self.rawValue
    }
    
    var fullName: String {
        switch self {
        case .gram: return "그램"
        case .kilogram: return "킬로그램"
        case .milliliter: return "밀리리터"
        case .liter: return "리터"
        case .piece: return "개"
        case .tablespoon: return "큰술"
        case .teaspoon: return "작은술"
        case .cup: return "컵"
        case .slice: return "조각"
        case .bag: return "봉지"
        case .bottle: return "병"
        case .pack: return "팩"
        }
    }
    
    // 단위 변환 (같은 계량 시스템 내에서)
    func convertTo(_ targetUnit: IngredientUnit, value: Double) -> Double? {
        switch (self, targetUnit) {
        case (.gram, .kilogram): return value / 1000
        case (.kilogram, .gram): return value * 1000
        case (.milliliter, .liter): return value / 1000
        case (.liter, .milliliter): return value * 1000
        default: return self == targetUnit ? value : nil
        }
    }
}
