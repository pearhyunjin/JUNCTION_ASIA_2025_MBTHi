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
    @State private var showSalesScan = false
    
    // MARK: Computed Properties
    private var lowStockIngredients: [Ingredient] {
        ingredients.filter { $0.isLowStock }
    }
    
    private var beverageIngredients: [Ingredient] {
        ingredients.filter { ["원두", "우유", "초코파우더"].contains($0.name) }
    }
    
    private var dessertIngredients: [Ingredient] {
        ingredients.filter { !["원두", "우유", "초코파우더"].contains($0.name) }
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
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // 인사
                    greetingHeader
                        .padding(.bottom, 12)
                    
                    // 소진 임박 재료 (스와이프 카드)
                    sectionTitle("소진 임박 재료")
                    lowStockCarousel
                        .padding(.bottom, 16)
                    
                    // 일주일 매출 예측
                    sectionTitle("일주일 매출 예측")
                    WeeklyBarChart(preds: weeklyPred)
                        .padding(.bottom, 12)
                    
                    // 현재 재고 현황 + 수정하기
                    VStack(spacing: 0) {
                        currentInventoryHeader
                        inventoryList
                    }
                }
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
            .fullScreenCover(isPresented: $showSalesScan) {
                SalesScanView(
                    viewModel: SalesScanViewModel(
                        ocrService: UpstageOCRService(),
                        chatService: UpstageChatService()
                    )
                )
            }
            
            VStack {
                Spacer()
                
                bottomActionButton
                    .padding(.vertical, 16)
            }
        }
        .padding(.horizontal, 16)
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
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.title2).bold()
            .foregroundStyle(.textGrayFont)
    }
    
    private var cardWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 16 * 2 // 양쪽 패딩
        let spacing: CGFloat = 12 // 카드 간격
        let nextCardPreview: CGFloat = 30 // 다음 카드 미리보기 영역
        
        return screenWidth - padding - spacing - nextCardPreview
    }
    
    private var lowStockCarousel: some View {
        Group {
            if lowStockIngredients.isEmpty {
                emptyStockView
                    .frame(height: 127)
                    .padding(.horizontal, 16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(lowStockIngredients) { item in
                            LowStockCard(item: item)
                                .frame(width: cardWidth)
                        }
                    }
                }
                .frame(height: 127)
            }
        }
    }

    private var emptyStockView: some View {
        VStack {
            Text("소진 임박 재료가 없습니다.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding()
        }
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }

    
    //    private var lowStockCarousel: some View {
    //        TabView {
    //            if lowStockIngredients.isEmpty {
    //                VStack {
    //                    Text("소진 임박 재료가 없습니다.")
    //                        .font(.headline)
    //                        .foregroundColor(.secondary)
    //                        .padding()
    //                }
    //                .frame(height: 127)
    //                .padding(.vertical, 20)
    //                .background(Color(.systemGray5))
    //                .cornerRadius(10)
    //
    //            } else {
    //                ForEach(lowStockIngredients) { item in
    //                    LowStockCard(item: item)
    //                }
    //            }
    //        }
    //        .tabViewStyle(.page(indexDisplayMode: .never))
    //        .frame(height: 127)
    //    }
    
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
        .frame(height: 49)
    }
    
    private var inventoryList: some View {
        VStack(spacing: 0) {
            // 음료 재료 섹션
            inventorySection(
                title: "음료 재료",
                ingredients: beverageIngredients
            )
            
            // 디저트 재료 섹션
            inventorySection(
                title: "디저트 재료",
                ingredients: dessertIngredients
            )
        }
    }
    
    private func inventorySection(title: String, ingredients: [Ingredient]) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.normal)
                .frame(height: 1)
                .padding(.top, 5)
            
            // 섹션 헤더
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.textFont)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.bottom, 10)
            
            // 상단 구분선
            Rectangle()
                .fill(.light)
                .frame(height: 1)
            
            // 재료 목록
            VStack(spacing: 0) {
                ForEach(ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                            .font(.body)
                            .foregroundColor(.textGrayFont)
                        
                        Spacer()
                        
                        Text(formatStock(ingredient))
                            .font(.body)
                            .foregroundColor(.textFont)
                    }
                    .padding(.vertical, 12)
                    
                    // 마지막 항목이 아니면 구분선 추가
                    if ingredient.id != ingredients.last?.id {
                        Divider()
                    }
                }
            }
            
            // 섹션 간 여백 (마지막 섹션이 아닌 경우)
            if title != "디저트 재료" {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 20)
            } else {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 16)
            }
        }
    }
    
    
    private var bottomActionButton: some View {
        PrimaryButton(
            title: "재고 파악하기",
            style: .basic)
        {
            showSalesScan = true
        }
    }
    
    private func formatStock(_ ingredient: Ingredient) -> String {
        let stock = ingredient.currentStock
        let minimum = ingredient.minimumStock
        let name = ingredient.name
        
        switch ingredient.unit {
        case .gram:
            // 특정 재료별 맞춤 포맷팅
            switch name {
            case "원두":
                if stock >= 1000 {
                    let packages = Int(stock / minimum) // 250g 기준
                    return "\(packages)봉(\(Int(stock))g)"
                } else {
                    return "\(Int(stock))g"
                }
            case "초코파우더":
                let packages = Int(stock / minimum) // 160g 기준
                return "\(packages)통(\(Int(stock))g)"
            case "시트용과자":
                let packages = Int(stock / minimum) // 194g 기준 (이미지 참고)
                return "\(packages)개(\(Int(stock))g)"
            case "버터":
                let packages = Int(stock / minimum) // 454g 기준 (이미지 참고)
                return "\(packages)개(\(Int(stock))g)"
            case "설탕":
                if stock >= 1000 {
                    let packages = Int(stock / minimum) // 2kg 기준
                    return "\(packages)봉(\(String(format: "%.1f", Double(stock)/1000))kg)"
                } else {
                    return "\(Int(stock))g"
                }
            case "사워크림":
                let packages = Int(stock / minimum) // 450g 기준
                return "\(packages)통 \(Int(stock))g"
            case "연유":
                let packages = Int(stock / minimum) // 500g 기준
                return "\(packages)통(\(Int(stock))g)"
            case "생크림":
                let packages = Int(stock / minimum) // 500g 기준
                return "\(packages)통(\(Int(stock))g)"
            case "화이트초콜릿":
                let packages = Int(stock / minimum) // 400g 기준
                return "\(packages)개(\(Int(stock))g)"
            case "박력분":
                if stock >= 1000 {
                    let packages = Int(stock / minimum) // 2.5kg 기준
                    return "\(packages)개(\(String(format: "%.1f", Double(stock)/1000))kg)"
                } else {
                    return "\(Int(stock))g"
                }
            case "말차파우더":
                let packages = Int(stock / minimum) // 300g 기준
                return "\(packages)개(\(Int(stock))g)"
            default:
                if stock >= 1000 {
                    let packages = Int(stock / minimum)
                    return "\(packages)봉(\(Int(stock))g)"
                } else {
                    return "\(Int(stock))g"
                }
            }
        case .milliliter:
            if name == "우유" {
                let packs = Int(stock / 900) // 900ml 기준
                return "\(packs)팩(\(Int(stock))ml)"
            } else {
                if stock >= 1000 {
                    let packs = Int(stock / 1000)
                    return "\(packs)팩(\(Int(stock))ml)"
                } else {
                    return "\(Int(stock))ml"
                }
            }
        case .piece:
            switch name {
            case "계란":
                let packs = Int(stock / 30) // 30개 한 판
                return "\(packs)판(\(Int(stock))개)"
            case "라임":
                return "\(Int(stock))봉지(\(String(format: "%.0f", stock))kg)"
            case "화이트 초코":
                let packs = Int(stock / 2) // 2개입
                return "\(packs)통(\(Int(stock))개입)"
            case "얼그레이 티백":
                let packs = Int(stock / 25) // 25개입
                return "\(packs)통(\(Int(stock))개입)"
            default:
                return "\(Int(stock))개"
            }
        default:
            return "\(Int(stock))\(ingredient.unit.displayName)"
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
