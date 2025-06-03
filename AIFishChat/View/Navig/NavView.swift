//
//  NavView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI

struct NavView: View {
    @StateObject var vm = MainViewModel()
    @State var openSettings = false
    @EnvironmentObject var langMan : LanguageManager
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                HStack{
                    Image(.settingsBtn)
                        .resizable()
                        .frame(width: 26, height: 26)
                        .opacity(0)
                    Spacer()
                    
                    NavTab(curPage: $vm.curPage)
                        .overlay(alignment: .topTrailing, content: {
                            if vm.finishedGeneratingImg{
                                Text("1")
                                    .font(.custom(FontHelper.semi.name(), size: 13))
                                    .foregroundStyle(.white)
                                    .frame(width: 20, height: 20)
                                    .background(Color(hex: "#407CF3"))
                                    .clipShape(Circle())
                                    .offset(x: 5, y: -5)
                            }
                        })
                    
                    Spacer()
                    Button{
                        openSettings = true
                        
                    } label: {
                        Image(.settingsBtn)
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    
                }
                .padding(20)
                switch vm.curPage {
                case .text:
                    TextChatView(vm : vm)
                case .img:
                    ImgGenView(vm : vm)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $openSettings){
            SettingsView()
                .presentationCornerRadius(10)
                .presentationDragIndicator(.hidden)
        }
        .onReceive(vm.timer) { _ in
            if vm.startGeneratingImg {
                if vm.genProgress < 100 {
                    if vm.generatedImgUrl == nil {
                        vm.genProgress = min(vm.genProgress, 90) // Cap at 60 until URL is available
                    }
                    if vm.genProgress < 30 {
                        vm.genProgress += 0.5
                    } else {
                        // Normal speed if image URL is available
                        vm.genProgress += 1
                    }
                } else {
                    // Finish progress when reaching 100
                    if vm.curPage == .text {
                        vm.finishedGeneratingImg = true
                    }
                    vm.startGeneratingImg = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: vm.curPage)
        .padding(.bottom, 5)
    }
}

#Preview {
    NavView()
        .environmentObject(LanguageManager())
}
