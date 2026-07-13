//
//  UserTableViewCell.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import UIKit
import RxSwift

final class UserTableViewCell: MATableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var boxView: UIView!
    @IBOutlet private weak var avatarView: UIView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var followersButton: MAButton!
    @IBOutlet private weak var FollowingButton: MAButton!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    
    // MARK: - Properties
    private var hide: Bool = false
    private var buttonsStackConstraints: [NSLayoutConstraint] = []
    private var hiddenNameTrailingConstraint: NSLayoutConstraint?
    var user = UserModel()
    var cellBag: DisposeBag = DisposeBag()

    var followersTap: Observable<Void> {
        return followersButton.bindTap()
    }
    
    var followingTap: Observable<Void> {
        return FollowingButton.bindTap()
    }
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellBag = DisposeBag()
    }
    
    // MARK: - Methods
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        buttonsStackConstraints = boxView.constraints.filter {
            $0.firstItem === buttonsStackView || $0.secondItem === buttonsStackView
        }
        hiddenNameTrailingConstraint = nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: boxView.trailingAnchor, constant: -16)
        boxView.heightAnchor.constraint(greaterThanOrEqualToConstant: 88).isActive = true

        boxView.backgroundColor = .appSurface
        boxView.addBorder(radius: 14, width: 1, color: .appBorder)
        boxView.addShadow(color: .appShadow, radius: 10, opacity: 1, offset: CGSize(width: 0, height: 6))
        boxView.layer.masksToBounds = false

        avatarView.backgroundColor = .appElevatedSurface
        avatarView.addBorder(radius: 12, width: 1, color: .appBorder)
        
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byTruncatingMiddle
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.85
        
        buttonsStackView.isHidden = hide
    }
    
    func set(hide: Bool = false) {
        self.hide = hide
        setButtons(hidden: hide)
        avatar.get(with: user.avatar_url)
        
        nameLabel.set(text: user.login, color: .appTextPrimary, font: .semibold(17))
        
        followersButton.set(filledBlue: .followers)
        FollowingButton.set(filledBlue: .following)
        
        applyTheme()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyTheme()
    }

    private func setButtons(hidden: Bool) {
        buttonsStackView.isHidden = hidden
        buttonsStackConstraints.forEach { $0.isActive = !hidden }
        hiddenNameTrailingConstraint?.isActive = hidden
    }

    private func applyTheme() {
        boxView.backgroundColor = .appSurface
        boxView.layer.borderColor = UIColor.appBorder.cgColor
        boxView.layer.shadowColor = UIColor.appShadow.cgColor
        avatarView.backgroundColor = .appElevatedSurface
        avatarView.layer.borderColor = UIColor.appBorder.cgColor
        nameLabel.textColor = .appTextPrimary
    }
}
