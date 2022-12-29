//
//  API+Users.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

extension NetworkRequest {
    
    // MARK: - Search Users
    func searchUsers(name: String, pageNumber: String, _ completion: @escaping ResultClosure) {
        let url = Endpoint.baseURL + Endpoint.users.rawValue
        var queryURL = URLComponents(string: url)
                
        let nameItem = URLQueryItem(name: "q", value: name)
        let pageItem = URLQueryItem(name: "page", value: pageNumber)
        let perPageItem = URLQueryItem(name: "per_page", value: "10")
        
        queryURL?.queryItems = [nameItem, pageItem, perPageItem]
        
        guard let endpointURL: URLConvertible = queryURL else {return}
        
        request(endpoint: endpointURL, method: .get) { result in
            
            var users: [UserModel] = []
            var total_count: Int = -1
            
            if let objects = result.object["items"] as? [JSON] {
                users = objects.map { UserModel($0) }
            }
            
            total_count = result.object["total_count"] as? Int ?? -1
            
            let searchResult = SearchResultsModel(total_count: total_count, users: users)
            result.data = searchResult
            
            completion(result)
        }
    }
    
    // MARK: - Follwers/Following
    func followers(name: String, pageNumber: String, _ completion: @escaping ResultClosure) {
        let url = endpoint(.followers, resource: name)
        var queryURL = URLComponents(string: url)

        let pageItem = URLQueryItem(name: "page", value: pageNumber)
        let perPageItem = URLQueryItem(name: "per_page", value: "10")
        
        queryURL?.queryItems = [pageItem, perPageItem]
        
        guard let endpointURL: URLConvertible = queryURL else {return}
        
        request(endpoint: endpointURL, method: .get) { result in
            
            var users: [UserModel] = []
            
             let user = result.objects
                users = user.map { UserModel($0) }
            
            
            result.data = users
            
            completion(result)
        }
    }
    
    func following(name: String, pageNumber: String, _ completion: @escaping ResultClosure) {
        let url = endpoint(.following, resource: name)
        var queryURL = URLComponents(string: url)

        let pageItem = URLQueryItem(name: "page", value: pageNumber)
        let perPageItem = URLQueryItem(name: "per_page", value: "10")
        
        queryURL?.queryItems = [pageItem, perPageItem]
        
        guard let endpointURL: URLConvertible = queryURL else {return}
        
        request(endpoint: endpointURL, method: .get) { result in
            
            var users: [UserModel] = []
            
             let user = result.objects
                users = user.map { UserModel($0) }

            result.data = users
            
            completion(result)
        }
    }
}
