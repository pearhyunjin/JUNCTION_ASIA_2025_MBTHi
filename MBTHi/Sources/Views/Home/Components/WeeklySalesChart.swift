//
//  WeeklySalesChart.swift
//  MBTHi
//
//  Created by taeni on 8/24/25.
//

import SwiftUI

// MARK: - Prediction Model (기존과 동일)
struct Prediction: Identifiable {
    let id = UUID()
    let dateLabel: String // "8/24"
    let value: Double
}

// MARK: - WeeklyBarChart (기존 스타일 그대로 유지)
struct WeeklyBarChart: View {
    let preds: [Prediction]
    
    var body: some View {
        let maxY = max(preds.map(\.value).max() ?? 1, 1)
        VStack(alignment: .leading, spacing: 24) {
            ZStack(alignment: .bottomLeading) {
                HStack(alignment: .bottom, spacing: 18) {
                    ForEach(preds) { p in
                        VStack(spacing: 8) {
                            Rectangle()
                                .fill(.normal.opacity(0.7))
                                .frame(width: 11,
                                       height: CGFloat(p.value / maxY) * 90)
                            Text(p.dateLabel)
                                .font(.caption)
                                .foregroundColor(.textFont)
                        }
                    }
                }
                .frame(height: 136)
            }
            .frame(maxWidth:.infinity)
        }
        .background(.light)
        .padding(.horizontal, 16)
    }
}
