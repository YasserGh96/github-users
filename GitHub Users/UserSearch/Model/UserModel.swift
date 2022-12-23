//
//  UserModel.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation

final class UserModel: MAObject {
    
    // MARK: - Properties
    var login: String = ""
    var id: Int = 0
    var avatar_url: String = ""
    var followers_url: String = ""
    var following_url: String = ""
    
    // MARK: - Init
    override init() {
        super.init()
    }

    init(_ json:JSON) {
        super.init()
        
        login = json["login"] as? String ?? ""
        id = json["id"] as? Int ?? 0
        avatar_url = json["avatar_url"] as? String ?? ""
        followers_url = json["followers_url"] as? String ?? ""
        following_url = json["following_url"] as? String ?? ""
    }
}
