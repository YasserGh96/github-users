//
//  UserSearchViewModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class UserSearchViewModel {
    
    // MARK: - Properties
    let users = PublishSubject<[UserModel]>()
    var indicatorLoader = BehaviorRelay<Bool>(value: true)
    var tableFooterViewLoader = BehaviorRelay<Bool>(value: false)
    var tableViewHide = BehaviorRelay<Bool>(value: true)
    var noUsersLabelHide = BehaviorRelay<Bool>(value: false)
    var emptyMessage = BehaviorRelay<String>(value: .Search.emptyTitle)
    var usersObservable: Observable<[UserModel]> {
        return self.users.asObservable()
    }
    
    var isPagination: Bool = false
    var seacrhBarValue = BehaviorRelay<String>(value: "")
    private var page: Int = 1
    private var totalCount: Int = 0
    private var usersData: [UserModel] = []
    private var userName: String = ""
        
    // MARK: - Methods
    func clearResults() {
        page = 1
        totalCount = 0
        userName = ""
        usersData = []
        isPagination = false
        indicatorLoader.accept(true)
        tableFooterViewLoader.accept(false)
        tableViewHide.accept(true)
        noUsersLabelHide.accept(false)
        emptyMessage.accept(.Search.emptyTitle)
        users.onNext([])
    }

    func getUsers(name: String) {
        guard !name.isEmpty else {
            clearResults()
            return
        }

        isPagination = name == userName
        isPagination ? tableFooterViewLoader.accept(true) : indicatorLoader.accept(false)
        page = userName == name ? page + 1 : 1
        api.searchUsers(name: name, pageNumber: String(page)) { [weak self] result in
            guard let strongSelf = self else { return }
            
            strongSelf.indicatorLoader.accept(true)
            strongSelf.tableFooterViewLoader.accept(false)
            
            strongSelf.noUsersLabelHide.accept(true)
            strongSelf.tableViewHide.accept(false)
            
            if result.success {
                if let data = result.data as? SearchResultsModel {
                    
                    if strongSelf.userName == name {
                        strongSelf.usersData.append(contentsOf: data.users)
                        strongSelf.totalCount += data.users.count
                    } else {
                        strongSelf.userName = name
                        strongSelf.usersData = data.users
                        strongSelf.totalCount = data.users.count
                    }
                    
                    strongSelf.isPagination = strongSelf.totalCount < data.total_count && data.users.count == AppConstants.GitHubAPI.perPage
                    
                    strongSelf.tableViewHide.accept(strongSelf.usersData.isEmpty)
                    strongSelf.noUsersLabelHide.accept(!strongSelf.usersData.isEmpty)
                    strongSelf.emptyMessage.accept(.Search.noResults)
                    
                    strongSelf.users.onNext(strongSelf.usersData)
                }
            } else {
                strongSelf.tableViewHide.accept(true)
                strongSelf.noUsersLabelHide.accept(false)
                strongSelf.emptyMessage.accept(result.displayError.isEmpty ? .API.baseError : result.displayError)
            }
        }
    }
}
