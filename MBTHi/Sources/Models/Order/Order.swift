//
//  Order.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

@Model
final class Order {
    @Attribute(.unique) var id: UUID
    var orderNumber: String
    var orderDate: Date
    var status: OrderStatus
    var totalAmount: Double
    var notes: String?
    
    // 관계
    @Relationship(deleteRule: .cascade, inverse: \OrderItem.order)
    var items: [OrderItem] = []
    
    init(
        id: UUID = UUID(),
        orderNumber: String,
        orderDate: Date = Date(),
        status: OrderStatus = .completed,
        totalAmount: Double = 0,
        notes: String? = nil
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.orderDate = orderDate
        self.status = status
        self.totalAmount = totalAmount
        self.notes = notes
    }
}

extension Order {
    /// 주문의 총 원가
    var totalCost: Double {
        return items.reduce(0) { total, item in
            total + (item.menuOption?.actualCost ?? 0) * Double(item.quantity)
        }
    }
    
    /// 주문의 총 수익
    var totalProfit: Double {
        return totalAmount - totalCost
    }
    
    /// 주문의 수익률
    var profitMargin: Double {
        guard totalAmount > 0 else { return 0 }
        return (totalProfit / totalAmount) * 100
    }
}
