//
//  UIView.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit

extension UIView: Nameable {}

extension UIView {
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
    // MARK: - Drop Shadow
    func addShadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    // MARK: - Circle
    func circle() {
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
    
    
    // MARK: - Round Corners
    func addCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    // MARK: - Border
    func addBorder(radius: CGFloat, width: CGFloat, color: UIColor) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        layer.add(animation, forKey: nil)
    }
}


