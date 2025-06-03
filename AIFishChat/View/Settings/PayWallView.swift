//
//  SettingsView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import SwiftUI
import StoreKit

struct PayWallView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var langMan : LanguageManager
    @EnvironmentObject var subsMan : ApphudSubsManager
    
    let privacyStr = "https://telegra.ph/Privacy-policy-02-28-77"
    let termsStr = "https://telegra.ph/Terms--Conditions-02-28-6"
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20){
                    HStack(alignment: .top){
                        Circle()
                            .frame(width: 26, height: 26)
                            .opacity(0)
                        Spacer()
                        AnimatedLogo(circleRadius: 67, totalWidth: 40, totalHeight: 50)
                        Spacer()
                        Button{
                            dismiss()
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
                    
                    Text("Deep Search AI Plus".localizedString(langMan.currentLanguage))
                        .font(.custom(FontHelper.bold.name(), size: 24))
                        .foregroundStyle(.black)
                    Text("Increase productivity and\ncreativity with enhanced Access".localizedString(langMan.currentLanguage))
                        .foregroundStyle(.black.opacity(0.48))
                        .font(.custom(FontHelper.reg.name(), size: 15))
                        .multilineTextAlignment(.center)
                    Spacer()
                    VStack(alignment: .leading, spacing: 20){
                        PayWallFeature(text: "Unlimited chat with AI")
                        
                        PayWallFeature(text: "Access to an improved version of the assistant")
                        
                        PayWallFeature(text: "Unlimited generation and unlimited promts")
                    }
                    .frame(maxWidth: 266)
                    Spacer()
                    ForEach(subsMan.products, id: \.self){prod in
                        if prod.skProduct.id == "year.prem" {
                            PayWallItemRow(id: prod.skProduct.id, name: "Yearly Plan", desc: "Unlocks all functions", price: prod.skProduct.displayPrice, dur: "year", selectedProd: $subsMan.highlightedProdcut)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        subsMan.highlightedProdcut = prod.skProduct
                                        subsMan.selectedAppHudProduct = prod.appHudProduct
                                    }
                                }
                        } else {
                            PayWallItemRow(id: prod.skProduct.id, name: "Monthly plan", desc: "Unlocks all functions", price: prod.skProduct.displayPrice, dur: "month", selectedProd: $subsMan.highlightedProdcut)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        subsMan.highlightedProdcut = prod.skProduct
                                        subsMan.selectedAppHudProduct = prod.appHudProduct
                                    }
                                }
                                .onAppear{
                                    subsMan.highlightedProdcut = prod.skProduct
                                }
                        }
                    }
                    
                    HStack{
                        Image(.paywlShield)
                            .resizable()
                            .frame(width: 27, height: 27)
                        
                        Text("Cancel anytime".localizedString(langMan.currentLanguage))
                            .font(.custom(FontHelper.reg.name(), size: 13))
                            .foregroundStyle(Color(hex: "#949494"))
                    }
                    
                    Button{
                        Task{
                            await subsMan.makePruchase()
                        }
                    }label: {
                        Text("Continue".localizedString(langMan.currentLanguage))
                            .foregroundStyle(.white)
                            .font(.custom(FontHelper.semi.name(), size: 15))
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color(hex: "#407CF3"))
                            .clipShape(RoundedRectangle(cornerRadius: 41))
                    }
                    
                    HStack{
                        Spacer()
                        
                        Button{
                            Task{
                                await subsMan.restorePurchase()
                            }
                        } label: {
                            Text("Restore".localizedString(langMan.currentLanguage))
                        }
                        
                        Spacer()
                        
                        Button{
                            guard let url = URL(string: termsStr) else {return}
                            if UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Terms".localizedString(langMan.currentLanguage))
                        }
                        
                        Spacer()
                        
                        Button{
                            guard let url = URL(string: privacyStr) else {return}
                            if UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Privacy".localizedString(langMan.currentLanguage))
                        }
                        
                        Spacer()
                    }
                    .font(.custom(FontHelper.reg.name(), size: 14))
                    .foregroundStyle(.black)
                    
                    
                }
                .padding(20)
                .onChange(of: subsMan.hasSubscription) { _ in
                    if subsMan.hasSubscription {
                        dismiss()
                    }
                }
            }
            .padding(.top, 10)
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
            
        }
    }
}

struct PayWallFeature : View {
    let text : String
    @EnvironmentObject var langMan : LanguageManager
    var body: some View {
        HStack(alignment: .center, spacing: 10) { // Align items to the top and add spacing
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 20, height: 15)
                .foregroundStyle(Color(hex: "#407CF3"))
                .frame(width: 32, height: 32)
            
            Text(text.localizedString(langMan.currentLanguage))
                .font(.custom(FontHelper.med.name(), size: 15))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil) // Allow unlimited lines
                .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
        }
    }
}

struct PayWallItemRow : View {
    let id : String
    let name : String
    let desc : String
    let price : String
    let dur : String
    @Binding var selectedProd : Product?
    @EnvironmentObject var langMan : LanguageManager
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading){
                Text(name.localizedString(langMan.currentLanguage))
                    .font(.custom(FontHelper.med.name(), size: 18))

                Text(desc.localizedString(langMan.currentLanguage))
                    .font(.custom(FontHelper.reg.name(), size: 12))
            }
            Spacer()
            Text(price)
                .font(.custom(FontHelper.med.name(), size: 26))
            + Text("/ \(dur.localizedString(langMan.currentLanguage))")
                .font(.custom(FontHelper.reg.name(), size: 11))
                .foregroundColor(.black.opacity(0.47))
                
            
            if id == selectedProd?.id ?? "" {
                ZStack{
                    Circle().stroke(Color(hex:"#407CF3"), lineWidth: 1.5)
                    
                    Circle().fill(Color(hex:"#407CF3"))
                        .frame(width: 12, height: 12)
                }
                .frame(width: 21, height: 21)
                .padding(.leading, 5)
            }
        }
        .foregroundStyle(.black)
        .padding()
        .padding(.horizontal, 5)
        .background(Color(hex: "#9F9F9F").opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 19))
        .overlay {
            if id == selectedProd?.id ?? ""{
                RoundedRectangle(cornerRadius: 19).stroke(Color(hex: "#407CF3"), lineWidth: 2)
            }
        }
        .overlay(alignment: .top) {
            if dur == "year"{
                Text("10% benefit".localizedString(langMan.currentLanguage))
                    .font(.custom(FontHelper.med.name(), size: 14))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(height: 26)
                    .background(LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#67A0FF")], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .offset(y : -13)
            }
        }
    }
}

#Preview {
    PayWallView()
        .environmentObject(LanguageManager())
        .environmentObject(ApphudSubsManager())
}
