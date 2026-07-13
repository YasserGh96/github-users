//
//  UserProfileModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 13/07/2026.
//

import Foundation

final class UserProfileModel: MAObject {

    // MARK: - Properties
    var login: String = ""
    var avatarURL: String = ""
    var name: String = ""
    var bio: String = ""
    var location: String = ""
    var company: String = ""
    var blog: String = ""
    var htmlURL: String = ""
    var publicRepos: Int = 0
    var followers: Int = 0
    var following: Int = 0

    var displayName: String {
        return name.isEmpty ? "@\(login)" : name
    }

    var displayUsername: String {
        return "@\(login)"
    }

    var hasProfileLink: Bool {
        return !htmlURL.isEmpty
    }

    // MARK: - Init
    override init() {
        super.init()
    }

    init(_ json: JSON) {
        super.init()

        login = json["login"] as? String ?? ""
        avatarURL = json["avatar_url"] as? String ?? ""
        name = json["name"] as? String ?? ""
        bio = json["bio"] as? String ?? ""
        location = json["location"] as? String ?? ""
        company = json["company"] as? String ?? ""
        blog = json["blog"] as? String ?? ""
        htmlURL = json["html_url"] as? String ?? ""
        publicRepos = json["public_repos"] as? Int ?? 0
        followers = json["followers"] as? Int ?? 0
        following = json["following"] as? Int ?? 0
    }
}
