//
//  NetworkRequest.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import Alamofire

let api = NetworkRequest.si

class NetworkRequest: NSObject {
    
    // MARK: - Properties
    static let si = NetworkRequest()
    
    // MARK: - Internet Connection
    var isConnected: Bool {
        return ReachabilityManager.sharedInstance.isConnectedToNetwork()
    }
    
    // MARK: - Init
    override private init() {
        super.init()
    }
    
    // MARK: - HTTP Headers
    var headers : HTTPHeaders {
        var _headers: HTTPHeaders = [:]
        _headers["Accept"] = "application/vnd.github+json"
        
        return _headers
    }
    
    // MARK: - Endpoint
    func endpoint(_ endpoint: Endpoint, id: String = "") -> URLConvertible {
        let fullUrl: String = Endpoint.baseURL + endpoint.rawValue + id
        
        do {
            let regex = try NSRegularExpression(pattern: "( )*$", options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, fullUrl.count)
            return regex.stringByReplacingMatches(in: fullUrl, options: [], range: range, withTemplate: "") as URLConvertible
        } catch {
            return fullUrl as URLConvertible
        }
    }
    
    func endpoint(_ endpoint: Endpoint, resource: String) -> String
    
       {
           let fullURLString = Endpoint.baseURL + String(format: endpoint.rawValue, resource)
               
           do {
               
               let regex = try NSRegularExpression(pattern: "( )*$", options: NSRegularExpression.Options.caseInsensitive)
               let range = NSMakeRange(0, fullURLString.count)
                                  
                   //guard let endpointURL: URLConvertible = queryURL else {return}
               print(fullURLString)
               return regex.stringByReplacingMatches(in: fullURLString, options: [], range: range, withTemplate: "") as String
           } catch {
               return fullURLString as String
           }
       }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func request(endpoint: URLConvertible, method: HTTPMethod, _ completion: @escaping ResultClosure) {
        
        if !isConnected {
            completion(NetworkResultModel(error: NetworkError(.noInternet)))
            return
        }
        
        var customValidation: [Int] = []
        customValidation.append(contentsOf: 1...400)
        customValidation.append(contentsOf: 402...999)
        
        AF.request(endpoint,
                   method: method,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers).validate(statusCode: customValidation).responseJSON { response in
            completion(NetworkResultModel(dataResponse: response))
        }
    }
}
