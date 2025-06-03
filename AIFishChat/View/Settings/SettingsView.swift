//
//  SettingsView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 23.02.2025.
//

import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State var openPayWall = false
    @EnvironmentObject var langMan : LanguageManager
    @EnvironmentObject var subsMan : ApphudSubsManager
    @State var showLangOptions = false
    
    let privacyStr = "https://telegra.ph/Privacy-policy-02-28-77"
    let termsStr = "https://telegra.ph/Terms--Conditions-02-28-6"
    @State private var isShowingMailView = false
    var body: some View {
        ZStack{
            Color(hex: "#F6F6F6").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20){
                    HStack(alignment: .top){
                        Circle()
                            .frame(width: 26, height: 26)
                            .opacity(0)
                        Spacer()
                        Text("Settings".localizedString(langMan.currentLanguage))
                            .font(.custom(FontHelper.semi.name(), size: 20))
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
                    if !subsMan.hasSubscription{
                        PremiumBanner()
                            .onTapGesture {
                                openPayWall.toggle()
                            }
                    }
                    Text("General".localizedString(langMan.currentLanguage))
                        .font(.custom(FontHelper.semi.name(), size: 16))
                    VStack(alignment: .leading, spacing: 15){
                        Button{
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showLangOptions.toggle()
                            }
                        } label: {
                            HStack{
                                Text("Language".localizedString(langMan.currentLanguage))
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                        }
                        
                        if showLangOptions {
                            VStack(alignment: .leading, spacing: 15){
                                ForEach(Languages.allCases, id: \.self){ lang in
                                    Button{
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            langMan.setLanguage(lang.langCode())
                                            showLangOptions.toggle()
                                        }
                                    } label: {
                                        HStack{
                                            Text(lang.displayName())
                                            Spacer()
                                            if lang.langCode() == langMan.currentLanguage{
                                                Image(.checkmark)
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.leading)
                                    }
                                    Rectangle().fill(Color(hex:"#F6F6F6"))
                                        .frame(height: 1)
                                }
                            }
                        }
                        
                    }
                    .font(.custom(FontHelper.med.name(), size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Text("Other".localizedString(langMan.currentLanguage))
                        .font(.custom(FontHelper.semi.name(), size: 16))
                    
                    VStack(alignment: .leading, spacing: 15){
                        Button{
                            guard let url = URL(string: termsStr) else {return}
                            if UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Terms of Use".localizedString(langMan.currentLanguage))
                                .padding(.horizontal)
                        }
                        Rectangle().fill(Color(hex:"#F6F6F6"))
                            .frame(height: 1)
                        Button{
                            guard let url = URL(string: privacyStr) else {return}
                            if UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Privacy Policy".localizedString(langMan.currentLanguage))
                                .padding(.horizontal)
                        }
                        Rectangle().fill(Color(hex:"#F6F6F6"))
                            .frame(height: 1)
                        Button{
                            if MFMailComposeViewController.canSendMail() {
                                isShowingMailView = true
                            } else {
                                print("Cannot send email")
                            }
                        } label: {
                            Text("Contact Us".localizedString(langMan.currentLanguage))
                                .padding(.horizontal)
                        }
                        Rectangle().fill(Color(hex:"#F6F6F6"))
                            .frame(height: 1)
                        Button{
                            requestReview()
                        } label: {
                            Text("Rate Us".localizedString(langMan.currentLanguage))
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                    
                    .font(.custom(FontHelper.med.name(), size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .background(.white)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    
                    Spacer()
                }
                .padding(20)
                .sheet(isPresented: $isShowingMailView) {
                    MailComposerViewController(recipients: ["bachinskiytayln185@gmail.com"], subject: "Support", messageBody: "Hi there")
                }
            }
            
        }
        .foregroundStyle(.black)
        .sheet(isPresented: $openPayWall) {
            PayWallView()
                .presentationCornerRadius(10)
                .presentationDragIndicator(.hidden)
        }
    }
}

func requestReview() {
    if let windowScene = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        SKStoreReviewController.requestReview(in: windowScene)
    }
}

struct MailComposerViewController: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var recipients: [String]
    var subject: String
    var messageBody: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(recipients)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        return mailComposer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposerViewController

        init(_ parent: MailComposerViewController) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(LanguageManager())
        .environmentObject(ApphudSubsManager())
}
