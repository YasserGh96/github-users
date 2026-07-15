//
//  GitHubUsersServicing.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 15.07.26.
//

import RxSwift

protocol GitHubUsersServicing {
	func searchUsers(name: String, pageNumber: String) -> Single<SearchResultsModel>
	func userProfile(name: String) -> Single<UserProfileModel>
	func followers(name: String, pageNumber: String) -> Single<[UserModel]>
	func following(name: String, pageNumber: String) -> Single<[UserModel]>
}

extension NetworkRequest: GitHubUsersServicing {}
