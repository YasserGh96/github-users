//
//  Int.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation

extension Int {
    
    // MARK: - API Status Code
    var isOk: Bool {
        let okCodes = [
            200, 201, 204
        ]
        
        return okCodes.contains(self)
    }
    
    var isError: Bool {
        let errorCodes = [
            400, 401, 403, 404
        ]
        
        return errorCodes.contains(self)
    }
    
    var isCritical: Bool {
        let criticalCodes = [
            500
        ]
        
        return criticalCodes.contains(self)
    }
}

