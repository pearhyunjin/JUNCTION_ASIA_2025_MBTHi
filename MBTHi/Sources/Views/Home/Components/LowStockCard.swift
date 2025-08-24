//
//  LowStockCard.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import SwiftUI

import SwiftUI

struct LowStockCard: View {
    let item: Ingredient
    @State private var showSafari = false
    
    var body: some View {
        HStack(spacing: 12) {
            // 카테고리는 Ingredient 모델에 없으므로 일단 제거
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.textGrayFont)
                    .padding(.bottom, 10)
                
                HStack(alignment: .bottom, spacing: 6) {
                    Text(formattedStockAmount)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .padding(20)
            
            Spacer()
            
            VStack {
                PrimaryButton(title: "구매처", style: .mini, iconName: "link") {
                    showSafari = true
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: item.purchaseLink)!)
                }
                .padding(20)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(.light)
        .cornerRadius(10)
        .frame(height: 127)
    }
    
    // 재고량을 포맷팅하는 계산된 속성
    private var formattedStockAmount: String {
        let stock = item.currentStock
        
        switch item.unit {
        case .gram:
            if stock >= 1000 {
                let packages = Int(stock / 500) // 500g 단위 포장
                return "\(packages) 봉(\(Int(stock))g)"
            } else {
                return "\(Int(stock))g"
            }
        case .milliliter:
            if stock >= 1000 {
                let packs = Int(stock / 1000) // 1L 단위 포장
                return "\(packs) 팩(\(Int(stock))ml)"
            } else {
                return "\(Int(stock)) ml"
            }
        case .piece:
            return "\(Int(stock)) 개"
        default:
            return "\(Int(stock)) \(item.unit.displayName)"
        }
    }
}


#Preview {
    LowStockCard(item: Ingredient.mockData[0])
}

