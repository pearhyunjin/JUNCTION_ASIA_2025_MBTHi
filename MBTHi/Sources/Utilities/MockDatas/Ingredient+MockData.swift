//
//  Ingredient+MockData.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

// MARK: - Ingredient Mock Data Extension
extension Ingredient {
    static var mockData: [Ingredient] {
        return [
            // 음료 재료
            Ingredient(
                name: "원두",
                unit: .gram,
                currentStock: 500,
                minimumStock: 100,
                pricePerUnit: 0.02
            ),
            Ingredient(
                name: "우유",
                unit: .milliliter,
                currentStock: 900,
                minimumStock: 200,
                pricePerUnit: 0.002
            ),
            Ingredient(
                name: "초코파우더",
                unit: .gram,
                currentStock: 800,
                minimumStock: 100,
                pricePerUnit: 0.01
            ),
            
            // 케이크 재료 - 공통
            Ingredient(
                name: "버터",
                unit: .gram,
                currentStock: 200,
                minimumStock: 50,
                pricePerUnit: 0.008
            ),
            Ingredient(
                name: "설탕",
                unit: .gram,
                currentStock: 1000,
                minimumStock: 200,
                pricePerUnit: 0.001
            ),
            Ingredient(
                name: "생크림",
                unit: .gram,
                currentStock: 500,
                minimumStock: 100,
                pricePerUnit: 0.005
            ),
            Ingredient(
                name: "화이트초콜릿",
                unit: .gram,
                currentStock: 400,
                minimumStock: 50,
                pricePerUnit: 0.015
            ),
            Ingredient(
                name: "박력분",
                unit: .gram,
                currentStock: 1000,
                minimumStock: 200,
                pricePerUnit: 0.002
            ),
            Ingredient(
                name: "노른자",
                unit: .piece,
                currentStock: 20,
                minimumStock: 5,
                pricePerUnit: 0.15
            ),
            Ingredient(
                name: "흰자",
                unit: .piece,
                currentStock: 20,
                minimumStock: 5,
                pricePerUnit: 0.15
            ),
            
            // Lime pie 전용 재료
            Ingredient(
                name: "시트용과자",
                unit: .gram,
                currentStock: 300,
                minimumStock: 100,
                pricePerUnit: 0.005
            ),
            Ingredient(
                name: "사워크림",
                unit: .gram,
                currentStock: 200,
                minimumStock: 50,
                pricePerUnit: 0.008
            ),
            Ingredient(
                name: "연유",
                unit: .gram,
                currentStock: 400,
                minimumStock: 100,
                pricePerUnit: 0.004
            ),
            Ingredient(
                name: "라임",
                unit: .piece,
                currentStock: 10,
                minimumStock: 3,
                pricePerUnit: 0.5
            ),
            
            // Matcha Cateau 전용 재료
            Ingredient(
                name: "말차파우더",
                unit: .gram,
                currentStock: 100,
                minimumStock: 20,
                pricePerUnit: 0.05
            ),
            
            // Earlgrey Gateau 전용 재료
            Ingredient(
                name: "얼그레이티백",
                unit: .piece,
                currentStock: 20,
                minimumStock: 5,
                pricePerUnit: 0.3
            )
        ]
    }
}
