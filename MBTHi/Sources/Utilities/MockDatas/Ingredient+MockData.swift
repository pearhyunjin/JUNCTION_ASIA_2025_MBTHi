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
                minimumStock: 1000,
                pricePerUnit: 0.02,
                purchaseLink: "https://s.godo.kr/2ubm0"
            ),
            Ingredient(
                name: "우유",
                unit: .milliliter,
                currentStock: 1100,
                minimumStock: 1800,
                pricePerUnit: 0.002,
                purchaseLink: "https://brand.naver.com/seoulmilk/products/5165843445?NaPm=ct%3Dmep2pvr4%7Cci%3D8f12f3ec5a2d8c112c8eb52c63e1da2a73eb6a4a%7Ctr%3Dbrcbb%7Csn%3D1165035%7Chk%3Dc00fd421720f2d595b17b86bf5cd12b93a089afa&nl-query=서울우유"
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
                minimumStock: 500,
                pricePerUnit: 0.008,
                purchaseLink: "https://link.coupang.com/a/cModn2"
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
                currentStock: 900,
                minimumStock: 50,
                pricePerUnit: 0.015
            ),
            Ingredient(
                name: "박력분",
                unit: .gram,
                currentStock: 2000,
                minimumStock: 200,
                pricePerUnit: 0.002
            ),
            Ingredient(
                name: "계란",
                unit: .piece,
                currentStock: 60,
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
