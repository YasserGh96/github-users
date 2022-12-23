//
//  Fonts.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit

extension UIFont {
    
    // MARK: - Font Name
    enum AppFont: String {
        case light = "SFProText-Light"
        case regular = "SFProText-Regular"
        case medium = "SFProText-Medium"
        case bold = "SFProText-Bold"
        case semibold = "SFProText-Semibold"

        case lightDisplay = "SFProDisplay-Light"
        case regularDisplay = "SFProDisplay-Regular"
        case mediumDisplay = "SFProDisplay-Medium"
        case semiboldDisplay = "SFProDisplay-Semibold"
        case boldDisplay = "SFProDisplay-Bold"
        
        case cairo = "Cairo-VariableFont_wght"
    }
    
    // MARK: - SF Pro Text
    class func light(_ size: CGFloat) -> UIFont {
        getFont(.light, size: size)
    }
    
    class func regular(_ size: CGFloat) -> UIFont {
        getFont(.regular, size: size)
    }
    
    class func medium(_ size: CGFloat) -> UIFont {
        getFont(.medium, size: size)
    }
    
    class func bold(_ size: CGFloat) -> UIFont {
        getFont(.bold, size: size)
    }
 
    class func semibold(_ size: CGFloat) -> UIFont {
        getFont(.semibold, size: size)
    }
    
    // MARK: - SF Pro Display
    class func lightDisplay(_ size: CGFloat) -> UIFont {
        getFont(.light, size: size)
    }
    
    class func regularDisplay(_ size: CGFloat) -> UIFont {
        getFont(.regular, size: size)
    }
    
    class func mediumDisplay(_ size: CGFloat) -> UIFont {
        getFont(.medium, size: size)
    }
    
    class func boldDisplay(_ size: CGFloat) -> UIFont {
        getFont(.bold, size: size)
    }
 
    class func semiboldDisplay(_ size: CGFloat) -> UIFont {
        getFont(.semibold, size: size)
    }
    
    // MARK: - Cairo
    class func cairo(_ size: CGFloat) -> UIFont {
        getFont(.cairo, size: size)
    }
}

