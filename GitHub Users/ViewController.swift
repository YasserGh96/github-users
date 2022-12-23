//
//  ViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 27/11/2022.
//

import Foundation
import UIKit

final class ViewController: MAViewController {
    
    var users: [UserModel] = []
    var window: UIWindow?
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
            super.viewDidLoad()
//        api.searchUsers(nextUrl: "next", name: "yas", pageNumber: "1") { [weak self] result in
//            guard let ss = self else { return }
//            if result.success {
//                if let data = result.data as? [UserModel] {
//                    ss.users = data
//                }
//            } else {
//                print(result.errorType)
//            }
        
        
    }
}

