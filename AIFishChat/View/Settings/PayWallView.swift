//
//  SettingsView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import SwiftUI

struct PayWallView: View {
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: 10){
                HStack(alignment: .top){
                    Circle()
                        .frame(width: 26, height: 26)
                        .opacity(0)
                    Spacer()
                    Image(.logo)
                        .resizable()
                        .frame(width: 113, height: 113)
                    Spacer()
                    Button{
                        
                    }label: {
                        Image(systemName: "xmark").resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 26, height: 26)
                            .background(Color(hex: "#B5B5B5").opacity(0.48))
                            .clipShape(Circle())
                    }
                }
                
                Text("Get Fish Plus")
                    .font(.custom(FontHelper.bold.name(), size: 24))
                    .foregroundStyle(.black)
                Text("Increase productivity and\ncreativity with enhanced Access")
                    .foregroundStyle(.black.opacity(0.48))
                    .font(.custom(FontHelper.reg.name(), size: 15))
                    .multilineTextAlignment(.center)
                VStack(alignment: .leading, spacing: 20){
                    PayWallFeature(text: "Unlimited chat with AI")
                    
                    PayWallFeature(text: "Access to an improved version of the assistant")
                    
                    PayWallFeature(text: "Unlimited generation and unlimited promts")
                }
                .frame(maxWidth: 266)
                
            }
            .padding(20)
        }
    }
}

struct PayWallFeature : View {
    let text : String
    var body: some View {
        HStack{
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 20, height: 15)
                .foregroundStyle(Color(hex: "#407CF3"))
                .frame(width: 32, height: 32)
            
            Text(text)
                .font(.custom(FontHelper.med.name(), size: 15))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    PayWallView()
}
