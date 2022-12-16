//
//  MAViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 30/11/2022.
//


import UIKit

class MAViewController: UIViewController {
   
    
    // MARK: - Properties
    var hamburger: UIBarButtonItem?
    var notificaiton: UIBarButtonItem?
    
    var hasNotch: Bool {
        return UIDevice.hasNotch
    }
    
    public override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - Lifecycle
    deinit {
        log("💥 \(className)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Nameable
extension MAViewController: Nameable {}

// MARK: - Navigation Bar
extension MAViewController {
    
    // set custom back button
    func setBackButton() {
        navigationItem.hidesBackButton = true
        
        let arrow = UIImage.back_arrow_en.withRenderingMode(.alwaysOriginal)
        let back = UIBarButtonItem(image: arrow,
                                   style: .plain,
                                   target: self,
                                   action: #selector(goBack(sender:)))
        
        navigationItem.leftBarButtonItem = back
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // set title of navigation bar
    func set(title: String) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.semibold(17)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.title = title
    }

    func navigate(to viewController: MAViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Spinner
extension MAViewController {
    fileprivate func spinnerPosition() -> CGRect {
        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height
        let navBarHeight: CGFloat = !(navigationController?.navigationBar.isHidden ?? false) ? navigationBarHeight() : 0
        let x: CGFloat = (UIScreen.main.bounds.width / 2) - (width / 2)
        let y: CGFloat = (UIScreen.main.bounds.height / 2) - (height / 2) - navBarHeight
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }
    
    @discardableResult
    func spin() -> MASpinnerView {
        let spinner = MASpinnerView(frame: spinnerPosition())
        spinner.backgroundColor = .clear
        spinner.alpha = 0
        
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
        
        UIView.animate(withDuration: 0.3) {
            spinner.alpha = 1
        }
        return spinner
    }
}

