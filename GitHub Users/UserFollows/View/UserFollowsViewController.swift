//
//  UserFollowsViewController.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 07/12/2022.
//

import UIKit
import RxSwift

final class UserFollowsViewController: MAViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var name: String = ""
    private var type: String = ""
    private var userFollowsViewModel = UserFollowsViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
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
        if type == .followers {
            userFollowsViewModel.getFollowers(name: name)
        } else {
            userFollowsViewModel.getFollowing(name: name)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        setupUI()
        bindComponents()
        bindTableView()
        bindSpinner()
    }
    
    // MARK: - Methods
    private func setupUI() {
        setBackButton()
        set(title: type)
        
		noDataLabel.set(text: .noUsersAvailable, color: .gray, font: .bold(30))
        noDataLabel.textAlignment = .center
        noDataLabel.isHidden = true
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.delegate = self
        
    }
    
    // MARK: - Binding
    private func bindTableView() {
        tableView.register(cell: UserTableViewCell.self)
        userFollowsViewModel.users.bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.name, cellType: UserTableViewCell.self)) { (row,item,cell) in
            cell.user = item
            cell.set(hide: true)
        }.disposed(by: disposeBag)
    }
    
    private func bindComponents() {
        userFollowsViewModel.tableViewHide.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        userFollowsViewModel.noUsersLabelHide.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: noDataLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindSpinner() {
        let spinner = spin()
        userFollowsViewModel.indicatorLoader.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: spinner.rx.isHidden)
            .disposed(by: disposeBag)
        
        let footerSpinner = UIActivityIndicatorView(style: .gray)
        footerSpinner.color = .main_red
        footerSpinner.startAnimating()
        footerSpinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = footerSpinner
        
        userFollowsViewModel.tableFooterViewLoader.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: footerSpinner.rx.isAnimating)
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
                if type == .followers {
                    userFollowsViewModel.getFollowers(name: name)
                } else {
                    userFollowsViewModel.getFollowing(name: name)
                }
            } 
        }
    }
}
