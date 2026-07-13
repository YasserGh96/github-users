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
    private let isRefreshingRelay = BehaviorRelay<Bool>(value: false)
    private let isTableHiddenRelay = BehaviorRelay<Bool>(value: false)
    private let isEmptyStateHiddenRelay = BehaviorRelay<Bool>(value: true)
    
    var users: Driver<[UserModel]> { usersRelay.asDriver() }
    var isLoading: Driver<Bool> { isLoadingRelay.asDriver() }
    var isFooterLoading: Driver<Bool> { isFooterLoadingRelay.asDriver() }
    var isRefreshing: Driver<Bool> { isRefreshingRelay.asDriver() }
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

    func refreshFollowers(name: String) {
        getUsers(name: name, request: api.followers(name:pageNumber:), reset: true, isRefresh: true)
    }

    func refreshFollowing(name: String) {
        getUsers(name: name, request: api.following(name:pageNumber:), reset: true, isRefresh: true)
    }

    private func getUsers(name: String,
                          request: @escaping (String, String) -> Single<[UserModel]>,
                          reset: Bool = false,
                          isRefresh: Bool = false) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            stopLoading()
            return
        }

        let isNextPage = !reset && userName == trimmedName

        if isRequestInFlight && isNextPage {
            return
        }

        currentRequestDisposable?.dispose()
        stopLoading()
        isRequestInFlight = true
        page = isNextPage ? page + 1 : 1
        startLoading(isNextPage: isNextPage, isRefresh: isRefresh)

        currentRequestDisposable = request(trimmedName, String(page))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] users in
                self?.handleUsers(users, name: trimmedName, shouldReset: reset)
            }, onFailure: { [weak self] error in
                self?.handleError(error)
            })
    }

    private func handleUsers(_ users: [UserModel], name: String, shouldReset: Bool) {
        isRequestInFlight = false
        stopLoading()
        isEmptyStateHiddenRelay.accept(true)
        isTableHiddenRelay.accept(false)

        if userName == name && !shouldReset {
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
        stopLoading()
        isTableHiddenRelay.accept(true)
        isEmptyStateHiddenRelay.accept(false)
        log(error.localizedDescription)
    }

    private func startLoading(isNextPage: Bool, isRefresh: Bool) {
        if isNextPage {
            isFooterLoadingRelay.accept(true)
        } else if isRefresh {
            isRefreshingRelay.accept(true)
        } else {
            isLoadingRelay.accept(true)
        }
    }

    private func stopLoading() {
        isLoadingRelay.accept(false)
        isFooterLoadingRelay.accept(false)
        isRefreshingRelay.accept(false)
    }
}
