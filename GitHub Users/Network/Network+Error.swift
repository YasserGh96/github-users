//
//  Network+Error.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import UIKit
import Alamofire

final class NetworkError: NSObject, Error {
    
    enum Typee {
        case none
        case general
        case noInternet
        
        case badRequest
        case unauthorized
        case notFound
        case serverDown
        
        case INVALID_ACCESS_TOKEN
        case INVALID_REFRESH_TOKEN
    }
    
    // MARK: - Properties
    private(set) var message: String = ""
    private(set) var type: NetworkError.Typee = .none
    
    var error: AFError?
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    init(request: AFError) {
        self.error = request
    }
    
    init(_ message: String, _ type: NetworkError.Typee = .none) {
        self.message = message
        self.type = type
    }
    
    init(_ type: NetworkError.Typee = .none) {
        self.type = type
        
        if type == .noInternet {
            message = .API.noInternetConnection
        }
    }
}

