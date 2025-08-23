//
//  OCRResult.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct OCRResult: View {
    let result: OCRResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("추출된 텍스트")
                    .font(.headline)
                
                Spacer()
                
                Button("복사") {
                    UIPasteboard.general.string = result.text
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            // 메타데이터
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("신뢰도: \(Int(result.confidence * 100))%")
                        .font(.caption)
                    Spacer()
                    Text("페이지: \(result.numBilledPages)개")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
            
            // 텍스트 결과
            ScrollView {
                Text(result.text)
                    .font(.body)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .frame(maxHeight: APIConstants.UI.maxResultHeight)
        }
    }
}
