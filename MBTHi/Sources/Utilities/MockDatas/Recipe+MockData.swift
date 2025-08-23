//
//  Recipe+MockData.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

// MARK: - Recipe Mock Data Extension
extension Recipe {
    static var mockData: [Recipe] {
        return [
            // 음료 레시피
            Recipe(
                name: "아메리카노",
                category: .beverage,
                servingSize: 1
            ),
            Recipe(
                name: "라떼",
                category: .beverage,
                servingSize: 1
            ),
            Recipe(
                name: "초코라떼",
                category: .beverage,
                servingSize: 1
            ),
            
            // 케이크 레시피
            Recipe(
                name: "라임파이",
                category: .cake,
                servingSize: 8
            ),
            Recipe(
                name: "말차가토",
                category: .cake,
                servingSize: 8
            ),
            Recipe(
                name: "얼그레이가토",
                category: .cake,
                servingSize: 8
            )
        ]
    }
    
    static var mockRecipeIngredients: [String: [(ingredientName: String, quantity: Double, notes: String?)]] {
        return [
            "아메리카노": [
                ("원두", 50.0, "25g × 2샷")
            ],
            
            "라떼": [
                ("원두", 50.0, "25g × 2샷"),
                ("우유", 200.0, nil)
            ],
            
            "초코라떼": [
                ("우유", 180.0, nil),
                ("초코파우더", 35.0, "초코 소스")
            ],
            
            "라임파이": [
                ("시트용과자", 100.0, nil),
                ("버터", 70.0, nil),
                ("설탕", 30.0, "시트용 10g + 크림용 20g"),
                ("사워크림", 50.0, nil),
                ("연유", 100.0, nil),
                ("생크림", 100.0, nil),
                ("라임", 1.0, "1개")
            ],
            
            "말차가토": [
                ("화이트초콜릿", 100.0, nil),
                ("생크림", 100.0, "500g 1통에서 사용"),
                ("박력분", 60.0, nil),
                ("말차파우더", 8.0, nil),
                ("노른자", 4.0, "4개"),
                ("흰자", 4.0, "4개"),
                ("설탕", 8.0, nil)
            ],
            
            "얼그레이가토": [
                ("버터", 80.0, nil),
                ("화이트초콜릿", 300.0, nil),
                ("노른자", 4.0, "4개"),
                ("흰자", 4.0, "4개"),
                ("연유", 22.0, nil),
                ("박력분", 200.0, nil),
                ("얼그레이티백", 4.0, "4개"),
                ("생크림", 55.0, nil)
            ]
        ]
    }
}
