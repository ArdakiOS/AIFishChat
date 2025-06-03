//
//  AIFishChatApp.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import SwiftUI
import ApphudSDK
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Apphud.start(apiKey: "app_LjHbydfD2tCxn1J8bh3jGDJe9mKKqu") //PROD KEY
        Apphud.start(apiKey: "app_qzQufrUDpx4RwSgorgiw7qbf8KzFW4") //TEST KEY
        return true
    }
}

@main
struct AIFishChatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var langMan = LanguageManager()
    @StateObject private var subsMan = ApphudSubsManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(langMan)
                .environmentObject(subsMan)
        }
    }
}
