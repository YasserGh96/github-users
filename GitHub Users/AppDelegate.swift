//
//  AppDelegate.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 27/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - Start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // app.delegate = self

        start()
        return true
    }

    // MARK: UISceneSession Lifecycle

    
    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
       
        let vc = InitialViewController()
        vc.window = window
        
        
        window?.rootViewController = vc

        window?.makeKeyAndVisible()

    }
    
}

