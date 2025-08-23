//
//  OrderStatus.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

enum OrderStatus: String, CaseIterable, Codable {
    case completed = "완료"
    case cancelled = "취소" // 환불
    
    var displayName: String {
        return self.rawValue
    }
}
