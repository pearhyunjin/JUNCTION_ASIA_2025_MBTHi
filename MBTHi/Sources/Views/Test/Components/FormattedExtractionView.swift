//
//  FormattedExtractionView.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct FormattedExtractionView: View {
    let jsonString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("구조화된 정보")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            // JSON 파싱해서 key-value로 보여주기
            if let data = jsonString.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                if let fields = json["fields"] as? [[String: Any]] {
                    ForEach(Array(fields.enumerated()), id: \.offset) { index, field in
                        if let key = field["key"] as? String,
                           let value = field["refinedValue"] as? String ?? field["value"] as? String {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(key)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(value)
                                    .font(.body)
                                    .padding(.vertical, 2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } else {
                    Text("구조화된 데이터를 파싱할 수 없습니다.")
                        .foregroundColor(.secondary)
                }
            } else {
                Text("JSON 파싱 실패")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}
