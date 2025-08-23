//
//  Item.swift
//  MBTHi
//
//  Created by 배현진 on 8/23/25.
//

import Foundation
import SwiftData

@Model
final class Stock {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
