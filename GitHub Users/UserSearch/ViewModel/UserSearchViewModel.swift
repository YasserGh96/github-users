//
//  UserSearchViewModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class UserSearchViewModel {
    
    // MARK: - Properties
    private let service: GitHubUsersServicing
    private let usersRelay = BehaviorRelay<[UserModel]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isFooterLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isRefreshingRelay = BehaviorRelay<Bool>(value: false)
    private let isTableHiddenRelay = BehaviorRelay<Bool>(value: true)
    private let isEmptyStateHiddenRelay = BehaviorRelay<Bool>(value: false)
    private let emptyMessageRelay = BehaviorRelay<String>(value: .Search.emptyTitle)
    
    var users: Driver<[UserModel]> { usersRelay.asDriver() }
    var isLoading: Driver<Bool> { isLoadingRelay.asDriver() }
    var isFooterLoading: Driver<Bool> { isFooterLoadingRelay.asDriver() }
    var isRefreshing: Driver<Bool> { isRefreshingRelay.asDriver() }
    var isTableHidden: Driver<Bool> { isTableHiddenRelay.asDriver() }
    var isEmptyStateHidden: Driver<Bool> { isEmptyStateHiddenRelay.asDriver() }
    var emptyMessage: Driver<String> { emptyMessageRelay.asDriver() }

    var isPagination: Bool = false
    private var page: Int = 1
    private var usersData: [UserModel] = []
    private var userName: String = ""
    private var currentSearchDisposable: Disposable?
    private var isRequestInFlight = false

    init(service: GitHubUsersServicing = api) {
        self.service = service
    }

    deinit {
        currentSearchDisposable?.dispose()
    }
        
    // MARK: - Methods
    func clearResults() {
        currentSearchDisposable?.dispose()
        isRequestInFlight = false
        page = 1
        userName = ""
        usersData = []
        isPagination = false
        isLoadingRelay.accept(false)
        isFooterLoadingRelay.accept(false)
        isRefreshingRelay.accept(false)
        isTableHiddenRelay.accept(true)
        isEmptyStateHiddenRelay.accept(false)
        emptyMessageRelay.accept(.Search.emptyTitle)
        usersRelay.accept([])
    }

    func refreshCurrentSearch() {
        guard !userName.isEmpty else {
            isRefreshingRelay.accept(false)
            return
        }

        getUsers(name: userName, reset: true, isRefresh: true)
    }

    func getUsers(name: String, reset: Bool = false, isRefresh: Bool = false) {
        guard !name.isEmpty else {
            clearResults()
            return
        }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            clearResults()
            return
        }

        let isNextPage = !reset && trimmedName == userName

        if isRequestInFlight && isNextPage {
            return
        }

        currentSearchDisposable?.dispose()
        stopLoading()
        isRequestInFlight = true
        isPagination = isNextPage
        page = isNextPage ? page + 1 : 1
        startLoading(isNextPage: isNextPage, isRefresh: isRefresh)

        currentSearchDisposable = service.searchUsers(name: trimmedName, pageNumber: String(page))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.handleSearchResult(result, query: trimmedName, shouldReset: reset)
            }, onFailure: { [weak self] error in
                self?.handleSearchError(error)
            })
    }

    private func handleSearchResult(_ result: SearchResultsModel, query: String, shouldReset: Bool) {
        isRequestInFlight = false
        stopLoading()
        isEmptyStateHiddenRelay.accept(true)
        isTableHiddenRelay.accept(false)

        if userName == query && !shouldReset {
            usersData.append(contentsOf: result.users)
        } else {
            userName = query
            usersData = result.users
        }

        isPagination = usersData.count < result.total_count && result.users.count == AppConstants.GitHubAPI.perPage
        isTableHiddenRelay.accept(usersData.isEmpty)
        isEmptyStateHiddenRelay.accept(!usersData.isEmpty)
        emptyMessageRelay.accept(.Search.noResults)
        usersRelay.accept(usersData)
    }

    private func handleSearchError(_ error: Error) {
        isRequestInFlight = false
        stopLoading()
        isTableHiddenRelay.accept(true)
        isEmptyStateHiddenRelay.accept(false)
        emptyMessageRelay.accept(error.localizedDescription.isEmpty ? .API.baseError : error.localizedDescription)
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
