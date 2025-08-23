//
//  RecipeCategory.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

enum RecipeCategory: String, CaseIterable, Codable {
    case beverage = "음료"
    case cake = "케이크"
    
    var displayName: String {
        return self.rawValue
    }
}
