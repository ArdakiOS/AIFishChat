//
//  UIApplicationExt.swift
//  AIFishChat
//
//  Created by Ardak Tursunbayev on 22.02.2025.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
