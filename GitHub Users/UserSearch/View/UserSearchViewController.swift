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
    
    // MARK: - Propertis
    var window: UIWindow?
    private var userSearchViewModel = UserSearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
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
		
    }
    
    // MARK: - Methods
    private func setNavigationBar() {
        set(title: .searchUsers)
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
        noUsersLabel.isHidden = false
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 16, right: 0)
        tableView.keyboardDismissMode = .onDrag
        tableView.isHidden = true
    }
    
    private func navigateToUserFollows(name: String, type: String) {
        let vc = UserFollowsViewController(name: name, type: type)
        navigate(to: vc)
    }

    // MARK: - Binding
    private func bindTableView() {
        tableView.register(cell: UserTableViewCell.self)
        userSearchViewModel.users.bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.name, cellType: UserTableViewCell.self)) { (row,item,cell) in
            cell.user = item
            cell.set()
            cell.followersTap.subscribe(onNext: { self.navigateToUserFollows(name: item.login, type: .followers) },
                                        onError: nil,
                                        onCompleted: nil,
                                        onDisposed: nil)
                .disposed(by: cell.cellBag)
           
            cell.followingTap.subscribe(onNext: { self.navigateToUserFollows(name: item.login, type: .following) },
                                        onError: nil,
                                        onCompleted: nil,
                                        onDisposed: nil)
                .disposed(by: cell.cellBag)
        }.disposed(by: disposeBag)
        
    }
    
    private func bindComponents() {
        userSearchViewModel.tableViewHide.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        userSearchViewModel.noUsersLabelHide.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: noUsersLabel.rx.isHidden)
            .disposed(by: disposeBag)

        userSearchViewModel.emptyMessage.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: noUsersLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindSpinner() {
        let spinner = spin()
        userSearchViewModel.indicatorLoader.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: spinner.rx.isHidden)
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
        
        userSearchViewModel.tableFooterViewLoader.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: footerSpinner.rx.isAnimating)
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
