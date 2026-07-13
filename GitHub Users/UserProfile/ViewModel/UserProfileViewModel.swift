//
//  UserProfileViewModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 13/07/2026.
//

import Foundation
import RxSwift
import RxCocoa

final class UserProfileViewModel {

    // MARK: - Properties
    private let profileRelay = BehaviorRelay<UserProfileModel?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = BehaviorRelay<String>(value: "")

    var profile: Driver<UserProfileModel> {
        return profileRelay.asObservable()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }

    var isLoading: Driver<Bool> { isLoadingRelay.asDriver() }
    var errorMessage: Driver<String> { errorMessageRelay.asDriver() }

    private var currentRequestDisposable: Disposable?

    deinit {
        currentRequestDisposable?.dispose()
    }

    // MARK: - Methods
    func loadProfile(username: String) {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUsername.isEmpty else {
            errorMessageRelay.accept(.API.baseError)
            return
        }

        currentRequestDisposable?.dispose()
        isLoadingRelay.accept(true)
        errorMessageRelay.accept("")

        currentRequestDisposable = api.userProfile(name: trimmedUsername)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] profile in
                self?.isLoadingRelay.accept(false)
                self?.profileRelay.accept(profile)
            }, onFailure: { [weak self] error in
                self?.isLoadingRelay.accept(false)
                self?.errorMessageRelay.accept(error.localizedDescription.isEmpty ? .API.baseError : error.localizedDescription)
            })
    }
}
