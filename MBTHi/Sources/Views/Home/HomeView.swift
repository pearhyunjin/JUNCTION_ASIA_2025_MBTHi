//
//  HomeView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import SwiftData

// MARK: - Prediction Model (목업 데이터 유지)
struct Prediction: Identifiable {
    let id = UUID()
    let dateLabel: String // "8/24"
    let value: Double
}

// MARK: - HomeView
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Ingredient.name)]) private var ingredients: [Ingredient]
    
    // MARK: Computed Properties
    private var lowStockIngredients: [Ingredient] {
        ingredients.filter { $0.isLowStock }
    }
    
    // MARK: Mock Data (일부 유지)
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
                // 인사
                greetingHeader
                
                // 소진 임박 재료 (스와이프 카드)
                sectionTitle("소진 임박 재료")
                lowStockCarousel
                
                // 일주일 매출 예측
                sectionTitle("일주일 매출 예측")
                WeeklyBarChart(preds: weeklyPred)
                    .padding(.horizontal, 16)
                
                // 현재 재고 현황 + 수정하기
                currentInventoryHeader
                inventoryList
                bottomActionButton
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: Subviews
    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pepper 사장님,")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color("Darker", bundle: .main) ?? Color(.label))
            Text("오늘도 좋은 하루 보내세요!")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.title2).bold()
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
            Text("현재 재고 현황")
                .font(.title2).bold()
            Spacer()
            Button {
                // 편집 액션은 이후 연결
            } label: {
                Label("수정하기", systemImage: "pencil")
                    .font(.body.weight(.semibold))
            }
            .foregroundStyle(Color("Normal", bundle: .main) ?? Color(.systemGreen))
        }
        .padding(.horizontal, 16)
    }
    
    private var inventoryList: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(spacing: 0) {
                    ForEach(ingredients) {
                        ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\\(Int(ingredient.currentStock)) \\(ingredient.unit.displayName)")
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

// MARK: - LowStock Card
private struct LowStockCard: View {
    let item: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 카테고리는 Ingredient 모델에 없으므로 일단 제거
            Text(item.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(.label))
            
            HStack(alignment: .bottom, spacing: 6) {
                Text("\\(Int(item.currentStock))")
                    .font(.title.weight(.semibold))
                    .foregroundStyle(Color(.systemRed))
                Text(item.unit.displayName)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 2)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                // 구매처 링크는 모델에 없으므로 비활성화된 버튼으로 표시
                Label("구매처", systemImage: "link")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.5))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Light", bundle: .main))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Weekly Bar Chart (Simple)
private struct WeeklyBarChart: View {
    let preds: [Prediction]
    
    var body: some View {
        let maxY = max(preds.map(\.value).max() ?? 1, 1)
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                HStack(alignment: .bottom, spacing: 18) {
                    ForEach(preds) { p in
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("Normal", bundle: .main).opacity(0.7))
                                .frame(width: 18,
                                       height: CGFloat(p.value / maxY) * 120)
                            Text(p.dateLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .frame(height: 160)
        }
    }
}

//// MARK: - Preview
//#Preview {
//    let container = try! ModelContainer(for: Ingredient.self, Recipe.self, MenuOption.self, Order.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    // MockDataManager를 사용하여 Preview를 위한 데이터 주입
//    MockDataManager.insertAllMockData(in: container.mainContext)
//    
//    return HomeView()
//        .modelContainer(container)
//        .environment(\.locale, .init(identifier: "ko_KR"))
//}
