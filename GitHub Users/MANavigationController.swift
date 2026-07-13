//
//  MANavigationController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 30/11/2022.
//

import UIKit

final class MANavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupStatusBar()
    }
    
    // MARK: - Methods
    private func setupUI() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .appSurface
        navigationBar.tintColor = .appTextPrimary
        
        let lineHeight: CGFloat = 1.3
        let line = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: lineHeight))
        line.backgroundColor = .navigationBorder
        
        navigationBar.addSubview(line)
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: CGFloat(lineHeight)).isActive = true
        line.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .appSurface
            appearance.shadowColor = .appBorder
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.appTextPrimary,
                .font: UIFont.semibold(17)
            ]

            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance

            if #available(iOS 15, *) {
                navigationBar.scrollEdgeAppearance = appearance
            }
        } else {
            navigationBar.setBackgroundImage(.empty, for: .default)
            navigationBar.shadowImage = .empty
        }
    }
    
    private func setupStatusBar() {
        let statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
        
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = .clear
        
        view.addSubview(statusBarView)
    }
}
