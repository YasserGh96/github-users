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
    func getUsers(name: String) {
        isPagination ? tableFooterViewLoader.accept(true) : indicatorLoader.accept(false)
        page = userName == name ? page + 1 : 1
        api.searchUsers(name: name, pageNumber: String(page)) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.indicatorLoader.accept(true)
            strongSelf.tableFooterViewLoader.accept(false)
            if result.success {
                if let data = result.data as? SearchResultsModel {
                    
                    if strongSelf.userName == name {
                        strongSelf.usersData.append(contentsOf: data.users)
                        strongSelf.totalCount += 10
                    } else {
                        strongSelf.userName = name
                        strongSelf.usersData = data.users
                        strongSelf.totalCount = 10
                    }
                    
                    if (data.total_count - strongSelf.totalCount) <= 10 {
                        strongSelf.isPagination = false
                    } else {
                        strongSelf.isPagination = true
                    }
                    
                    strongSelf.users.onNext(strongSelf.usersData)
                }
            } else {
                print(result.displayError)
            }
        }
    }
}
