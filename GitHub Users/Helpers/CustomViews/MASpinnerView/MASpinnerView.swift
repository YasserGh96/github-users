//
//  MASpinnerView.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 11/30/22.
//

import Foundation
import UIKit

final class MASpinnerView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    static let tag: Int = 130_220_310_000
    var requestTag: Endpoint?
    var spin: Bool = false
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViewFromNib()
    }
    
    fileprivate func setupViewFromNib() {
        let bundle: Bundle = Bundle(for: type(of: self))
        let nib: UINib = UINib(nibName: "MASpinnerView", bundle: bundle)
        
        if nib.instantiate(withOwner: self, options: nil).indices.contains(0) {
            if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
                view.frame = bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                setupUI()
                
                addSubview(view)
            }
        }
    }
    
    private func setupUI() {
        tag = MASpinnerView.tag
        
        backgroundColor = .clear
        view.backgroundColor = .clear
        backgroundView.backgroundColor = .appElevatedSurface
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.addBorder(radius: 16, width: 1, color: .appBorder)
        backgroundView.addShadow(color: .appShadow, radius: 12, opacity: 1, offset: CGSize(width: 0, height: 8))
        backgroundView.layer.masksToBounds = false
        
        spinner.startAnimating()
        if #available(iOS 13.0, *) {
            spinner.style = .large
        } else {
            spinner.style = .whiteLarge
        }
        spinner.color = .appPrimary
        
    }
    func stop() {
    }
}
