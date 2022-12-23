//
//  UILabel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit

extension UILabel {
    
    // MARK: - Set Text, Color, Font
    func set(text: String) {
        self.text = text
    }
    
    func set(color: UIColor) {
        textColor = color
    }
    
    func set(font: UIFont) {
        self.font = font
    }
    
    func set(text: String, color: UIColor, font: UIFont) {
        set(text: text)
        set(color: color)
        set(font: font)
    }
    
    
    func set(uppercased: String) {
        text = uppercased.uppercased()
    }
    
    func set(uppercased: String, color: UIColor, font: UIFont) {
        set(uppercased: uppercased)
        set(font: font)
        set(color: color)
    }
    
    
    // MARK: - Alignment
    func align(to alignment: NSTextAlignment) {
        textAlignment = alignment
    }
    //@TODO refactor!!!
//    func alignment() {
//        textAlignment = lang == .ar ? .right : .left
//    }
    
    func centerAlignment() {
        textAlignment = .center
    }
}
