//
//  UserSettings.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

enum SettingType {
    case cafeName
    case isTimeCafe
    case currencyCode
    case pricePerMinute
}

class UserSettings {
    
    private static let defaults = UserDefaults.standard
    
    static let shared = UserSettings()
    
    // These settings are stored in the Firestore and loaded during application startup
    public var isTimeCafe: Bool = false
    public var currencyCode: String = "USD"
    public var pricePerMinute: Float = 0.0
    public var cafeName: String = ""
    
    static var currencySymbol: String {
        get {
            switch UserSettings.shared.currencyCode {
            case "USD": return "$"
            case "EUR": return "€"
            case "RUB": return " руб."
            case "UAH": return " грн."
            case "BYN": return " руб."
            case "NIS": return "₪"
            case "INS": return "Rs."
            default: return "$"
            }
        }
    }
    
    // These settings are stored in device memory (user defaults)
    static var isDarkThemeEnabled: Bool {
        get {
            return UserSettings.defaults.bool(forKey: "isDarkThemeEnabled")
        }
        set {
            defaults.set(newValue, forKey: "isDarkThemeEnabled")
        }
    }
}

