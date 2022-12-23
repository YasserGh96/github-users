//
//  Network+Reachability.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//


import Foundation
import Reachability

final class ReachabilityManager {
    static let sharedInstance = ReachabilityManager()
    
    private var reachability = try? Reachability()
    private var isConnected = true
    
    private init() {
        reachability?.whenReachable = { _ in
            self.isConnected = true
        }
        
        reachability?.whenUnreachable = { _ in
            self.isConnected = false
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            log("ReachabilityManager", "Unable to start notifier")
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        return isConnected
    }
}


