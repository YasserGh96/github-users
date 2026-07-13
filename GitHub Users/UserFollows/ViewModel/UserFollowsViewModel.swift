//
//  UserFollowsViewModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 07/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class UserFollowsViewModel {
    
    // MARK: - Properties
    private let usersRelay = BehaviorRelay<[UserModel]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isFooterLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isTableHiddenRelay = BehaviorRelay<Bool>(value: false)
    private let isEmptyStateHiddenRelay = BehaviorRelay<Bool>(value: true)
    
    var users: Driver<[UserModel]> { usersRelay.asDriver() }
    var isLoading: Driver<Bool> { isLoadingRelay.asDriver() }
    var isFooterLoading: Driver<Bool> { isFooterLoadingRelay.asDriver() }
    var isTableHidden: Driver<Bool> { isTableHiddenRelay.asDriver() }
    var isEmptyStateHidden: Driver<Bool> { isEmptyStateHiddenRelay.asDriver() }

    var isPagination: Bool = false
    private var page: Int = 1
    private var usersData: [UserModel] = []
    private var userName: String = ""
    private var currentRequestDisposable: Disposable?
    private var isRequestInFlight = false

    deinit {
        currentRequestDisposable?.dispose()
    }
    
    // MARK: - Methods
    func getFollowers(name: String) {
        getUsers(name: name, request: api.followers(name:pageNumber:))
    }
    
    func getFollowing(name: String) {
        getUsers(name: name, request: api.following(name:pageNumber:))
    }

    private func getUsers(name: String, request: @escaping (String, String) -> Single<[UserModel]>) {
        guard !isRequestInFlight else {
            return
        }

        let isNextPage = userName == name
        isRequestInFlight = true
        page = isNextPage ? page + 1 : 1
        isNextPage ? isFooterLoadingRelay.accept(true) : isLoadingRelay.accept(true)

        currentRequestDisposable = request(name, String(page))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] users in
                self?.handleUsers(users, name: name)
            }, onFailure: { [weak self] error in
                self?.handleError(error)
            })
    }

    private func handleUsers(_ users: [UserModel], name: String) {
        isRequestInFlight = false
        isLoadingRelay.accept(false)
        isFooterLoadingRelay.accept(false)
        isEmptyStateHiddenRelay.accept(true)
        isTableHiddenRelay.accept(false)

        if userName == name {
            usersData.append(contentsOf: users)
        } else {
            userName = name
            usersData = users
        }

        isPagination = users.count == AppConstants.GitHubAPI.perPage
        isTableHiddenRelay.accept(usersData.isEmpty)
        isEmptyStateHiddenRelay.accept(!usersData.isEmpty)
        usersRelay.accept(usersData)
    }

    private func handleError(_ error: Error) {
        isRequestInFlight = false
        isLoadingRelay.accept(false)
        isFooterLoadingRelay.accept(false)
        isTableHiddenRelay.accept(true)
        isEmptyStateHiddenRelay.accept(false)
        log(error.localizedDescription)
    }
}
