//
//  Strings.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation

enum AppConstants {
    enum GitHubAPI {
        static let acceptedMediaType = "application/vnd.github+json"
        static let apiVersion = "2022-11-28"
        static let perPage = 20
    }
}

extension String {
    struct API {
        static let error = "Error"
        static let baseError = "Something went wrong. Please try again later!"
        static let somethingWentWrong = "Something went wrong."
        static let noInternetConnection = "No internet connection!"
        static let serverIsNotResponding = "Server is not responding!"
    }
    
    struct Search {
        static let title = "Search Users"
        static let placeholder = "Search GitHub usernames"
        static let emptyTitle = "Search GitHub users"
        static let noResults = "No users found"
    }

    struct Follows {
        static let followers = "Followers"
        static let following = "Following"
        static let empty = "No users available"
    }

    static let gitHubLogo = "github logo"
    static let followers = Follows.followers
    static let following = Follows.following
    static let searchUsers = Search.title
	static let searchBarPlaceHolder = Search.placeholder
    static let noUsersAvailable = Follows.empty
    
}
