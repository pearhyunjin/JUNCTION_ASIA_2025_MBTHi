//
//  HomeView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import SwiftData

// MARK: - HomeView (MV Pattern)
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Ingredient.name)]) private var ingredients: [Ingredient]
    @Query(sort: [SortDescriptor(\Order.orderDate, order: .reverse)]) private var orders: [Order]
    @Query private var menuOptions: [MenuOption]
    
    @State private var isEditingInventory: Bool = false
    
    // MARK: Computed Properties (Direct Data Access)
    private var lowStockIngredients: [Ingredient] {
        ingredients.filter { $0.isLowStock || $0.currentStock <= 0 }
    }
    
    private var beverageIngredients: [Ingredient] {
        ingredients.filter { ["원두", "우유", "초코파우더"].contains($0.name) }
    }
    
    private var cakeIngredients: [Ingredient] {
        ingredients.filter { !["원두", "우유", "초코파우더"].contains($0.name) }
    }
    
    private var todaySales: Double {
        let today = Calendar.current.startOfDay(for: Date())
        let todayOrders = orders.filter { 
            Calendar.current.isDate($0.orderDate, inSameDayAs: today) && $0.status == .completed
        }
        return todayOrders.reduce(0) { $0 + $1.totalAmount }
    }
    
    private var totalRevenue: Double {
        orders.filter { $0.status == .completed }.reduce(0) { $0 + $1.totalAmount }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 인사말
                GreetingHeader()
                
                // 분석 카드들
                AnalyticsSection(
                    todaySales: todaySales,
                    lowStockCount: lowStockIngredients.count
                )
                
                // 소진 임박 재료
                if !lowStockIngredients.isEmpty {
                    SectionTitle("소진 임박 재료")
                    LowStockCarousel(ingredients: lowStockIngredients)
                }
                
                // 일주일 매출 예측
                SectionTitle("일주일 매출 예측")
                WeeklySalesChart()
                
                // 현재 재고 현황
                InventoryHeader(isEditMode: $isEditingInventory)
                InventoryListSection(
                    beverageIngredients: beverageIngredients,
                    cakeIngredients: cakeIngredients,
                    isEditMode: isEditingInventory
                )
                
                // 하단 액션 버튼
                BottomActionButton()
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: Actions (Direct in View)
    private func openOCRView() {
        print("OCR 화면 열기")
        // NavigationLink 또는 sheet 모달로 OCR 화면 이동
    }
    
    private func updateStock(for ingredient: Ingredient, newStock: Double) {
        ingredient.currentStock = newStock
        ingredient.lastUpdated = Date()
        
        do {
            try modelContext.save()
        } catch {
            print("재고 업데이트 실패: \(error)")
        }
    }
}

// MARK: - Preview
#Preview {
    let container = try! ModelContainer(
        for: Ingredient.self, Recipe.self, MenuOption.self, Order.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    MockDataManager.insertAllMockData(in: container.mainContext)
    
    return HomeView()
        .modelContainer(container)
        .environment(\.locale, .init(identifier: "ko_KR"))
}