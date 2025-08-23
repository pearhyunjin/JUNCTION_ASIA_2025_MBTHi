//
//  MockDataManager.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

// MARK: - Mock Data Manager
struct MockDataManager {
    
    /// 모든 Mock 데이터를 ModelContext에 삽입
    static func insertAllMockData(in context: ModelContext) {
        // 1. 재료 데이터 삽입
        let ingredients = Ingredient.mockData
        var ingredientDict: [String: Ingredient] = [:]
        
        for ingredient in ingredients {
            context.insert(ingredient)
            ingredientDict[ingredient.name] = ingredient
        }
        
        // 2. 레시피 데이터 삽입
        let recipes = Recipe.mockData
        var recipeDict: [String: Recipe] = [:]
        
        for recipe in recipes {
            context.insert(recipe)
            recipeDict[recipe.name] = recipe
        }
        
        // 3. 레시피-재료 연결
        for (recipeName, ingredientData) in Recipe.mockRecipeIngredients {
            guard let recipe = recipeDict[recipeName] else { continue }
            
            for (ingredientName, quantity, notes) in ingredientData {
                guard let ingredient = ingredientDict[ingredientName] else { continue }
                
                let recipeIngredient = RecipeIngredient(
                    quantity: quantity,
                    notes: notes
                )
                recipeIngredient.recipe = recipe
                recipeIngredient.ingredient = ingredient
                recipe.ingredients.append(recipeIngredient)
                context.insert(recipeIngredient)
            }
        }
        
        // 4. 메뉴 옵션 데이터 삽입
        for (recipeName, menuName, sellingPrice) in MenuOption.mockData {
            guard let recipe = recipeDict[recipeName] else { continue }
            recipe.createMenuOption(sellingPrice: sellingPrice, in: context)
        }
        
        // 5. 주문 데이터 삽입
        let orders = Order.mockData
        var orderDict: [String: Order] = [:]
        
        for order in orders {
            context.insert(order)
            orderDict[order.orderNumber] = order
        }
        
        // 6. 주문 아이템 연결
        for (orderNumber, itemsData) in Order.mockOrderItems {
            guard let order = orderDict[orderNumber] else { continue }
            
            for (menuName, quantity, unitPrice, customizations) in itemsData {
                // 메뉴 옵션 찾기
                let menuOption = recipeDict.values.compactMap { $0.menuOption }.first { $0.name == menuName }
                
                let orderItem = OrderItem(
                    quantity: quantity,
                    unitPrice: unitPrice,
                    customizations: customizations
                )
                orderItem.order = order
                orderItem.menuOption = menuOption
                order.items.append(orderItem)
                context.insert(orderItem)
            }
            
            // 주문 총액 업데이트
            order.totalAmount = order.items.reduce(0) { $0 + $1.subtotal }
        }
        
        // 7. 저장
        try? context.save()
    }
    
    /// 모든 Mock 데이터 삭제
    static func deleteAllMockData(in context: ModelContext) {
        // 모든 데이터 삭제 (관계로 인해 자동으로 연결된 데이터도 삭제됨)
        try? context.delete(model: Order.self)
        try? context.delete(model: OrderItem.self)
        try? context.delete(model: MenuOption.self)
        try? context.delete(model: RecipeIngredient.self)
        try? context.delete(model: Recipe.self)
        try? context.delete(model: Ingredient.self)
        
        try? context.save()
    }
    
    /// 데이터 존재 여부 확인
    static func hasMockData(in context: ModelContext) -> Bool {
        let ingredientCount = (try? context.fetch(FetchDescriptor<Ingredient>()).count) ?? 0
        return ingredientCount > 0
    }
}
