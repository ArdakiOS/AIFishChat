//
//  StringExt.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 04.03.2025.
//

import Foundation

extension String {
    func localizedString(_ language: String) -> String {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
