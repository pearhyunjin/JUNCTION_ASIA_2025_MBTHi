//
//  PrimaryButtonStyle.swift
//  MBTHi
//
//  Created by 배현진 on 8/24/25.
//

import SwiftUI

enum PrimaryButtonStyle {
    case basic
    case disable
    case mini
    
    var textColor: Color {
        switch self {
        case .basic:
            return .lightHover
        case .disable:
            return .white
        case .mini:
            return .lightHover
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .basic:
            return .normal
        case .disable:
            return .gray
        case .mini:
            return .darkActive
        }
    }
    
    var isEnable: Bool {
        switch self {
        case .basic:
            return true
        case .disable:
            return false
        case .mini:
            return true
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .basic, .disable:
            return 0
        case .mini:
            return 10
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .basic, .disable:
            return 15
        case .mini:
            return 8
        }
    }
    
    var font: Font {
        switch self {
        case .basic, .disable:
            return .system(size: 18, weight: .semibold, design: .default)
        case .mini:
            return .system(size: 14, weight: .semibold, design: .default)
        }
    }
}
