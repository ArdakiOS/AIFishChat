

import Foundation
import SwiftUI

enum Languages : CaseIterable{
    case en, ru, fre, esp, ger, ita
    
    func displayName() -> String {
        switch self {
        case .en:
            "English"
        case .ru:
            "Russian"
        case .fre:
            "French"
        case .esp:
            "Spanish"
        case .ger:
            "German"
        case .ita:
            "Italian"
        }
    }
    
    func langCode() -> String{
        switch self {
        case .en:
            "en"
        case .ru:
            "ru"
        case .fre:
            "fr"
        case .esp:
            "es"
        case .ger:
            "de"
        case .ita:
            "it"
        }
    }
}


class LanguageManager: ObservableObject {
    @Published var currentLanguage: String = "en" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            UserDefaults.standard.synchronize()
        }
    }

    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            currentLanguage = savedLanguage
        } else {
            // If no language is saved, use the system language
            let systemLanguage = Locale.current.languageCode ?? "en"
            currentLanguage = systemLanguage
        }
    }

    func setLanguage(_ language: String) {
        currentLanguage = language
    }
}
