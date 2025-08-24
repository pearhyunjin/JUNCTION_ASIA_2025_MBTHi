//
//  ConfirmSalesView.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI

struct ConfirmSalesView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var sections: [ScannedSection]
    var onApply: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16).padding(.vertical, 12)
                }
                Spacer()
                Text("판매내역 확인")
                    .font(.title3.weight(.semibold))
                Spacer()
                Color.clear.frame(width: 54, height: 1)
            }
            .padding(.top, 4)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach($sections) { $section in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(section.title)
                                .font(.system(size: 28, weight: .heavy))
                                .padding(.top, 6)

                            ForEach($section.items) { $item in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("메뉴명").font(.caption).foregroundStyle(.secondary)
                                        Spacer()
                                        Text("수량").font(.caption).foregroundStyle(.secondary)
                                    }
                                    HStack(spacing: 12) {
                                        TextField("메뉴 입력", text: $item.name)
                                            .textFieldStyle(.plain)
                                            .padding(.horizontal, 12).frame(height: 48)
                                            .background(RoundedRectangle(cornerRadius: 10).stroke(.mint.opacity(0.4), lineWidth: 1))

                                        TextField("0", value: $item.qty, format: .number)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.trailing)
                                            .textFieldStyle(.plain)
                                            .padding(.horizontal, 12).frame(width: 120, height: 48)
                                            .background(RoundedRectangle(cornerRadius: 10).stroke(.mint.opacity(0.4), lineWidth: 1))
                                    }
                                }
                            }

                            // 섹션 구분선
                            Divider().overlay(Color(.systemTeal)).padding(.top, 6)
                        }
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 120)
                }
                .padding(.top, 8)
            }

            // 하단 큰 버튼
            Button {
                onApply()
            } label: {
                Text("판매내역 반영하기")
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .buttonStyle(.plain)
            .background(Color(.systemTeal))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
    }
}
