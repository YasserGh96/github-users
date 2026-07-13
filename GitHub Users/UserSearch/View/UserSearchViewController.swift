//
//  UserSearchViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 30/11/2022.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

final class UserSearchViewController: MAViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noUsersLabel: UILabel!
    @IBOutlet private weak var userSearchBar: UISearchBar!
    
    // MARK: - Properties
    private var userSearchViewModel = UserSearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    private let emptyStateView = UIStackView()
    private let emptyIconContainer = UIView()
    private let emptyIconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    private let emptyTitleLabel = UILabel()
    private let emptySubtitleLabel = UILabel()
    private let suggestionsStackView = UIStackView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    required init() {
        super.init(nibName: UserSearchViewController.name, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
        setNavigationBar()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupTableView()
        bindComponents()
        bindTableView()
        bindSearchBar()
        bindSpinner()
        bindRefreshControl()
        bindThemeChanges()
		
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    private func setNavigationBar() {
        set(title: .searchUsers)
        setThemeMenu()
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        contentView.backgroundColor = .appBackground

		userSearchBar.placeholder = .searchBarPlaceHolder
        userSearchBar.searchBarStyle = .minimal
        userSearchBar.tintColor = .appPrimary
        userSearchBar.backgroundImage = UIImage()

        if #available(iOS 13.0, *) {
            userSearchBar.searchTextField.backgroundColor = .appSearchBackground
            userSearchBar.searchTextField.textColor = .appTextPrimary
            userSearchBar.searchTextField.leftView?.tintColor = .appTextSecondary
        }

		noUsersLabel.set(text: .Search.emptyTitle, color: .appTextSecondary, font: .semibold(18))
        noUsersLabel.textAlignment = .center
        noUsersLabel.numberOfLines = 0
        noUsersLabel.isHidden = true

        setupEmptyState()
        applyTheme()
    }

    private func setupEmptyState() {
        guard emptyStateView.superview == nil else {
            return
        }

        emptyStateView.axis = .vertical
        emptyStateView.alignment = .center
        emptyStateView.spacing = 14
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        emptyIconContainer.translatesAutoresizingMaskIntoConstraints = false
        emptyIconContainer.addSubview(emptyIconView)

        emptyIconView.translatesAutoresizingMaskIntoConstraints = false
        emptyIconView.contentMode = .scaleAspectFit

        emptyTitleLabel.set(text: .Search.emptyTitle, color: .appTextPrimary, font: .semibold(22))
        emptyTitleLabel.textAlignment = .center
        emptyTitleLabel.numberOfLines = 0

        emptySubtitleLabel.set(text: .Search.emptySubtitle, color: .appTextSecondary, font: .regular(15))
        emptySubtitleLabel.textAlignment = .center
        emptySubtitleLabel.numberOfLines = 0

        suggestionsStackView.axis = .horizontal
        suggestionsStackView.alignment = .center
        suggestionsStackView.distribution = .equalSpacing
        suggestionsStackView.spacing = 8

        String.Search.suggestedQueries.forEach { query in
            suggestionsStackView.addArrangedSubview(makeSuggestionButton(for: query))
        }

        emptyStateView.addArrangedSubview(emptyIconContainer)
        emptyStateView.addArrangedSubview(emptyTitleLabel)
        emptyStateView.addArrangedSubview(emptySubtitleLabel)
        emptyStateView.addArrangedSubview(suggestionsStackView)

        contentView.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyIconContainer.widthAnchor.constraint(equalToConstant: 72),
            emptyIconContainer.heightAnchor.constraint(equalToConstant: 72),
            emptyIconView.centerXAnchor.constraint(equalTo: emptyIconContainer.centerXAnchor),
            emptyIconView.centerYAnchor.constraint(equalTo: emptyIconContainer.centerYAnchor),
            emptyIconView.widthAnchor.constraint(equalToConstant: 32),
            emptyIconView.heightAnchor.constraint(equalToConstant: 32),

            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 24),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -24),
            emptyStateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -28),

            emptyTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -56),
            emptySubtitleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -56)
        ])
    }

    private func makeSuggestionButton(for query: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("@\(query)", for: .normal)
        button.titleLabel?.font = .semibold(14)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.accessibilityIdentifier = query
        button.addTarget(self, action: #selector(suggestionButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 16, right: 0)
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: .Search.refreshTitle)
        refreshControl.tintColor = .appPrimary
        tableView.isHidden = true
    }

    private func setThemeMenu() {
        let currentTheme = AppThemeManager.shared.currentTheme
        let actions = AppTheme.allCases.map { theme in
            UIAction(title: theme.title,
                     image: UIImage(systemName: theme.iconName),
                     state: currentTheme == theme ? .on : .off) { [weak self] _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                AppThemeManager.shared.setTheme(theme)
                self?.setThemeMenu()
                self?.applyTheme()
            }
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: currentTheme.iconName),
            menu: UIMenu(title: .Theme.menuTitle, children: actions)
        )
        navigationItem.rightBarButtonItem?.tintColor = .appPrimary
    }

    private func bindThemeChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appThemeDidChange),
                                               name: .appThemeDidChange,
                                               object: nil)
    }

    @objc private func appThemeDidChange() {
        setThemeMenu()
        applyTheme()
    }

    @objc private func suggestionButtonTapped(_ sender: UIButton) {
        guard let query = sender.accessibilityIdentifier else {
            return
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        userSearchBar.text = query
        userSearchBar.resignFirstResponder()
        userSearchViewModel.getUsers(name: query)
    }

    private func applyTheme() {
        view.backgroundColor = .appBackground
        contentView.backgroundColor = .appBackground
        tableView.backgroundColor = .appBackground
        navigationController?.navigationBar.tintColor = .appTextPrimary
        navigationItem.rightBarButtonItem?.tintColor = .appPrimary

        emptyIconContainer.backgroundColor = .appSurface
        emptyIconContainer.addBorder(radius: 8, width: 1, color: .appBorder)
        emptyIconContainer.addShadow(color: .appShadow, radius: 10, opacity: 1, offset: CGSize(width: 0, height: 6))
        emptyIconContainer.layer.masksToBounds = false
        emptyIconView.tintColor = .appPrimary

        emptyTitleLabel.textColor = .appTextPrimary
        emptySubtitleLabel.textColor = .appTextSecondary

        suggestionsStackView.arrangedSubviews.compactMap { $0 as? UIButton }.forEach { button in
            button.backgroundColor = .appSurface
            button.layer.borderColor = UIColor.appBorder.cgColor
            button.tintColor = .appPrimary
        }

        refreshControl.tintColor = .appPrimary
        refreshControl.attributedTitle = NSAttributedString(
            string: .Search.refreshTitle,
            attributes: [.foregroundColor: UIColor.appTextSecondary]
        )

        if #available(iOS 13.0, *) {
            userSearchBar.searchTextField.backgroundColor = .appSearchBackground
            userSearchBar.searchTextField.textColor = .appTextPrimary
            userSearchBar.searchTextField.leftView?.tintColor = .appTextSecondary
        }
    }
    
    private func navigateToUserFollows(name: String, type: String) {
        let vc = UserFollowsViewController(name: name, type: type)
        navigate(to: vc)
    }

    // MARK: - Binding
    private func bindTableView() {
        tableView.register(cell: UserTableViewCell.self)
        userSearchViewModel.users.drive(tableView.rx.items(cellIdentifier: UserTableViewCell.name, cellType: UserTableViewCell.self)) { [weak self] _, item, cell in
            cell.user = item
            cell.set()
            cell.followersTap.subscribe(onNext: { [weak self] in
                self?.navigateToUserFollows(name: item.login, type: .followers)
            },
                                        onError: nil,
                                        onCompleted: nil,
                                        onDisposed: nil)
                .disposed(by: cell.cellBag)
           
            cell.followingTap.subscribe(onNext: { [weak self] in
                self?.navigateToUserFollows(name: item.login, type: .following)
            },
                                        onError: nil,
                                        onCompleted: nil,
                                        onDisposed: nil)
                .disposed(by: cell.cellBag)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindComponents() {
        userSearchViewModel.isTableHidden
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        userSearchViewModel.isEmptyStateHidden
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)

        userSearchViewModel.emptyMessage
            .drive(onNext: { [weak self] message in
                self?.emptyTitleLabel.text = message
                self?.emptySubtitleLabel.text = self?.emptySubtitle(for: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSpinner() {
        let spinner = spin()
        userSearchViewModel.isLoading
            .map { !$0 }
            .drive(spinner.rx.isHidden)
            .disposed(by: disposeBag)
        
        let footerSpinner = UIActivityIndicatorView(style: .gray)
        if #available(iOS 13.0, *) {
            footerSpinner.style = .medium
        }
        footerSpinner.color = .appPrimary
        footerSpinner.hidesWhenStopped = true
        footerSpinner.startAnimating()
        footerSpinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = footerSpinner
        
        userSearchViewModel.isFooterLoading
            .drive(footerSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.userSearchViewModel.refreshCurrentSearch()
            })
            .disposed(by: disposeBag)

        userSearchViewModel.isRefreshing
            .drive(onNext: { [weak self] isRefreshing in
                guard let self = self else { return }

                if isRefreshing {
                    if !self.refreshControl.isRefreshing {
                        self.refreshControl.beginRefreshing()
                    }
                } else {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        userSearchBar
            .rx
            .text
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .distinctUntilChanged()
            .debounce(.milliseconds(350), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }

                if query.isEmpty {
                    self.userSearchViewModel.clearResults()
                } else {
                    self.userSearchViewModel.getUsers(name: query)
                }
            })
            .disposed(by: disposeBag)
    }

    private func emptySubtitle(for message: String) -> String {
        switch message {
        case String.Search.emptyTitle:
            return .Search.emptySubtitle
        case String.Search.noResults:
            return .Search.noResultsSubtitle
        default:
            return .Search.errorSubtitle
        }
    }
}

// MARK: - UITableViewDelegate
extension UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        let query = userSearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && indexPath.row != 0 && !query.isEmpty {
            if userSearchViewModel.isPagination {
                userSearchViewModel.getUsers(name: query)
            }
        }
    }
}
