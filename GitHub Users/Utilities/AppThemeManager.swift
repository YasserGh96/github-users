//
//  AppThemeManager.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 13/07/2026.
//

import UIKit

enum AppTheme: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2

    var title: String {
        switch self {
        case .system:
            return .Theme.system
        case .light:
            return .Theme.light
        case .dark:
            return .Theme.dark
        }
    }

    var iconName: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension Notification.Name {
    static let appThemeDidChange = Notification.Name("appThemeDidChange")
}

final class AppThemeManager {

    static let shared = AppThemeManager()

    private let storageKey = "selectedAppTheme"

    private init() {}

    var currentTheme: AppTheme {
        let rawValue = UserDefaults.standard.integer(forKey: storageKey)
        return AppTheme(rawValue: rawValue) ?? .system
    }

    func setTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: storageKey)
        applyThemeToConnectedScenes()
        NotificationCenter.default.post(name: .appThemeDidChange, object: theme)
    }

    func applySavedTheme(to window: UIWindow) {
        window.overrideUserInterfaceStyle = currentTheme.interfaceStyle
    }

    private func applyThemeToConnectedScenes() {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = currentTheme.interfaceStyle }
    }
}
