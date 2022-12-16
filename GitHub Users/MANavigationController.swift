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
        navigationBar.setBackgroundImage(.empty, for: .default)
        navigationBar.shadowImage = .empty
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        
        let lineHeight: CGFloat = 1.3
        let line = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: lineHeight))
        line.backgroundColor = .navigationBorder
        
        navigationBar.addSubview(line)
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: CGFloat(lineHeight)).isActive = true
        line.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setupStatusBar() {
        let statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
        
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = .clear
        
        view.addSubview(statusBarView)
    }
}
