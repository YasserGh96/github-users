//
//  UIViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 30/11/2022.
//

import UIKit

extension UIViewController {
    
    var className: String {
        nibName ?? "@*"
    }
    
    // MARK: - ContentView Height
    func contentViewHeight() -> CGFloat {
        var result: CGFloat = 0

        result = UIScreen.main.bounds.size.height
        result -= navigationController?.navigationBar.frame.size.height ?? 0
        result -= tabBarController?.tabBar.frame.size.height ?? 0
        
        if #available(iOS 13.0, *) {
            var statusBarHeight: CGFloat = 0
            
            if let window = UIApplication.shared.windows.filter ({ $0.isKeyWindow }).first {
                if let scene = window.windowScene {
                    if let barManager = scene.statusBarManager {
                        statusBarHeight = barManager.statusBarFrame.height
                    }
                }
            }
            
            if statusBarHeight == 0 {
                result -= UIApplication.shared.statusBarFrame.height
            } else {
                result -= statusBarHeight
            }
        } else {
            result -= UIApplication.shared.statusBarFrame.height
        }
        
        return result
    }
    
    // MARK: - NavigationBar Height
    func navigationBarHeight() -> CGFloat {
        var result: CGFloat = 0

        result += navigationController?.navigationBar.frame.size.height ?? 0
        
        if #available(iOS 13.0, *) {
            var statusBarHeight: CGFloat = 0
            
            if let window = UIApplication.shared.windows.filter ({ $0.isKeyWindow }).first {
                if let scene = window.windowScene {
                    if let barManager = scene.statusBarManager {
                        statusBarHeight = barManager.statusBarFrame.height
                    }
                }
            }
            
            if statusBarHeight == 0 {
                result += UIApplication.shared.statusBarFrame.height
            } else {
                result += statusBarHeight
            }
        } else {
            result += UIApplication.shared.statusBarFrame.height
        }
        
        return result
    }
}
