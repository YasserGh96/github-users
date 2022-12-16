//
//  UIImageView.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    // MARK: - Set Icon
    func set(icon: UIImage) {
        image = icon
        contentMode = .center
        clipsToBounds = false
    }
    
    func set(aspectFill: UIImage) {
        image = aspectFill
        contentMode = .scaleAspectFill
        clipsToBounds = false
    }
    
    func set(toFit: UIImage) {
        image = toFit
        contentMode = .scaleAspectFit
        clipsToBounds = false
    }
    
    func set(toFill: UIImage) {
        image = toFill
        contentMode = .scaleToFill
        clipsToBounds = true
    }
    
    // MARK: - Get Icon/Image
    func get(with string: String) {
        if let url = URL(string: string) {
            kf.setImage(with: url)
            contentMode = .scaleToFill
            clipsToBounds = true
        }
    }
}
