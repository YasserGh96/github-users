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
    @IBOutlet private weak var followingButton: MAButton!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    
    // MARK: - Properties
    private let accentView = UIView()
    private let userIdLabel = UILabel()
    private var hide: Bool = false
    private var buttonsStackConstraints: [NSLayoutConstraint] = []
    private var hiddenNameTrailingConstraint: NSLayoutConstraint?
    private var userIdTrailingToButtonsConstraint: NSLayoutConstraint?
    private var userIdTrailingToBoxConstraint: NSLayoutConstraint?
    var user = UserModel()
    var cellBag: DisposeBag = DisposeBag()

    var followersTap: Observable<Void> {
        return followersButton.bindTap().do(onNext: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        })
    }
    
    var followingTap: Observable<Void> {
        return followingButton.bindTap().do(onNext: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        })
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
        boxView.heightAnchor.constraint(greaterThanOrEqualToConstant: 96).isActive = true
        setupCardDetails()

        boxView.backgroundColor = .appSurface
        boxView.addBorder(radius: 8, width: 1, color: .appBorder)
        boxView.addShadow(color: .appShadow, radius: 8, opacity: 1, offset: CGSize(width: 0, height: 5))
        boxView.layer.masksToBounds = false

        avatarView.backgroundColor = .appElevatedSurface
        avatarView.addBorder(radius: 8, width: 1, color: .appBorder)
        
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
        
        nameLabel.set(text: "@\(user.login)", color: .appTextPrimary, font: .semibold(17))
        userIdLabel.set(text: "\(String.Search.idPrefix) #\(user.id)", color: .appTextSecondary, font: .regular(13))
        
        followersButton.set(filledBlue: .followers)
        followingButton.set(filledBlue: .following)
        
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
        userIdTrailingToButtonsConstraint?.isActive = !hidden
        userIdTrailingToBoxConstraint?.isActive = hidden
    }

    private func setupCardDetails() {
        accentView.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.numberOfLines = 1
        userIdLabel.lineBreakMode = .byTruncatingTail

        boxView.insertSubview(accentView, at: 0)
        boxView.addSubview(userIdLabel)

        userIdTrailingToButtonsConstraint = userIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonsStackView.leadingAnchor, constant: -10)
        userIdTrailingToBoxConstraint = userIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: boxView.trailingAnchor, constant: -16)
        userIdTrailingToBoxConstraint?.priority = .defaultLow
        userIdTrailingToButtonsConstraint?.isActive = true

        NSLayoutConstraint.activate([
            accentView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor),
            accentView.topAnchor.constraint(equalTo: boxView.topAnchor),
            accentView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor),
            accentView.widthAnchor.constraint(equalToConstant: 4),

            userIdLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }

    private func applyTheme() {
        boxView.backgroundColor = .appSurface
        boxView.layer.borderColor = UIColor.appBorder.cgColor
        boxView.layer.shadowColor = UIColor.appShadow.cgColor
        accentView.backgroundColor = .appPrimary
        avatarView.backgroundColor = .appElevatedSurface
        avatarView.layer.borderColor = UIColor.appBorder.cgColor
        nameLabel.textColor = .appTextPrimary
        userIdLabel.textColor = .appTextSecondary
    }
}
