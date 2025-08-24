//
//  DataHelpers.swift
//  MBTHi
//
//  Created by AI Assistant on 8/24/25.
//

import Foundation
import SwiftUI

// MARK: - 데이터 계산 헬퍼 (Static Functions)
struct DataCalculator {
    
    /// 오늘 매출 계산
    static func calculateTodaySales(from orders: [Order]) -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        let todayOrders = orders.filter { 
            Calendar.current.isDate($0.orderDate, inSameDayAs: today) && $0.status == .completed
        }
        return todayOrders.reduce(0) { $0 + $1.totalAmount }
    }
    
    /// 매출 성장률 계산 (어제 대비)
    static func calculateSalesGrowth(from orders: [Order]) -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        
        let todayOrders = orders.filter { 
            Calendar.current.isDate($0.orderDate, inSameDayAs: today) && $0.status == .completed
        }
        let yesterdayOrders = orders.filter {
            Calendar.current.isDate($0.orderDate, inSameDayAs: yesterday) && $0.status == .completed
        }
        
        let todaySales = todayOrders.reduce(0) { $0 + $1.totalAmount }
        let yesterdaySales = yesterdayOrders.reduce(0) { $0 + $1.totalAmount }
        
        guard yesterdaySales > 0 else { return 0 }
        return ((todaySales - yesterdaySales) / yesterdaySales) * 100
    }
    
    /// 재고 건강도 점수 계산
    static func calculateStockHealth(from ingredients: [Ingredient]) -> Double {
        guard !ingredients.isEmpty else { return 100 }
        let healthyCount = ingredients.filter { !$0.isLowStock }.count
        return (Double(healthyCount) / Double(ingredients.count)) * 100
    }
    
    /// 재고 상태별 필터링
    static func filterIngredientsByStatus(_ ingredients: [Ingredient]) -> (critical: [Ingredient], low: [Ingredient], healthy: [Ingredient]) {
        let critical = ingredients.filter { $0.currentStock <= 0 }
        let low = ingredients.filter { $0.isLowStock && $0.currentStock > 0 }
        let healthy = ingredients.filter { !$0.isLowStock }
        
        return (critical: critical, low: low, healthy: healthy)
    }
}

// MARK: - 포맷팅 헬퍼
struct FormatHelper {
    
    /// 통화 포맷팅
    static func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: amount)) ?? "₩0"
    }
    
    /// 재고량 포맷팅
    static func formatStock(_ ingredient: Ingredient) -> String {
        let stock = Int(ingredient.currentStock)
        
        switch ingredient.unit {
        case .gram:
            if ingredient.currentStock >= 1000 {
                let packages = Int(ingredient.currentStock / 500)
                return "\(packages)봉(\(stock)g)"
            }
            return "\(stock)g"
        case .milliliter:
            if ingredient.currentStock >= 1000 {
                let packs = Int(ingredient.currentStock / 1000)
                return "\(packs)팩(\(stock)ml)"
            }
            return "\(stock)ml"
        case .piece:
            return "\(stock)개"
        default:
            return "\(stock)\(ingredient.unit.displayName)"
        }
    }
    
    /// 백분율 포맷팅
    static func formatPercentage(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", value))%"
    }
    
    /// 재료 카테고리 결정
    static func categoryForIngredient(_ name: String) -> String {
        let beverageIngredients = ["원두", "우유", "초코파우더"]
        return beverageIngredients.contains(name) ? "음료" : "케이크"
    }
}

// MARK: - 색상 헬퍼
struct ColorHelper {
    
    /// 재고 상태별 색상
    static func stockStatusColor(for ingredient: Ingredient) -> Color {
        if ingredient.currentStock <= 0 {
            return .red
        } else if ingredient.isLowStock {
            return .orange
        } else {
            return .green
        }
    }
    
    /// 매출 성장률별 색상
    static func growthColor(for percentage: Double) -> Color {
        return percentage >= 0 ? .green : .red
    }
    
    /// 재고 건강도별 색상
    static func healthColor(for score: Double) -> Color {
        switch score {
        case 90...100: return .green
        case 70..<90: return .blue
        case 50..<70: return .orange
        default: return .red
        }
    }
}

// MARK: - Mock 데이터 생성 헬퍼
struct MockDataHelper {
    
    /// 주간 매출 예측 Mock 데이터
    static func generateWeeklySalesPrediction() -> [DailySalesData] {
        let dates = ["8/24", "8/25", "8/26", "8/27", "8/28", "8/29", "8/30"]
        let mockValues = [68000, 92000, 75000, 52000, 80000, 85000, 70000]
        
        return zip(dates, mockValues).map { date, value in
            DailySalesData(
                dateLabel: date,
                sales: Double(value),
                isToday: date == "8/24"
            )
        }
    }
}