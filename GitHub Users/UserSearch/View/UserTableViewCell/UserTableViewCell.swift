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
    var user = UserModel()
    var followersTap: Observable<Void> {
        return followersButton.bindTap()
    }
    
    var followingTap: Observable<Void> {
        return FollowingButton.bindTap()
    }
    var cellBag: DisposeBag = DisposeBag()
    
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
        contentView.backgroundColor = .clear
        
        boxView.backgroundColor = .clear
        boxView.addBorder(radius: 15, width: 1, color: .border_medium_grey)
        avatarView.addBorder(radius: 10, width: 1, color: .border_medium_grey)
        
    }
    
    func set() {
        avatar.get(with: user.avatar_url)
        
        nameLabel.set(text: user.login, color: .black, font: .semibold(16))
        
        followersButton.set(filledBlue: .followers)
        FollowingButton.set(filledBlue: .following)
    }
}
