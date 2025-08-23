//
//  InformationExtractionView.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI

struct InformationExtractionView: View {
    @State private var selectedImage: UIImage?
    @State private var extractionResult: InformationExtractionResponse?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showingImagePicker: Bool = false
    @State private var showingPhotoPicker: Bool = false
    @State private var selectedModel: String = APIConstants.Models.receiptExtraction
    
    private let extractionService = UpstageInformationExtractionService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 모델 선택
                VStack(alignment: .leading, spacing: 10) {
                    Text("추출 모델 선택")
                        .font(.headline)
                    
                    Picker("모델", selection: $selectedModel) {
                        Text("영수증 추출").tag(APIConstants.Models.receiptExtraction)
                        // 나중에 다른 모델들 추가 가능
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
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
                
                // 추출 결과
                if let result = extractionResult {
                    InformationExtractionResult(result: result)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("정보 추출")
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
        extractionResult = nil
        
        Task {
            do {
                let response = try await extractionService.extractInformation(
                    imageData: imageData,
                    model: selectedModel
                )
                await MainActor.run {
                    extractionResult = response
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
        extractionResult = nil
        errorMessage = nil
    }
}

