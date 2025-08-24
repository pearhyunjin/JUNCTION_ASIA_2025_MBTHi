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
                Color(.systemBackground).ignoresSafeArea()
                VStack(spacing: 0) {
                    headerView
                    ZStack {
                        CameraPreviewView(session: viewModel.camera.session)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemGray5))
                            .clipped()

                        // 촬영 버튼 (카메라 영역 하단)
                        VStack {
                            Spacer()
                            Button {
                                viewModel.camera.capturePhoto { data in
                                    guard let data else { return }
                                    Task { await viewModel.runAnalysis(on: data) }
                                }
                            } label: {
                                Circle()
                                    .strokeBorder(.white.opacity(0.95), lineWidth: 5)
                                    .frame(width: 68, height: 68)
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    bottomPanel
                }

                if viewModel.isProcessing {
                    Color.black.opacity(0.35).ignoresSafeArea()
                    ProgressView("분석 중…")
                        .padding(14)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            // ✅ sections가 들어오면 자동 네비게이션
            .onChange(of: viewModel.sections) { _, newValue in
                if !newValue.isEmpty { navigateToConfirm = true }
            }
            // ✅ 목적지
            .navigationDestination(isPresented: $navigateToConfirm) {
                ConfirmSalesView(sections: $viewModel.sections) {
                    // “판매내역 반영하기” 완료 시, 바텀시트 닫기 등 원하는 동작
                    dismiss()
                }
            }
        }
        .onChange(of: pickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await viewModel.runAnalysis(on: data) // 앨범 → 즉시 분석
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
        VStack(spacing: 16) {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                HStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle").font(.title3.weight(.semibold))
                    Text("앨범").font(.title3.weight(.semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 22).padding(.vertical, 14)
                .background(Color("DeepGreen", bundle: .main) ?? Color(.systemGreen))
                .clipShape(Capsule())
            }
            .contentShape(Rectangle())

            Text("금일 판매내역이나 매장 매출 내역을 스캔해 보세요.\n판매내역으로 재고 수량을 파악할 수 있어요.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("DeepGreen", bundle: .main) ?? Color(.systemGreen))
                .padding(.horizontal, 24)
                .padding(.bottom, 2)
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
//        .background(Color(.systemBackground))
    }
}
