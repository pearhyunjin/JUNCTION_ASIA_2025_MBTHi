//
//  DailySalesData.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//


//
//  WeeklySalesChart.swift
//  MBTHi
//
//  Created by AI Assistant on 8/24/25.
//

import SwiftUI
import Charts

// MARK: - 일일 매출 데이터 모델
struct DailySalesData: Identifiable {
    let id = UUID()
    let dateLabel: String
    let sales: Double
    let isToday: Bool
}

// MARK: - 주간 매출 차트 (Swift Charts)
struct WeeklySalesChart: View {
    
    // Mock 데이터 (View에서 직접 관리)
    private let weeklyData: [DailySalesData] = [
        DailySalesData(dateLabel: "8/24", sales: 68000, isToday: true),
        DailySalesData(dateLabel: "8/25", sales: 92000, isToday: false),
        DailySalesData(dateLabel: "8/26", sales: 75000, isToday: false),
        DailySalesData(dateLabel: "8/27", sales: 52000, isToday: false),
        DailySalesData(dateLabel: "8/28", sales: 80000, isToday: false),
        DailySalesData(dateLabel: "8/29", sales: 85000, isToday: false),
        DailySalesData(dateLabel: "8/30", sales: 70000, isToday: false)
    ]
    
    private var maxSales: Double {
        weeklyData.map(\.sales).max() ?? 100000
    }
    
    var body: some View {
        Chart(weeklyData) { data in
            BarMark(
                x: .value("날짜", data.dateLabel),
                y: .value("매출", data.sales)
            )
            .foregroundStyle(
                data.isToday ? 
                    Color.normal : Color.normal.opacity(0.7)
            )
            .cornerRadius(6, style: .continuous)
        }
        .frame(height: 160)
        .chartYScale(domain: 0...maxSales * 1.15)
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(count: 4)) { value in
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.2))
                
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text("\(Int(doubleValue/1000))K")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.light.opacity(0.8))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

// MARK: - 실제 데이터 기반 차트 (확장용)
struct DynamicWeeklySalesChart: View {
    let orders: [Order]
    
    private var chartData: [DailySalesData] {
        generateChartData(from: orders)
    }
    
    private var maxSales: Double {
        chartData.map(\.sales).max() ?? 100000
    }
    
    var body: some View {
        Chart(chartData) { data in
            BarMark(
                x: .value("날짜", data.dateLabel),
                y: .value("매출", data.sales)
            )
            .foregroundStyle(
                data.isToday ? 
                    Color.normal : Color.normal.opacity(0.7)
            )
            .cornerRadius(6, style: .continuous)
        }
        .frame(height: 160)
        .chartYScale(domain: 0...maxSales * 1.15)
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(count: 4)) { value in
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.2))
                
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text("\(Int(doubleValue/1000))K")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.light.opacity(0.8))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    // View 내부에서 데이터 생성 (MV Pattern)
    private func generateChartData(from orders: [Order]) -> [DailySalesData] {
        let calendar = Calendar.current
        let today = Date()
        var chartData: [DailySalesData] = []
        
        // 지난 7일간 데이터 생성
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -6 + i, to: today) else { continue }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d"
            let dateLabel = dateFormatter.string(from: date)
            
            // 해당 날짜의 주문 매출 계산
            let dayOrders = orders.filter { order in
                calendar.isDate(order.orderDate, inSameDayAs: date) && order.status == .completed
            }
            let daySales = dayOrders.reduce(0) { $0 + $1.totalAmount }
            
            // 데이터가 없으면 Mock 데이터 사용
            let finalSales = daySales > 0 ? daySales : Double.random(in: 40000...90000)
            
            chartData.append(DailySalesData(
                dateLabel: dateLabel,
                sales: finalSales,
                isToday: calendar.isDate(date, inSameDayAs: today)
            ))
        }
        
        return chartData
    }
}

// MARK: - 프리뷰
#Preview {
    VStack(spacing: 20) {
        Text("Mock 데이터 차트")
            .font(.headline)
        WeeklySalesChart()
        
        Text("실제 데이터 차트")
            .font(.headline)  
        DynamicWeeklySalesChart(orders: [])
    }
    .padding()
}