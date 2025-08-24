//
//  Ingredient.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import SwiftUI
import SwiftData

@Model
final class Ingredient {
    @Attribute(.unique) var id: UUID
    var name: String
    var unit: IngredientUnit
    var currentStock: Double
    var minimumStock: Double
    var pricePerUnit: Double
    var lastUpdated: Date
    
    var purchaseLink: String
    
    // 관계
    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.ingredient)
    var recipeIngredients: [RecipeIngredient] = []
    
    init(
        id: UUID = UUID(),
        name: String,
        unit: IngredientUnit,
        currentStock: Double = 0,
        minimumStock: Double = 0,
        pricePerUnit: Double = 0,
        lastUpdated: Date = Date(),
        purchaseLink: String = ""
    ) {
        self.id = id
        self.name = name
        self.unit = unit
        self.currentStock = currentStock
        self.minimumStock = minimumStock
        self.pricePerUnit = pricePerUnit
        self.lastUpdated = lastUpdated
        self.purchaseLink = purchaseLink
    }
    
    // 재고 부족 여부 확인
    var isLowStock: Bool {
        return currentStock <= minimumStock
    }
}

extension Ingredient {
    /// 재고 업데이트 (사용량 차감)
    func consumeStock(_ amount: Double) -> Bool {
        guard currentStock >= amount else { return false }
        currentStock -= amount
        lastUpdated = Date()
        return true
    }
    
    /// 재고 추가 (입고)
    func addStock(_ amount: Double) {
        currentStock += amount
        lastUpdated = Date()
    }
    
    /// 재고 상태 색상
    var stockStatusColor: String {
        if currentStock <= 0 { return "red" }
        if isLowStock { return "orange" }
        return "green"
    }
}
