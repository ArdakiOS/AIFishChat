//
//  SuccessPopUp.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 04.03.2025.
//

import SwiftUI

struct SuccessPopUp: View {
    let text : String
    @EnvironmentObject var langMan : LanguageManager
    var body: some View {
        HStack{
            Image(.checkmark)
                .resizable()
                .frame(width: 20, height: 20)
            Text(text.localizedString(langMan.currentLanguage))
                .font(.custom(FontHelper.med.name(), size: 16))
                .foregroundStyle(.white)
        }
        .padding()
        .background{
            Color(hex: "#407CF3")
        }
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}

#Preview {
    SuccessPopUp(text: "Text copied")
        .environmentObject(LanguageManager())
}
