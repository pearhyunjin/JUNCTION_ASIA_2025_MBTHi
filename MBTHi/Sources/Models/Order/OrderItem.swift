//
//  OrderItem.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import Foundation
import SwiftData

@Model
final class OrderItem {
    @Attribute(.unique) var id: UUID
    var quantity: Int
    var unitPrice: Double
    var customizations: String?
    
    // 관계
    var order: Order?
    var menuOption: MenuOption?
    
    init(
        id: UUID = UUID(),
        quantity: Int,
        unitPrice: Double,
        customizations: String? = nil
    ) {
        self.id = id
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.customizations = customizations
    }
    
    var subtotal: Double {
        return Double(quantity) * unitPrice
    }
}
