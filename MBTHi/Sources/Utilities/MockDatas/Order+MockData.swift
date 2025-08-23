//
//  Order+MockData.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

// MARK: - Order Mock Data Extension
extension Order {
    static var mockData: [Order] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return [
            Order(
                orderNumber: "ORD-001",
                orderDate: dateFormatter.date(from: "2024-08-24 09:30") ?? Date(),
                status: .completed,
                totalAmount: 15000,
                notes: "테이크아웃"
            ),
            Order(
                orderNumber: "ORD-002",
                orderDate: dateFormatter.date(from: "2024-08-24 10:15") ?? Date(),
                status: .completed,
                totalAmount: 42000,
                notes: "생일 케이크"
            ),
            Order(
                orderNumber: "ORD-003",
                orderDate: dateFormatter.date(from: "2024-08-24 11:00") ?? Date(),
                status: .completed,
                totalAmount: 11000,
                notes: nil
            ),
            Order(
                orderNumber: "ORD-004",
                orderDate: dateFormatter.date(from: "2024-08-24 14:20") ?? Date(),
                status: .cancelled,
                totalAmount: 5500,
                notes: "고객 변심으로 취소"
            )
        ]
    }
    
    static var mockOrderItems: [String: [(menuName: String, quantity: Int, unitPrice: Double, customizations: String?)]] {
        return [
            "ORD-001": [
                ("아메리카노", 2, 4500, nil),
                ("라떼", 1, 5500, "시럽 추가")
            ],
            
            "ORD-002": [
                ("말차가토", 1, 42000, "초 대신 양초 10개")
            ],
            
            "ORD-003": [
                ("라떼", 2, 5500, nil)
            ],
            
            "ORD-004": [
                ("라떼", 1, 5500, "디카페인")
            ]
        ]
    }
}
