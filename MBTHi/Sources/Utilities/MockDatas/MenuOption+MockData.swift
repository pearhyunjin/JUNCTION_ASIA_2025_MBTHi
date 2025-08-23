//
//  MenuOption+MockData.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

// MARK: - MenuOption Mock Data Extension
extension MenuOption {
    static var mockData: [(recipeName: String, name: String, sellingPrice: Double)] {
        return [
            // 음료 메뉴
            ("아메리카노", "아메리카노", 4500),
            ("라떼", "라떼", 5500),
            ("초코라떼", "초코라떼", 5800),
            
            // 케이크 메뉴
            ("라임파이", "라임파이", 38000),
            ("말차가토", "말차가토", 42000),
            ("얼그레이가토", "얼그레이가토", 45000)
        ]
    }
}
