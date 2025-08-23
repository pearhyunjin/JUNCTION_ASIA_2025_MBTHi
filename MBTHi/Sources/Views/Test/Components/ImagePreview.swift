//
//  ImagePreview.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct ImagePreview: View {
    let image: UIImage
    let isLoading: Bool
    let onProcess: () -> Void
    let onClear: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: APIConstants.UI.maxImageHeight)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            HStack(spacing: 15) {
                Button("텍스트 추출") {
                    onProcess()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
                
                Button("다시 선택") {
                    onClear()
                }
                .buttonStyle(.bordered)
                .disabled(isLoading)
            }
            
            if isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("텍스트를 추출하는 중...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
