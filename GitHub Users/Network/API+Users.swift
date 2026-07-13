//
//  API+Users.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import Alamofire
import RxSwift

extension NetworkRequest {
    
    // MARK: - Search Users
    func searchUsers(name: String, pageNumber: String, _ completion: @escaping ResultClosure) {
        let url = Endpoint.baseURL + Endpoint.users.rawValue
        var queryURL = URLComponents(string: url)
                
        let nameItem = URLQueryItem(name: "q", value: name)
        let pageItem = URLQueryItem(name: "page", value: pageNumber)
        let perPageItem = URLQueryItem(name: "per_page", value: "\(AppConstants.GitHubAPI.perPage)")
        
        queryURL?.queryItems = [nameItem, pageItem, perPageItem]
        
        guard let endpointURL: URLConvertible = queryURL else {return}
        
        request(endpoint: endpointURL, method: .get) { result in
            
            var users: [UserModel] = []
            var totalCount: Int = -1
            
            if let objects = result.object["items"] as? [JSON] {
                users = objects.map { UserModel($0) }
            }
            
            totalCount = result.object["total_count"] as? Int ?? -1
            
            let searchResult = SearchResultsModel(total_count: totalCount, users: users)
            result.data = searchResult
            
            completion(result)
        }
    }
    
    func searchUsers(name: String, pageNumber: String) -> Single<SearchResultsModel> {
        return Single.create { [weak self] single in
            self?.searchUsers(name: name, pageNumber: pageNumber) { result in
                if result.success, let searchResult = result.data as? SearchResultsModel {
                    single(.success(searchResult))
                } else {
                    single(.failure(result.asError()))
                }
            }

            return Disposables.create()
        }
    }

    // MARK: - Followers/Following
    func followers(name: String, pageNumber: String, _ completion: @escaping ResultClosure) {
        let url = endpoint(.followers, resource: name)
        var queryURL = URLComponents(string: url)

        let pageItem = URLQueryItem(name: "page", value: pageNumber)
        let perPageItem = URLQueryItem(name: "per_page", value: "\(AppConstants.GitHubAPI.perPage)")
        
        queryURL?.queryItems = [pageItem, perPageItem]
        
        guard let endpointURL: URLConvertible = queryURL else {return}
        
        request(endpoint: endpointURL, method: .get) { result in
            
            result.data = result.objects.map { UserModel($0) }
            
            completion(result)
        }
    }
    
    func followers(name: String, pageNumber: String) -> Single<[UserModel]> {
        return Single.create { [weak self] single in
            self?.followers(name: name, pageNumber: pageNumber) { result in
                if result.success, let users = result.data as? [UserModel] {
                    single(.success(users))
                } else {
                    single(.failure(result.asError()))
                }
            }

            return Disposables.create()
        }
    }

    func following(name: String, pageNumber: String, _ completion: @escaping ResultClosure) {
        let url = endpoint(.following, resource: name)
        var queryURL = URLComponents(string: url)

        let pageItem = URLQueryItem(name: "page", value: pageNumber)
        let perPageItem = URLQueryItem(name: "per_page", value: "\(AppConstants.GitHubAPI.perPage)")
        
        queryURL?.queryItems = [pageItem, perPageItem]
        
        guard let endpointURL: URLConvertible = queryURL else {return}
        
        request(endpoint: endpointURL, method: .get) { result in
            
            result.data = result.objects.map { UserModel($0) }
            
            completion(result)
        }
    }

    func following(name: String, pageNumber: String) -> Single<[UserModel]> {
        return Single.create { [weak self] single in
            self?.following(name: name, pageNumber: pageNumber) { result in
                if result.success, let users = result.data as? [UserModel] {
                    single(.success(users))
                } else {
                    single(.failure(result.asError()))
                }
            }

            return Disposables.create()
        }
    }
}

private extension NetworkResultModel {
    func asError() -> Error {
        let message = displayError.isEmpty ? String.API.baseError : displayError
        return NSError(domain: "GitHubUsers.Network",
                       code: statusCode,
                       userInfo: [NSLocalizedDescriptionKey: message])
    }
}
