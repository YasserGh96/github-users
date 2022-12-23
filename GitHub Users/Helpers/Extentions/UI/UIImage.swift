//
//  UIImage.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 30/11/2022.
//

import Foundation
import UIKit

extension UIImage {
    static let empty = UIImage()
    
    func imageToBase64() -> String {
        let imageData:NSData = self.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .endLineWithLineFeed)
        return strBase64
    }
    
    func base64ToImage(imageString: String) -> Data {
        let dataDecoded: Data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!
        return dataDecoded
    }
    
    enum JPEGQuality: CGFloat {
            case lowest  = 0
            case low     = 0.25
            case medium  = 0.5
            case high    = 0.75
            case highest = 1
        }

    func jpeg(_ quality: JPEGQuality) -> Data? {
            return self.jpegData(compressionQuality: quality.rawValue)
        }
}

// MARK: - Get Image
func img(_ name: String) -> UIImage {
    if let img = UIImage(named: name) {
        return img
    } else {
        return .empty
    }
}




