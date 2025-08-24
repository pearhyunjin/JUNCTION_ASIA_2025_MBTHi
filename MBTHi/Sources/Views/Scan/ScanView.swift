//
//  ScanView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI
import PhotosUI

// MARK: - 판매내역 스캔 UI
struct SalesScanView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: SalesScanViewModel
    @State private var pickerItem: PhotosPickerItem?
    @State private var navigateToConfirm = false     // ✅ 자동 전환 플래그

    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreviewView(session: viewModel.camera.session)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerView
                    
                    Spacer()
                    
                    
                    // 2. 앨범 버튼 (패널 위로 오버레이)
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        PrimaryButtonLabel(
                            title: "앨범",
                            style: .mini, // 버튼 크기를 키움
                            iconName: "photo.on.rectangle"
                        )
                    }
                    .padding(.bottom, 20)
                    
                    bottomPanel
                }

                if viewModel.isProcessing {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView("분석 중…")
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .tint(.white)
                }
            }
            .onChange(of: viewModel.sections) { _, newValue in
                if !newValue.isEmpty { navigateToConfirm = true }
            }
            .navigationDestination(isPresented: $navigateToConfirm) {
                ConfirmSalesView(sections: $viewModel.sections) {
                    dismiss()
                }
            }
        }
        .onChange(of: pickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await viewModel.runAnalysis(on: data)
                }
            }
        }
    }

    // MARK: - UI 조각들
    private var headerView: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16).padding(.vertical, 12)
            }
            Spacer()
            Text("판매내역 스캔")
                .font(.title3.weight(.semibold))
            Spacer()
            Color.clear.frame(width: 54, height: 1)
        }
        .padding(.top, 4)
        .background(Color(.systemBackground))
    }

    private var bottomPanel: some View {
        ZStack(alignment: .top) {
            VStack {
                
                Text("금일 판매내역이나 매장 매출 내역을 스캔해 보세요.\n판매내역으로 재고 수량을 파악할 수 있어요.")
                    .font(.footnote)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary) // 흰 배경에 맞게 어두운 텍스트로 변경
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .frame(height: 70)
                
                Button {
                    viewModel.camera.capturePhoto { data in
                        guard let data else { return }
                        Task { await viewModel.runAnalysis(on: data) }
                    }
                } label: {
                    Circle()
                        .strokeBorder(.darkActive, lineWidth: 5)
                        .frame(width: 68, height: 68)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.white)
        }
    }
}
