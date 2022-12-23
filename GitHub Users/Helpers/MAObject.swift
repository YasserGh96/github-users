//
//  MAObject.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import UIKit

class MAObject: NSObject {
    
    // MARK: - Properties
    var isSelected: Bool = false
    
    // MARK: - Init
    override init() {
        super.init()
        
        isSelected = false
    }
}
