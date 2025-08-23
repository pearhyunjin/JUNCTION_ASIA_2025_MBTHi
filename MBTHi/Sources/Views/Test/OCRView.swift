//
//  OCRView.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct OCRView: View {
    @State private var selectedImage: UIImage?
    @State private var ocrResult: OCRResponse?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showingImagePicker: Bool = false
    @State private var showingPhotoPicker: Bool = false
    
    private let ocrService = UpstageOCRService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 이미지 선택
                ImageSelectionButtons(
                    showingImagePicker: $showingImagePicker,
                    showingPhotoPicker: $showingPhotoPicker,
                    selectedImage: $selectedImage
                )
                
                // 이미지 미리보기 + 처리 버튼
                if let image = selectedImage {
                    ImagePreview(
                        image: image,
                        isLoading: isLoading,
                        onProcess: processImage,
                        onClear: clearResults
                    )
                }
                
                // OCR 결과
                if let result = ocrResult {
                    OCRResult(result: result)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("OCR 문서 인식")
            .alert("오류", isPresented: .constant(errorMessage != nil)) {
                Button("확인") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private func processImage() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: APIConstants.Network.imageCompressionQuality) else {
            errorMessage = "이미지를 처리할 수 없습니다."
            return
        }
        
        isLoading = true
        errorMessage = nil
        ocrResult = nil
        
        Task {
            do {
                let response = try await ocrService.processDocument(imageData: imageData)
                await MainActor.run {
                    ocrResult = response
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
    private func clearResults() {
        selectedImage = nil
        ocrResult = nil
        errorMessage = nil
    }
}
