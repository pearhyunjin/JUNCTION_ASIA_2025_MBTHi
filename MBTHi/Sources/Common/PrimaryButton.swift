//
//  PrimaryButton.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI

// MARK: - PrimaryButtonLabel (재사용을 위해 분리)
struct PrimaryButtonLabel: View {
    let title: String
    let style: PrimaryButtonStyle
    let iconName: String?
    
    var body: some View {
        HStack(spacing: 8) {
            if let iconName = iconName {
                Image(systemName: iconName)
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
}

// MARK: - PrimaryButton
struct PrimaryButton: View {
    let title: String
    let style: PrimaryButtonStyle
    let iconName: String?
    let action: (() -> Void)?
    
    init(title: String, style: PrimaryButtonStyle, iconName: String? = nil, action: ( () -> Void)?) {
        self.title = title
        self.style = style
        self.iconName = iconName
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            }
        }, label: {
            PrimaryButtonLabel(title: title, style: style, iconName: iconName)
        })
        .disabled(!style.isEnable)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 10) {
        PrimaryButton(title: "비활성화", style: .disable, action: {})
        
        PrimaryButton(title: "활성화", style: .basic, action: {})
        
        PrimaryButton(title: "구매처", style: .mini, iconName: "link") {}
        
        PrimaryButton(title: "앨범", style: .basic, iconName: "photo.on.rectangle") {}
    }
    .padding()
}