//
//  Recipe.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: RecipeCategory
    var servingSize: Int
    var createdDate: Date
    var lastModified: Date
    
    // 관계
    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.recipe)
    var ingredients: [RecipeIngredient] = []
    
    // 1:1 관계 - MenuOption
    @Relationship(deleteRule: .cascade, inverse: \MenuOption.recipe)
    var menuOption: MenuOption?
    
    init(
        id: UUID = UUID(),
        name: String,
        category: RecipeCategory,
        servingSize: Int = 1,
        createdDate: Date = Date(),
        lastModified: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.servingSize = servingSize
        self.createdDate = createdDate
        self.lastModified = lastModified
    }
    
    // MenuOption 생성 함수 (컨텍스트가 필요한 작업)
    func createMenuOption(sellingPrice: Double, in context: ModelContext) {
        let menuOption = MenuOption(
            name: name,
            sellingPrice: sellingPrice
        )
        menuOption.recipe = self
        self.menuOption = menuOption
        context.insert(menuOption)
    }
}

// MARK: - Cost Calculations
extension Recipe {
    /// 레시피 전체 원가
    var totalCost: Double {
        return ingredients.reduce(0) { $0 + $1.totalCost }
    }
    
    /// 1인분당 원가
    var costPerServing: Double {
        guard servingSize > 0 else { return 0 }
        return totalCost / Double(servingSize)
    }
    
    /// 판매가격 (MenuOption을 통해 접근)
    var sellingPrice: Double {
        get {
            return menuOption?.sellingPrice ?? 0
        }
        set {
            menuOption?.sellingPrice = newValue
        }
    }
    
    /// 수익률
    var profitMargin: Double {
        return menuOption?.profitMargin ?? 0
    }
    
    /// 수익금액
    var profitAmount: Double {
        return menuOption?.profitAmount ?? 0
    }
}

// MARK: - Stock Management
extension Recipe {
    /// 레시피 제작 가능 여부 확인
    var canMake: Bool {
        return ingredients.allSatisfy { recipeIngredient in
            guard let ingredient = recipeIngredient.ingredient else { return false }
            return ingredient.currentStock >= recipeIngredient.quantity
        }
    }
    
    /// 최대 제작 가능 수량
    var maxPossibleQuantity: Int {
        let minRatio = ingredients.compactMap { recipeIngredient -> Double? in
            guard let ingredient = recipeIngredient.ingredient,
                  recipeIngredient.quantity > 0 else { return nil }
            return ingredient.currentStock / recipeIngredient.quantity
        }.min() ?? 0
        
        return Int(minRatio)
    }
    
    /// 부족한 재료 목록
    var missingIngredients: [Ingredient] {
        return ingredients.compactMap { recipeIngredient in
            guard let ingredient = recipeIngredient.ingredient else { return nil }
            return ingredient.currentStock < recipeIngredient.quantity ? ingredient : nil
        }
    }
}

// MARK: - Business Logic
extension Recipe {
    /// 레시피 수정 시 lastModified 업데이트
    func markAsModified() {
        self.lastModified = Date()
    }
    
    /// 특정 수량 제작 시 필요한 재료량 계산
    func requiredIngredients(for quantity: Int) -> [(ingredient: Ingredient, requiredAmount: Double)] {
        return ingredients.compactMap { recipeIngredient in
            guard let ingredient = recipeIngredient.ingredient else { return nil }
            let requiredAmount = recipeIngredient.quantity * Double(quantity)
            return (ingredient: ingredient, requiredAmount: requiredAmount)
        }
    }
    
    /// 판매 가능 여부 (재료 상태만 확인)
    var canSell: Bool {
        return canMake
    }
}

// MARK: - Formatting Helpers
extension Recipe {
    /// 레시피 카테고리 한글명
    var categoryDisplayName: String {
        return category.displayName
    }
    
    /// 생성일 포맷팅
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: createdDate)
    }
    
    /// 최종 수정일 포맷팅
    var formattedLastModified: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: lastModified)
    }
    
    /// 가격 포맷팅
    var formattedPrice: String {
        return menuOption?.formattedPrice ?? "₩0"
    }
    
    /// 수익률 포맷팅
    var formattedProfitMargin: String {
        return menuOption?.formattedProfitMargin ?? "0.0%"
    }
}

extension Recipe {
    /// 레시피 제작 시 재료 소모 처리
    func executeRecipe(quantity: Int = 1) -> Bool {
        // 먼저 모든 재료가 충분한지 확인
        guard canMakeQuantity(quantity) else { return false }
        
        // 모든 재료 소모
        for recipeIngredient in ingredients {
            guard let ingredient = recipeIngredient.ingredient else { continue }
            let requiredAmount = recipeIngredient.quantity * Double(quantity)
            _ = ingredient.consumeStock(requiredAmount)
        }
        
        markAsModified()
        return true
    }
    
    /// 특정 수량 제작 가능 여부
    func canMakeQuantity(_ quantity: Int) -> Bool {
        return ingredients.allSatisfy { recipeIngredient in
            guard let ingredient = recipeIngredient.ingredient else { return false }
            let requiredAmount = recipeIngredient.quantity * Double(quantity)
            return ingredient.currentStock >= requiredAmount
        }
    }
}
