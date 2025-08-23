//
//  ImageSelectionButtons.swift
//  test
//
//  Created by taeni on 8/23/25.
//

import SwiftUI
import PhotosUI

struct ImageSelectionButtons: View {
    @Binding var showingImagePicker: Bool
    @Binding var showingPhotoPicker: Bool
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 15) {
            Text("이미지를 선택하세요")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                Button("사진 선택") {
                    showingPhotoPicker = true
                }
                .frame(width: APIConstants.UI.buttonSize.width, height: APIConstants.UI.buttonSize.height)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(10)
                
                Button("카메라") {
                    showingImagePicker = true
                }
                .frame(width: APIConstants.UI.buttonSize.width, height: APIConstants.UI.buttonSize.height)
                .background(Color.green.opacity(0.1))
                .foregroundColor(.green)
                .cornerRadius(10)
            }
        }
        .photosPicker(isPresented: $showingPhotoPicker, selection: Binding<PhotosPickerItem?>(
            get: { nil },
            set: { item in
                Task {
                    if let item = item,
                       let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            selectedImage = image
                        }
                    }
                }
            }
        ), matching: .images)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
