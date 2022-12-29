//
//  UserFollowsViewModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 07/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class UserFollowsViewModel {
    
    // MARK: - Properties
    let users = PublishSubject<[UserModel]>()
    var indicatorLoader = BehaviorRelay<Bool>(value: true)
    var tableFooterViewLoader = BehaviorRelay<Bool>(value: false)
    var tableViewHide = BehaviorRelay<Bool>(value: false)
    var noUsersLabelHide = BehaviorRelay<Bool>(value: true)
	var usersObservable: Observable<[UserModel]> {
        return self.users.asObservable()
    }
    
    var isPagination: Bool = false
    private var page: Int = 1
    private var totalCount: Int = 0
    private var usersData: [UserModel] = []
    private var userName: String = ""
    
    // MARK: - Methods
    func getFollowers(name: String) {
        isPagination ? tableFooterViewLoader.accept(true) : indicatorLoader.accept(false)
        page = userName == name ? page + 1 : 1
        api.followers(name: name, pageNumber: String(page)) { [weak self] result in
            guard let strongSelf = self else { return }
            
            strongSelf.indicatorLoader.accept(true)
            strongSelf.tableFooterViewLoader.accept(false)
            
            strongSelf.noUsersLabelHide.accept(true)
            strongSelf.tableViewHide.accept(false)
            
            if result.success {
                if let data = result.data as? [UserModel] {
                    if strongSelf.userName == name {
                        strongSelf.usersData.append(contentsOf: data)
                        strongSelf.totalCount += 10
                    } else {
                        strongSelf.userName = name
                        strongSelf.usersData = data
                        strongSelf.totalCount = 10
                    }
                    
                    strongSelf.isPagination = data.count == 10
                    
                    strongSelf.tableViewHide.accept(strongSelf.usersData.isEmpty)
                    strongSelf.noUsersLabelHide.accept(!strongSelf.usersData.isEmpty)
                    
                    strongSelf.users.onNext(strongSelf.usersData)
                }
            } else {
                print(result.displayError)
            }
        }
    }
    
    func getFollowing(name: String) {
        isPagination ? tableFooterViewLoader.accept(true) : indicatorLoader.accept(false)
        page = userName == name ? page + 1 : 1
        api.following(name: name, pageNumber: String(page)) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.indicatorLoader.accept(true)
            strongSelf.tableFooterViewLoader.accept(false)
            strongSelf.noUsersLabelHide.accept(true)
            strongSelf.tableViewHide.accept(false)
            
            if result.success {
                if let data = result.data as? [UserModel] {
                    if strongSelf.userName == name {
                        strongSelf.usersData.append(contentsOf: data)
                        strongSelf.totalCount += 10
                    } else {
                        strongSelf.userName = name
                        strongSelf.usersData = data
                        strongSelf.totalCount = 10
                    }
                    
                    strongSelf.isPagination = data.count == 10
                    
                    strongSelf.tableViewHide.accept(strongSelf.usersData.isEmpty)
                    strongSelf.noUsersLabelHide.accept(!strongSelf.usersData.isEmpty)
                    
                    strongSelf.users.onNext(strongSelf.usersData)
                }
            } else {
                print(result.displayError)
            }
        }
    }
}
