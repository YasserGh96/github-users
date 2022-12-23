//
//  InitialViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 01/12/2022.
//

import Foundation
import UIKit
import Lottie

final class InitialViewController: MAViewController {
    
    // MARK: - Properties
    var window: UIWindow?
    private var animationView: AnimationView = AnimationView()
    
    // MARK: - Init
    required init() {
        super.init(nibName: InitialViewController.name, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView = .init(name: .gitHubLogo)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.5
        view.addSubview(animationView)
        animationView.play(completion: { success in
            if success {
                self.openSearchVC()
            }
        })
    }
    
    // MARK: - Methods
    private func openSearchVC() {
        let userSearchVC = UserSearchViewController()
        
        let navigation = MANavigationController(rootViewController: userSearchVC)
        navigation.modalPresentationStyle = .overFullScreen
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
