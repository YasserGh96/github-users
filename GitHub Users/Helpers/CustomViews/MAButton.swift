//
//  MAButton.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 21/09/2021.
//

import Foundation
import UIKit
import RxSwift

final class MAButton: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var BackgroundView: UIView!
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Properties
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupNib()
    }
    
    private func setupNib() {
        Bundle.main.loadNibNamed(MAButton.name, owner: self, options: nil)
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(view)
        
        clearUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clearUI()
    }
    
    // MARK: - Methods
    private func clearUI() {
        view.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        BackgroundView.layer.cornerRadius = 6
    }
    
    func disable() {
        button.isEnabled = false
        button.alpha = 0.6
    }
    
    func enable() {
        button.isEnabled = true
        button.alpha = 1
    }
}

//MARK: - Button
extension MAButton {
    func target(target: Any?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setInvalid() {
        button.isEnabled = false
    }
    
    func setValid() {
        button.isEnabled = true
    }
    
    func bindTap() -> Observable<Void> {
        return button.rx.tap.asObservable()
    }
}

//MARK: - Button Filled
extension MAButton {
    func set(filled title: String) {
        BackgroundView.backgroundColor = .main_red
        button.set(title: title, color: .white, font: .semibold(17))
    }
    
    func set(filled title: String, borderColor: UIColor, backgroundColor: UIColor, icon: UIImage) {
        BackgroundView.backgroundColor = backgroundColor
        BackgroundView.addBorder(radius: 6, width: 1, color: borderColor)
        button.set(title: title, color: .main_red, font: .semibold(17))
        
    }
    
    func set(filledBlue title: String) {
        BackgroundView.backgroundColor = .systemBlue
        button.set(title: title, color: .white, font: .semibold(17))
    }

}

//MARK: - Button Transparent
extension MAButton {
    func set(transparent title: String) {
        BackgroundView.addBorder(radius: 6, width: 1, color: .main_red)
        BackgroundView.backgroundColor = .clear
        button.set(title: title, color: .main_red, font: .semibold(17))
    }
    
}

