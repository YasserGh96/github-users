//
//  UserFollowsViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 07/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class UserFollowsViewController: MAViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var name: String = ""
    private var type: String = ""
    private var userFollowsViewModel = UserFollowsViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    required init(name: String, type: String) {
        super.init(nibName: UserFollowsViewController.name, bundle: nil)
        self.name = name
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        bindComponents()
        bindTableView()
        bindSpinner()
        bindRefreshControl()

        loadUsers()
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .appBackground
        setBackButton()
        set(title: type)
        
		noDataLabel.set(text: .noUsersAvailable, color: .appTextSecondary, font: .semibold(18))
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        noDataLabel.isHidden = true
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .appBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .appPrimary
        refreshControl.attributedTitle = NSAttributedString(
            string: .Follows.refreshTitle,
            attributes: [.foregroundColor: UIColor.appTextSecondary]
        )
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func loadUsers() {
        if type == .followers {
            userFollowsViewModel.getFollowers(name: name)
        } else {
            userFollowsViewModel.getFollowing(name: name)
        }
    }

    private func refreshUsers() {
        if type == .followers {
            userFollowsViewModel.refreshFollowers(name: name)
        } else {
            userFollowsViewModel.refreshFollowing(name: name)
        }
    }
    
    // MARK: - Binding
    private func bindTableView() {
        tableView.register(cell: UserTableViewCell.self)
        userFollowsViewModel.users.drive(tableView.rx.items(cellIdentifier: UserTableViewCell.name, cellType: UserTableViewCell.self)) { _, item, cell in
            cell.user = item
            cell.set(hide: true)
        }.disposed(by: disposeBag)
    }
    
    private func bindComponents() {
        userFollowsViewModel.isTableHidden
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        userFollowsViewModel.isEmptyStateHidden
            .drive(noDataLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindSpinner() {
        let spinner = spin()
        userFollowsViewModel.isLoading
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
        
        userFollowsViewModel.isFooterLoading
            .drive(footerSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.refreshUsers()
            })
            .disposed(by: disposeBag)

        userFollowsViewModel.isRefreshing
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
}

// MARK: - Search Bar Delegate
extension UserFollowsViewController:  UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && indexPath.row != 0 {
            if userFollowsViewModel.isPagination {
                loadUsers()
            } 
        }
    }
}
