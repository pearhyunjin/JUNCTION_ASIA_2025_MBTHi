//
//  IngredientData.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

// MARK: - 계산 처리하는 DTO 모델

struct IngredientData {
    let name: String
    let unit: IngredientUnit
    let currentStock: Double
    let minimumStock: Double
    let pricePerUnit: Double
}

struct RecipeData {
    let name: String
    let category: RecipeCategory
    let servingSize: Int
    let ingredients: [RecipeIngredientData]
}

struct RecipeIngredientData {
    let ingredientName: String
    let quantity: Double
    let notes: String?
}

struct MenuOptionData {
    let recipeName: String
    let name: String
    let sellingPrice: Double
}

// MARK: - 샘플 데이터 생성 헬퍼
extension ModelContext {
    func insertSampleData() {
        // 재료 샘플 데이터
        let ingredientSamples = [
            IngredientData(name: "원두", unit: .gram, currentStock: 500, minimumStock: 100, pricePerUnit: 0.02),
            IngredientData(name: "우유", unit: .milliliter, currentStock: 900, minimumStock: 200, pricePerUnit: 0.002),
            IngredientData(name: "초코파우더", unit: .gram, currentStock: 800, minimumStock: 100, pricePerUnit: 0.01),
            IngredientData(name: "생크림", unit: .milliliter, currentStock: 500, minimumStock: 100, pricePerUnit: 0.005),
            IngredientData(name: "버터", unit: .gram, currentStock: 200, minimumStock: 50, pricePerUnit: 0.008),
            IngredientData(name: "화이트초콜릿", unit: .gram, currentStock: 300, minimumStock: 50, pricePerUnit: 0.015),
            IngredientData(name: "박력분", unit: .gram, currentStock: 1000, minimumStock: 200, pricePerUnit: 0.002),
            IngredientData(name: "말차파우더", unit: .gram, currentStock: 100, minimumStock: 20, pricePerUnit: 0.05),
            IngredientData(name: "계란", unit: .piece, currentStock: 20, minimumStock: 5, pricePerUnit: 0.3),
            IngredientData(name: "설탕", unit: .gram, currentStock: 1000, minimumStock: 200, pricePerUnit: 0.001)
        ]
        
        // 재료들 생성 및 저장
        var ingredients: [String: Ingredient] = [:]
        for sample in ingredientSamples {
            let ingredient = Ingredient(
                name: sample.name,
                unit: sample.unit,
                currentStock: sample.currentStock,
                minimumStock: sample.minimumStock,
                pricePerUnit: sample.pricePerUnit
            )
            insert(ingredient)
            ingredients[sample.name] = ingredient
        }
        
        // 레시피 샘플 데이터
        let recipeSamples = [
            RecipeData(
                name: "아메리카노",
                category: .beverage,
                servingSize: 1,
                ingredients: [
                    RecipeIngredientData(ingredientName: "원두", quantity: 50, notes: "25g × 2샷")
                ]
            ),
            RecipeData(
                name: "라떼",
                category: .beverage,
                servingSize: 1,
                ingredients: [
                    RecipeIngredientData(ingredientName: "원두", quantity: 50, notes: "25g × 2샷"),
                    RecipeIngredientData(ingredientName: "우유", quantity: 200, notes: nil)
                ]
            ),
            RecipeData(
                name: "초코라떼",
                category: .beverage,
                servingSize: 1,
                ingredients: [
                    RecipeIngredientData(ingredientName: "우유", quantity: 180, notes: nil),
                    RecipeIngredientData(ingredientName: "초코파우더", quantity: 35, notes: nil)
                ]
            ),
            RecipeData(
                name: "말차가토",
                category: .cake,
                servingSize: 6,
                ingredients: [
                    RecipeIngredientData(ingredientName: "화이트초콜릿", quantity: 100, notes: nil),
                    RecipeIngredientData(ingredientName: "생크림", quantity: 100, notes: nil),
                    RecipeIngredientData(ingredientName: "박력분", quantity: 60, notes: nil),
                    RecipeIngredientData(ingredientName: "말차파우더", quantity: 8, notes: nil),
                    RecipeIngredientData(ingredientName: "계란", quantity: 8, notes: "노른자4개 + 흰자4개"),
                    RecipeIngredientData(ingredientName: "설탕", quantity: 8, notes: nil)
                ]
            )
        ]
        
        // 레시피들 생성 및 저장
        var recipes: [String: Recipe] = [:]
        for sample in recipeSamples {
            let recipe = Recipe(
                name: sample.name,
                category: sample.category,
                servingSize: sample.servingSize
            )
            insert(recipe)
            recipes[sample.name] = recipe
            
            // 레시피 재료들 연결
            for ingredientData in sample.ingredients {
                if let ingredient = ingredients[ingredientData.ingredientName] {
                    let recipeIngredient = RecipeIngredient(
                        quantity: ingredientData.quantity,
                        notes: ingredientData.notes
                    )
                    recipeIngredient.recipe = recipe
                    recipeIngredient.ingredient = ingredient
                    recipe.ingredients.append(recipeIngredient)
                    insert(recipeIngredient)
                }
            }
        }
        
        // 메뉴 옵션 샘플 데이터
        let menuOptionSamples = [
            MenuOptionData(recipeName: "아메리카노", name: "아메리카노", sellingPrice: 4500),
            MenuOptionData(recipeName: "라떼", name: "라떼", sellingPrice: 5500),
            MenuOptionData(recipeName: "초코라떼", name: "초코라떼", sellingPrice: 5800),
            MenuOptionData(recipeName: "말차가토", name: "말차가토", sellingPrice: 42000)
        ]
        
        // 메뉴 옵션들 생성 및 저장 (새로운 방식 사용)
        for sample in menuOptionSamples {
            if let recipe = recipes[sample.recipeName] {
                recipe.createMenuOption(sellingPrice: sample.sellingPrice, in: self)
            }
        }
        
        // 저장
        try? save()
    }
}
