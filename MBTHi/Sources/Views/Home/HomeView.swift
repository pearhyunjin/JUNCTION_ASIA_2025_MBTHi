//
//  HomeView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import PhotosUI

// MARK: - Mock Models
struct LowStockItem: Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let quantityText: String      // "2봉(500g)"
    let quantityHighlight: String // "2봉" 처럼 강조할 부분
    let purchaseURL: URL?         // 구매처 링크 (목)
}

struct Prediction: Identifiable {
    let id = UUID()
    let dateLabel: String // "8/24"
    let value: Double
}

struct InventoryItem: Identifiable {
    let id = UUID()
    let name: String
    let value: String // "2봉(500g)"
}

struct InventorySectionModel: Identifiable {
    let id = UUID()
    let title: String
    let items: [InventoryItem]
}

// MARK: - HomeView
struct HomeView: View {
    // MARK: Mock Data
    private let lowStockItems: [LowStockItem] = [
        .init(category: "음료", name: "원두", quantityText: "2봉(500g)", quantityHighlight: "2봉", purchaseURL: URL(string: "https://example.com")),
        .init(category: "음료", name: "우유",  quantityText: "3팩(900ml)", quantityHighlight: "3팩", purchaseURL: URL(string: "https://example.com")),
        .init(category: "디저트", name: "초코 소스", quantityText: "1통(800g)", quantityHighlight: "1통", purchaseURL: URL(string: "https://example.com"))
    ]
    
    private let weeklyPred: [Prediction] = [
        .init(dateLabel: "8/24", value: 68),
        .init(dateLabel: "8/25", value: 92),
        .init(dateLabel: "8/26", value: 75),
        .init(dateLabel: "8/27", value: 52),
        .init(dateLabel: "8/28", value: 80),
        .init(dateLabel: "8/29", value: 85),
        .init(dateLabel: "8/30", value: 70)
    ]
    
    private let inventorySections: [InventorySectionModel] = [
        .init(title: "음료 재료", items: [
            .init(name: "원두", value: "2봉(500g)"),
            .init(name: "우유", value: "20팩(900ml)"),
            .init(name: "초코 소스", value: "5통(800g)")
        ]),
        .init(title: "디저트 재료", items: [
            .init(name: "버터", value: "4개(454g)"),
            .init(name: "설탕", value: "2봉(1kg)")
        ])
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
                .foregroundStyle(Color("DeepGreen", bundle: .main) ?? Color(.label))
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
            ForEach(lowStockItems) { item in
                LowStockCard(item: item)
                    .padding(.horizontal, 16)
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
            .foregroundStyle(Color("DeepGreen", bundle: .main) ?? Color(.systemGreen))
        }
        .padding(.horizontal, 16)
    }
    
    private var inventoryList: some View {
        VStack(spacing: 16) {
            ForEach(inventorySections) { section in
                VStack(alignment: .leading, spacing: 8) {
                    Text(section.title)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    VStack(spacing: 0) {
                        ForEach(section.items) { row in
                            HStack {
                                Text(row.name)
                                Spacer()
                                Text(row.value)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 12)
                            Divider()
                                .padding(.leading, 0)
                        }
                    }
                    .padding(.horizontal, 0)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var bottomActionButton: some View {
        Button {
            // 이후: OCR/LLM 파이프라인 연결
        } label: {
            Text("재고 파악하기")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
        .background(Color(.systemTeal))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - LowStock Card
private struct LowStockCard: View {
    let item: LowStockItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.category)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(item.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(.label))
            
            HStack(spacing: 6) {
                Text(item.quantityHighlight)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(.systemRed))
                Text(item.quantityText.replacingOccurrences(of: item.quantityHighlight, with: ""))
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                if let url = item.purchaseURL {
                    Link(destination: url) {
                        Label("구매처", systemImage: "link")
                            .font(.body.weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color("DeepGreen", bundle: .main) ?? Color(.systemGreen))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                } else {
                    Button {
                        // 이후 연결
                    } label: {
                        Label("구매처", systemImage: "link")
                            .font(.body.weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color("DeepGreen", bundle: .main) ?? Color(.systemGreen))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: 160)
        .background(Color(.systemTeal).opacity(0.10))
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
                                .fill(Color(.systemTeal).opacity(0.5))
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

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.locale, .init(identifier: "ko_KR"))
    }
}
