//
//  UserSettings.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

class UserSettings {
    
    private static let defaults = UserDefaults.standard
    
    static let shared = UserSettings()
    
    // These settings are stored in the Firestore and loaded during application startup
    public var isTimeCafe: Bool = false {
        didSet {
            // Call DBUpdate to update setting in FireStore
        }
    }
    public var currencyCode: String = "USD" {
        didSet {
            // Call DBUpdate to update setting in FireStore
        }
    }
    public var pricePerMinute: Float = 0.0 {
        didSet {
            // Call DBUpdate to update setting in FireStore
        }
    }
    public var cafeName: String = "" {
        didSet {
            // Call DBUpdate to update setting in FireStore
        }
    }
    
    static var currencySymbol: String {
        get {
            switch UserSettings.shared.currencyCode {
            case "USD": return "$"
            case "EUR": return "€"
            case "RUR": return " руб."
            case "UAH": return " грн."
            case "BYN": return " руб."
            case "NIS": return "₪"
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

