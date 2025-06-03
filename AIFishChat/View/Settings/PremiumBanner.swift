//
//  PremiumBanner.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import SwiftUI

struct PremiumBanner: View {
    @EnvironmentObject var langMan : LanguageManager
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 20){
                Text("Deep Search AI Plus".localizedString(langMan.currentLanguage))
                    .font(.custom(FontHelper.bold.name(), size: 18))
                    .foregroundStyle(.white)
                
                Text("Try for free".localizedString(langMan.currentLanguage))
                    .font(.custom(FontHelper.semi.name(), size: 15))
                    .foregroundStyle(LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#67A0FF")], startPoint: .leading, endPoint: .trailing))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 8)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 115)
        .background{
            Image(.premBannerBg)
                .resizable()
        }
    }
}

#Preview {
    PremiumBanner()
        .environmentObject(LanguageManager())
}
