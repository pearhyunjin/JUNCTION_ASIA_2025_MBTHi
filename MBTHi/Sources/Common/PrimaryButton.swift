//
//  PrimaryButton.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let style: PrimaryButtonStyle
    let action: (() -> Void)?
    
    init(title: String, style: PrimaryButtonStyle, action: ( () -> Void)?) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    private var buttonLabel: some View {
        HStack(spacing: 8) {
            if style == .mini {
                Image(systemName: "link")
            }
            Text(title)
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .frame(height: style == .mini ? nil : 48)
        .frame(maxWidth: style == .mini ? nil : .infinity)
        .foregroundColor(style.textColor)
        .background(style.backgroundColor)
        .font(style.font)
        .cornerRadius(99)
    }
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            }
        }, label: {
            buttonLabel
        })
        .disabled(!style.isEnable)
    }
}

#Preview {
    // 비활성상태 버튼
    PrimaryButton(title: "비활성화", style: .disable) {
        // 활성, 비활성 통일성을 주고 싶다면 작성을 유지하고 style 조건만 처리해도되고,
        // 아니라면 클로저({ }부분)를 아예 작성하지 않아도 됩니다.
        print("동작 X")
    }
    // 활성상태 버튼
    PrimaryButton(title: "활성화", style: .basic) {
        print("버튼 액션 실행")
    }
    
    // 비활성상태 버튼
    PrimaryButton(title: "구매처", style: .mini) {
        print("구매처 페이지 열기")
    }
}
