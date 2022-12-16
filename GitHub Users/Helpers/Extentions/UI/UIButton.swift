//
//  UIButton.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit

extension UIButton {
    
    // MARK: - Set Title
    func set(title: String?) {
        setTitle(title, for: .normal)
        
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
    }
    
    func set(color: UIColor?) {
        setTitleColor(color, for: .normal)
    }
    
    func set(font: UIFont?) {
        titleLabel?.font = font
    }
    
    func set(title: String?, color: UIColor?, font: UIFont?) {
        set(title: title)
        set(color: color)
        set(font: font)
    }
}
