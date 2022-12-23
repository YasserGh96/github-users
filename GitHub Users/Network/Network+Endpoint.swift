//
//  Network+Endpoint.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 27/11/2022.
//

import Foundation

// MARK: - API Endpoint
enum Endpoint: String, CaseIterable {
    
    static var baseURL : String {
        return "https://api.github.com/"
    }
    
    case all
    case users = "search/users"
    case followers = "users/%@/followers"
    case following = "users/%@/following"
    
}
