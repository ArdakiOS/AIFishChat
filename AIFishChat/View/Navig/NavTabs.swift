//
//  NavTabs.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI

enum NavTabs : CaseIterable {
    case text, img
    
    func name() -> String{
        switch self {
        case .text:
            "Deep Search"
        case .img:
            "Create img"
        }
    }
}

struct NavTab: View {
    @Binding var curPage : NavTabs
    @EnvironmentObject var langMan : LanguageManager
    var body: some View {
        ZStack(alignment: curPage == .text ? .leading : .trailing){
            RoundedRectangle(cornerRadius: 11).fill(.white)
                .frame(width: 126, height: 35)
            HStack(spacing: 10){
                ForEach(NavTabs.allCases, id: \.self){ tab in
                    Button{
                        curPage = tab
                    } label: {
                        Text(tab.name().localizedString(langMan.currentLanguage))
                            .font(.custom(tab == curPage ? FontHelper.semi.name() : FontHelper.reg.name(), size: 15))
                            .foregroundStyle(tab == curPage ? LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#67A0FF")], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color(hex: "#8E8E8E")], startPoint: .leading, endPoint: .trailing))
                        
                            .frame(maxWidth: .infinity)
                    }
                    
                }
            }
        }
        .padding(.horizontal, 2)
        .frame(width: 247, height: 39)
        .background{
            Color(hex: "#F3F3F3")
        }
        .clipShape(RoundedRectangle(cornerRadius: 13.32))
    }
}

#Preview {
    NavTab(curPage: .constant(.text))
        .environmentObject(LanguageManager())
}
