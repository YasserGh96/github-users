//
//  AppManager.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation
import UIKit

let app = AppManager.si

final class AppManager {
    
    // MARK: - Init
    static let si = AppManager()
    
    private init() {
        //
    }
    
    // MARK: - Logs
    var logsAreEnabled: Bool {
        return true
    }
    
    // MARK: - Request
    var useShortLogsForRequests = false //true
    var logRequest: [Endpoint] = [
        .all,
        .users,
        .followers
    ]
    
    // MARK: - Data
    var delegate: AppDelegate!
}


