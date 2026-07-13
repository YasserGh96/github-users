//
//  UserProfileViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 13/07/2026.
//

import UIKit
import RxSwift
import RxCocoa

final class UserProfileViewController: MAViewController {

    // MARK: - Properties
    private let username: String
    private let initialAvatarURL: String
    private let viewModel = UserProfileViewModel()
    private let disposeBag = DisposeBag()

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let headerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStackView = UIStackView()
    private let reposValueLabel = UILabel()
    private let followersValueLabel = UILabel()
    private let followingValueLabel = UILabel()
    private let metadataStackView = UIStackView()
    private let companyRow = UIStackView()
    private let locationRow = UIStackView()
    private let websiteRow = UIStackView()
    private let companyValueLabel = UILabel()
    private let locationValueLabel = UILabel()
    private let websiteValueLabel = UILabel()
    private let openGitHubButton = UIButton(type: .system)
    private let errorLabel = UILabel()

    private var profileURL: URL?

    // MARK: - Init
    required init(username: String, avatarURL: String = "") {
        self.username = username
        self.initialAvatarURL = avatarURL
        super.init(nibName: nil, bundle: nil)
    }

    required init() {
        self.username = ""
        self.initialAvatarURL = ""
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadProfile(username: username)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyTheme()
    }

    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .appBackground
        setBackButton()
        set(title: .Profile.title)
        setupScrollView()
        setupHeaderView()
        setupStatsView()
        setupMetadataView()
        setupOpenGitHubButton()
        setupErrorLabel()
        renderInitialState()
        applyTheme()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)

        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(headerView)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .semibold(26)
        nameLabel.textColor = .appTextPrimary
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.82

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .regular(16)
        usernameLabel.textColor = .appTextSecondary
        usernameLabel.numberOfLines = 1
        usernameLabel.lineBreakMode = .byTruncatingTail

        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.font = .regular(15)
        bioLabel.textColor = .appTextSecondary
        bioLabel.numberOfLines = 0

        headerView.addSubview(avatarImageView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(bioLabel)

        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 196),

            avatarImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 92),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),

            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 18),
            bioLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            bioLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
        ])
    }

    private func setupStatsView() {
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.alignment = .fill
        statsStackView.spacing = 10

        statsStackView.addArrangedSubview(makeStatView(valueLabel: reposValueLabel, title: .Profile.publicRepos))
        statsStackView.addArrangedSubview(makeStatView(valueLabel: followersValueLabel, title: .Profile.followers))
        statsStackView.addArrangedSubview(makeStatView(valueLabel: followingValueLabel, title: .Profile.following))
        contentStackView.addArrangedSubview(statsStackView)
    }

    private func setupMetadataView() {
        metadataStackView.axis = .vertical
        metadataStackView.spacing = 10
        metadataStackView.addArrangedSubview(companyRow)
        metadataStackView.addArrangedSubview(locationRow)
        metadataStackView.addArrangedSubview(websiteRow)
        contentStackView.addArrangedSubview(metadataStackView)

        configureMetadata(row: companyRow, iconName: "building.2", title: .Profile.company, valueLabel: companyValueLabel)
        configureMetadata(row: locationRow, iconName: "location", title: .Profile.location, valueLabel: locationValueLabel)
        configureMetadata(row: websiteRow, iconName: "link", title: .Profile.website, valueLabel: websiteValueLabel)
    }

    private func setupOpenGitHubButton() {
        openGitHubButton.setImage(UIImage(systemName: "arrow.up.right.square"), for: .normal)
        openGitHubButton.setTitle("  \(String.Profile.openGitHub)", for: .normal)
        openGitHubButton.titleLabel?.font = .semibold(16)
        openGitHubButton.tintColor = .white
        openGitHubButton.backgroundColor = .appPrimary
        openGitHubButton.layer.cornerRadius = 8
        openGitHubButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        openGitHubButton.addTarget(self, action: #selector(openGitHubButtonTapped), for: .touchUpInside)
        contentStackView.addArrangedSubview(openGitHubButton)
    }

    private func setupErrorLabel() {
        errorLabel.set(text: "", color: .appTextSecondary, font: .regular(14))
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        contentStackView.addArrangedSubview(errorLabel)
    }

    private func bindViewModel() {
        viewModel.profile
            .drive(onNext: { [weak self] profile in
                self?.render(profile)
            })
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .drive(onNext: { [weak self] message in
                self?.showError(message)
            })
            .disposed(by: disposeBag)

        let spinner = spin()
        viewModel.isLoading
            .map { !$0 }
            .drive(spinner.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func renderInitialState() {
        nameLabel.text = username
        usernameLabel.text = "@\(username)"
        bioLabel.text = .Profile.fallbackBio
        reposValueLabel.text = "0"
        followersValueLabel.text = "0"
        followingValueLabel.text = "0"
        metadataStackView.isHidden = true
        openGitHubButton.isHidden = true

        if !initialAvatarURL.isEmpty {
            avatarImageView.get(with: initialAvatarURL)
        }
    }

    private func render(_ profile: UserProfileModel) {
        set(title: profile.login.isEmpty ? .Profile.title : profile.login)
        profileURL = URL(string: profile.htmlURL)
        nameLabel.text = profile.displayName
        usernameLabel.text = profile.displayUsername
        bioLabel.text = profile.bio.isEmpty ? .Profile.fallbackBio : profile.bio
        reposValueLabel.text = "\(profile.publicRepos)"
        followersValueLabel.text = "\(profile.followers)"
        followingValueLabel.text = "\(profile.following)"
        companyValueLabel.text = profile.company
        locationValueLabel.text = profile.location
        websiteValueLabel.text = profile.blog
        companyRow.isHidden = profile.company.isEmpty
        locationRow.isHidden = profile.location.isEmpty
        websiteRow.isHidden = profile.blog.isEmpty
        metadataStackView.isHidden = profile.company.isEmpty && profile.location.isEmpty && profile.blog.isEmpty
        openGitHubButton.isHidden = !profile.hasProfileLink
        errorLabel.isHidden = true

        if !profile.avatarURL.isEmpty {
            avatarImageView.get(with: profile.avatarURL)
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = message.isEmpty
    }

    private func makeStatView(valueLabel: UILabel, title: String) -> UIView {
        let container = UIView()
        let titleLabel = UILabel()
        let stackView = UIStackView(arrangedSubviews: [valueLabel, titleLabel])

        container.heightAnchor.constraint(greaterThanOrEqualToConstant: 76).isActive = true
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = .semibold(22)
        valueLabel.textColor = .appTextPrimary
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.75
        valueLabel.textAlignment = .center

        titleLabel.set(text: title, color: .appTextSecondary, font: .regular(12))
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75

        container.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    private func configureMetadata(row: UIStackView, iconName: String, title: String, valueLabel: UILabel) {
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        let titleLabel = UILabel()
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])

        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.isLayoutMarginsRelativeArrangement = true
        row.layoutMargins = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)

        iconImageView.tintColor = .appPrimary
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        titleLabel.set(text: title, color: .appTextSecondary, font: .regular(12))
        valueLabel.set(text: .Profile.unavailable, color: .appTextPrimary, font: .semibold(15))
        valueLabel.numberOfLines = 0

        textStackView.axis = .vertical
        textStackView.spacing = 2

        row.addArrangedSubview(iconImageView)
        row.addArrangedSubview(textStackView)
    }

    private func applyTheme() {
        view.backgroundColor = .appBackground
        scrollView.backgroundColor = .appBackground
        headerView.backgroundColor = .appSurface
        headerView.addBorder(radius: 8, width: 1, color: .appBorder)
        headerView.addShadow(color: .appShadow, radius: 8, opacity: 1, offset: CGSize(width: 0, height: 5))
        headerView.layer.masksToBounds = false
        avatarImageView.addBorder(radius: 8, width: 1, color: .appBorder)

        statsStackView.arrangedSubviews.forEach { view in
            view.backgroundColor = .appSurface
            view.addBorder(radius: 8, width: 1, color: .appBorder)
        }

        metadataStackView.arrangedSubviews.forEach { view in
            view.backgroundColor = .appSurface
            view.addBorder(radius: 8, width: 1, color: .appBorder)
        }

        nameLabel.textColor = .appTextPrimary
        usernameLabel.textColor = .appTextSecondary
        bioLabel.textColor = .appTextSecondary
        reposValueLabel.textColor = .appTextPrimary
        followersValueLabel.textColor = .appTextPrimary
        followingValueLabel.textColor = .appTextPrimary
        companyValueLabel.textColor = .appTextPrimary
        locationValueLabel.textColor = .appTextPrimary
        websiteValueLabel.textColor = .appTextPrimary
        openGitHubButton.backgroundColor = .appPrimary
        errorLabel.textColor = .appTextSecondary
    }

    @objc private func openGitHubButtonTapped() {
        guard let profileURL = profileURL else {
            return
        }

        UIApplication.shared.open(profileURL)
    }
}
