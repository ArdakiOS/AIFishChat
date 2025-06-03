//
//  ContentView.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var progress = 0.0
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @State var showPayWall = false
    @EnvironmentObject var subsMan : ApphudSubsManager
    var body: some View {
        ZStack{
            NavView()
            if progress < 1.0 {
                LoadingView(progress: $progress)
            }
        }
        .onAppear{
            if !subsMan.hasSubscription && isFirstLaunch {
                showPayWall = true
            }
        }
        .animation(.easeInOut(duration: 0.9), value: progress)
        .sheet(isPresented: $showPayWall) {
            isFirstLaunch = false
        } content: {
            PayWallView()
                .presentationCornerRadius(10)
                .presentationDragIndicator(.hidden)
        }
        
    }
}

private func dismissKeyboard() {
    UIApplication.shared.windows.first?.endEditing(true)
}

#Preview {
    ContentView()
        .environmentObject(LanguageManager())
        .environmentObject(ApphudSubsManager())
}
