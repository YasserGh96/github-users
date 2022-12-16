//
//  Alert.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//


import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
