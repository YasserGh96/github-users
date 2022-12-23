//
//  UIFont.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit

extension UIFont {
    
    // MARK: - Font Names
    class func logAllFonts() {
        for family: String in UIFont.familyNames {
            print(family)
            
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
    // MARK: - Get Font
    static func getFont(_ name: UIFont.AppFont, size: CGFloat) -> UIFont {
        getFont(name: name.rawValue, size: size)
    }
    
    static func getFont(name: String, size: CGFloat) -> UIFont {
        var fontName: String = name
        
        if let appFont = UIFont.AppFont.init(rawValue: name) {
            fontName = appFont.rawValue
        }
        
        if let font = UIFont(name: fontName, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

