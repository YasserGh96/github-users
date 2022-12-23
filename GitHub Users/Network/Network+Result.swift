//
//  Network+Result.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//


import Foundation
import Alamofire


extension String {
    
    // MARK: - API Errors
    static let INVALID_ACCESS_TOKEN = "INVALID_ACCESS_TOKEN"
    static let INVALID_REFRESH_TOKEN = "INVALID_REFRESH_TOKEN"
}

final class AppError {
    enum AppErrorType {
        case none
        
        case invalidAccessToken
        case invalidRefreshToken
    }
    
    var type: AppErrorType = .none
    var message: String = ""
    
    init(_ dict: JSON) {
        if let error = dict["error"] as? String {
            if error == String.INVALID_ACCESS_TOKEN {
                type = .invalidRefreshToken
            }
            
            if error == String.INVALID_REFRESH_TOKEN {
                type = .invalidRefreshToken
            }
        }
        
        message = dict["message"] as? String ?? ""
    }
    
}

final class NetworkResultModel: MAObject {
    
    enum ErrorType {
        case none
        case app
        case field
        case custom
        case display
    }
    
    // MARK: - Properties
    private var error: NetworkError?
    var appErrors: JSON = [:] {
        didSet {
            appError = AppError(appErrors)
        }
    }
    
    var fieldErrors: JSON = [:]
    var customErrors: JSON = [:]
    var displayError: String = ""
    
    var haveFieldsErrors: Bool {
        return fieldErrors.keys.count > 0
    }
    
    var appError: AppError?
    var errorType: ErrorType = .none
    
    private var dataResponse: AFDataResponse<Any>?
    var success: Bool = false
    var data: Any?
    
    private var value: Any?
    private var _object: JSON?
    private var _objects: [JSON]?
    
    var object: JSON {
        return _object ?? [:]
    }
    
    var objects: [JSON] {
        return _objects ?? []
    }
    
    var statusCode: Int = 0
    var requestURL: String = ""
    
    // MARK: Init
    override init() {
        super.init()
    }
    
    init(dataResponse: AFDataResponse<Any>) {
        super.init()
        
        self.dataResponse = dataResponse
        
        if let request = dataResponse.request {
            if let url = request.url {
                requestURL = url.absoluteString
            }
        }
        
        guard let response = dataResponse.response else {
            switch dataResponse.result {
            case .failure(let error):
                displayError = error.localizedDescription
                statusCode = error.responseCode ?? -1010101
            default:
                displayError = "Error"
                statusCode = -1010101
            }
            
            return
        }
        
        statusCode = response.statusCode
        
        if statusCode.isOk {
            parseData()
        } else if statusCode.isError {
            parseErrors()
        } else if statusCode.isCritical {
            displayError = .API.serverIsNotResponding
            errorType = .display
            success = false
        } else {
            displayError = .API.baseError
            errorType = .display
            success = false
        }
        
        logResponse()
    }
    
    init(error: NetworkError) {
        self.error = error
        displayError = error.message
        
        log()
        log("=========================")
        log("@API -> error")
        log(error.message)
        log("=========================")
        log()
    }
    
    // MARK: - Log
    private func logResponse() {
        var shouldLog = false
        for each in app.logRequest {
            if let response = self.dataResponse {
                if let request = response.request {
                    if let url = request.url {
                        if url.absoluteString.contains(each.rawValue) {
                            shouldLog = true
                            break
                        }
                        
                        if app.logRequest.contains(.all) {
                            shouldLog = true
                        }
                    }
                }
            }
        }
        
        if shouldLog {
            if let response = dataResponse {
                //app.useShortLogsForRequests = false
                if app.useShortLogsForRequests {
                    print("@API", "🌎")
                    print(" -> \(String(describing: response.request!.httpMethod!))")
                    print(" -> \(String(describing: response.response!.statusCode))")
                    print(" -> \(String(describing: response.response!.url!.absoluteString))")
                    print(" --------: \n")
                } else {
                    log()
                    log("=========================")
                    log("@API -> dataResponse")
                    log(response)
                    log("=========================")
                }
            }
        }
    }
}

// MARK: - Data
extension NetworkResultModel {
    func parseData() {
        guard let responseData = dataResponse else { return }
        
        switch responseData.result {
        case .success(let value):
            self.value = value
            
            if let dict = value as? JSON {
                _object = dict
            }
            
            if let dicts = value as? [JSON] {
                _objects = dicts
            }
            
            success = true
        case .failure(let error):
            success = false
            self.error = NetworkError(request: error)
        }
    }
}

// MARK: - Errors
extension NetworkResultModel {
    func parseErrors() {
        guard let responseData = dataResponse else { return }
        
        if let error = responseData.error {
            displayError = error.localizedDescription
            errorType = .display
            success = false
            statusCode = error.responseCode ?? -0
            return
        }
        
        switch responseData.result {
        case .success(let value):
            self.value = value
            
            // error is dictionary
            if let dict = value as? JSON {
                displayError = "\(dict)"
                
                if let display_errors = dict["message"] as? [String] {
                    displayError = display_errors.joined(separator: "\n")
                    errorType = .display
                    
                    if !displayError.isEmpty { return }
                }
                
                if let custom_errors = dict["custom_errors"] as? JSON {
                    customErrors = custom_errors
                    displayError = ""
                    errorType = .custom
                    
                    if !customErrors.isEmpty { return }
                }
                
                if let app_errors = dict["app_errors"] as? JSON {
                    appErrors = app_errors
                    
                    if let appError = appError {
                        if appError.message.isEmpty {
                            displayError = ""
                        } else {
                            displayError = appError.message
                        }
                    } else {
                        displayError = ""
                    }
                    
                    
                    errorType = .app
                    
                    if !appErrors.isEmpty { return }
                }
                
                if let field_errors = dict["field_errors"] as? JSON {
                    fieldErrors = field_errors
                    displayError = ""
                    errorType = .field
                    
                    if !fieldErrors.isEmpty { return }
                }
            }
            
            // error is array
            if let arr = value as? [JSON] {
                displayError = "\(arr)"
            }
            
            success = false
        case .failure(let error):
            success = false
            self.error = NetworkError(request: error)
        }
    }
    
}



