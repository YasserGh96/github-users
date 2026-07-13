//
//  SceneDelegate.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 13/07/2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let initialViewController = InitialViewController()
        initialViewController.window = window
        window.rootViewController = initialViewController
        AppThemeManager.shared.applySavedTheme(to: window)
        self.window = window
        window.makeKeyAndVisible()
    }
}
