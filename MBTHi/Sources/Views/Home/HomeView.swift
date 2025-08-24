//
//  HomeView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Ingredient.name)]) private var ingredients: [Ingredient]
    
    // MARK: Computed Properties
    private var lowStockIngredients: [Ingredient] {
        ingredients.filter { $0.isLowStock }
    }
    
    // MARK: Mock Data (기존과 동일)
    private let weeklyPred: [Prediction] = [
        .init(dateLabel: "8/24", value: 68),
        .init(dateLabel: "8/25", value: 92),
        .init(dateLabel: "8/26", value: 75),
        .init(dateLabel: "8/27", value: 52),
        .init(dateLabel: "8/28", value: 80),
        .init(dateLabel: "8/29", value: 85),
        .init(dateLabel: "8/30", value: 70)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 인사 (기존 스타일)
                greetingHeader
                
                // 소진 임박 재료 (스와이프 카드)
                sectionTitle("소진 임박 재료")
                lowStockCarousel
                
                // 일주일 매출 예측 (기존 스타일)
                sectionTitle("일주일 매출 예측")
                WeeklyBarChart(preds: weeklyPred)
                
                // 현재 재고 현황 + 수정하기 (기존 스타일)
                currentInventoryHeader
                inventoryList
                bottomActionButton
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: Subviews (기존 스타일 그대로)
    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pepper 사장님,")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.darker)
            
            Text("오늘도 좋은 하루 보내세요!")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.darker)
        }
        .padding(.horizontal, 16)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.title2).bold()
            .foregroundStyle(.textGrayFont)
            .padding(.horizontal, 16)
    }
    
    private var lowStockCarousel: some View {
        TabView {
            if lowStockIngredients.isEmpty {
                VStack {
                    Text("소진 임박 재료가 없습니다.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
                .cornerRadius(16)
                .padding(.horizontal, 16)

            } else {
                ForEach(lowStockIngredients) { item in
                    LowStockCard(item: item)
                        .padding(.horizontal, 16)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 180)
    }
    
    private var currentInventoryHeader: some View {
        HStack {
            sectionTitle("현재 재고 현황")
            Spacer()
            Button {
                // 편집 액션은 이후 연결
            } label: {
                Label("수정하기", systemImage: "pencil")
                    .font(.body.weight(.semibold))
            }
            .foregroundStyle(.normal)
            .padding(.trailing, 16)
        }
    }
    
    private var inventoryList: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(spacing: 0) {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\(Int(ingredient.currentStock)) \(ingredient.unit.displayName)")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 12)
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var bottomActionButton: some View {
        Button {
            // 이후: OCR/LLM 파이프라인 연결
        } label: {
            Text("재고 파악하기")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .background(Color("Normal", bundle: .main))
        .foregroundStyle(Color("Light", bundle: .main))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.top, 8)
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
