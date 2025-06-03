//
//  FontHelper.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import Foundation

enum FontHelper {
    case reg, thin, extLight, light, med, semi, bold, extBold, black
    
    func name() -> String {
        switch self {
        case .reg:
            "Inter-Regular"
        case .thin:
            "Inter-Regular_Thin"
        case .extLight:
            "Inter-Regular_ExtraLight"
        case .light:
            "Inter-Regular_Light"
        case .med:
            "Inter-Regular_Medium"
        case .semi:
            "Inter-Regular_SemiBold"
        case .bold:
            "Inter-Regular_Bold"
        case .extBold:
            "Inter-Regular_ExtraBold"
        case .black:
            "Inter-Regular_Black"
        }
    }
}

