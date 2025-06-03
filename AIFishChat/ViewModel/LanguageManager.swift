

import Foundation
import SwiftUI


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
