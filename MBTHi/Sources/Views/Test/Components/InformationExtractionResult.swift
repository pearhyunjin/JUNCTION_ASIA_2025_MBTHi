//
//  InformationExtractionResult.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct InformationExtractionResult: View {
    let result: InformationExtractionResponse
    @State private var showRawJSON: Bool = false
    @State private var showFormattedView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 헤더
            HStack {
                Text("추출된 정보")
                    .font(.headline)
                
                Spacer()
                
                Button("복사") {
                    UIPasteboard.general.string = result.rawResponse
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            // 기본 정보
            if let confidence = result.confidence,
               let documentType = result.documentType {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("문서 타입: \(documentType)")
                            .font(.caption)
                        Spacer()
                        Text("신뢰도: \(Int(confidence * 100))%")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            }
            
            // 보기 옵션
            HStack(spacing: 15) {
                Button(showFormattedView ? "원본 JSON" : "구조화된 보기") {
                    showFormattedView.toggle()
                }
                .font(.caption)
                .foregroundColor(.blue)
                
                Button(showRawJSON ? "접기" : "전체 JSON 보기") {
                    showRawJSON.toggle()
                }
                .font(.caption)
                .foregroundColor(.green)
            }
            
            // JSON 결과
            ScrollView {
                if showFormattedView {
                    FormattedExtractionView(jsonString: result.rawResponse)
                } else {
                    Text(showRawJSON ? result.rawResponse : formatPreview(result.rawResponse))
                        .font(.system(.caption, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .frame(maxHeight: APIConstants.UI.maxResultHeight)
        }
    }
    
    private func formatPreview(_ jsonString: String) -> String {
        // JSON을 예쁘게 포맷팅 (미리보기용)
        guard let data = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let formattedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let formattedString = String(data: formattedData, encoding: .utf8) else {
            return String(jsonString.prefix(500)) + "..."
        }
        
        return showRawJSON ? formattedString : String(formattedString.prefix(1000)) + "\n\n... (전체 JSON 보기 버튼 클릭)"
    }
}
