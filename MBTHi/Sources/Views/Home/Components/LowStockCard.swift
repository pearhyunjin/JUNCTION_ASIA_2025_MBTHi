//
//  LowStockCard.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import SwiftUI

// MARK: - LowStock Card (기존 스타일 그대로)
struct LowStockCard: View {
    let item: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 카테고리는 Ingredient 모델에 없으므로 일단 제거
            Text(item.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(.label))
            
            HStack(alignment: .bottom, spacing: 6) {
                Text("\(Int(item.currentStock))")
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
                    .background(.gray.opacity(0.5))
                    .foregroundStyle(.white.opacity(0.8))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.light)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}