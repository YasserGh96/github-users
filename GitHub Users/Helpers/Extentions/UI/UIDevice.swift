//
//  UIDevice.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 30/11/2022.
//

import UIKit

extension UIDevice {
    
    // MARK: - Notch
    static var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}
