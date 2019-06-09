//
//  UserSettings.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

class UserSettings {
    //Variables
    private static let defaults = UserDefaults.standard
    
    /// Is time cafe is taken from app settings (user defaults).
    /// Can be set or get. Set is used only in settings.
    static var isTimeCafe: Bool {
        get {
            return UserSettings.defaults.bool(forKey: "isTimeCafe")
        }
        set {
            defaults.set(newValue, forKey: "isTimeCafe")
        }
    }
    
    /// Is time cafe is taken from app settings (user defaults).
    /// Can be set or get. Set is used only in settings.
    static var isDarkThemeEnabled: Bool {
        get {
            return UserSettings.defaults.bool(forKey: "isDarkThemeEnabled")
        }
        set {
            defaults.set(newValue, forKey: "isDarkThemeEnabled")
        }
    }
    
    /// Is autosync enabled is taken from app settings (user defaults).
    /// Can be set or get. Set is used only in settings.
    static var isAutosyncEnabled: Bool {
        get {
            return UserSettings.defaults.bool(forKey: "isAutosyncEnabled")
        }
        set {
            defaults.set(newValue, forKey: "isAutosyncEnabled")
            appDelegate.smStore?.syncAutomatically = newValue
        }
    }
    
    /// Price per minute is taken from app settings (user defaults).
    /// Can be set or get. Set is used only in settings.
    static var pricePerMinute: Float {
        get {
            return UserSettings.defaults.float(forKey: "pricePerMinute")
        }
        set {
            defaults.set(newValue, forKey: "pricePerMinute")
        }
    }
    
    /// Default currency is taken from app settings (user defaults).
    /// Can be set or get. Set is used only in settings.
    static var currency: String {
        get {
            if let currency = defaults.string(forKey: "currency") {
                return currency
            } else {
                defaults.set("USD", forKey: "currency")
                return "USD"
            }
        }
        set {
            defaults.set(newValue, forKey: "currency")
        }
    }
    
    /// Status and time of last sync
    static var syncStatus: String {
        get {
            return UserSettings.defaults.string(forKey: "syncStatus") ?? "N/A"
        }
        set {
            defaults.set(newValue, forKey: "syncStatus")
        }
    }
    
    /// Currency symbol value is taken from app settings (user defaults).
    static var currencySymbol: String {
        get {
            switch currency {
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
}

// Sync user defaults function
extension UserSettings {
    class func syncUserDefaults() {
        let keyStore = NSUbiquitousKeyValueStore()
        if UserSettings.syncStatus == "N/A" {
            UserSettings.currency = keyStore.string(forKey: "currency") ?? UserSettings.currency
            UserSettings.pricePerMinute = Float(keyStore.double(forKey: "pricePerMinute"))
            UserSettings.isTimeCafe = keyStore.bool(forKey: "isTimeCafe")
            UserSettings.isDarkThemeEnabled = keyStore.bool(forKey: "isDarkThemeEnabled")
        } else {
            keyStore.set(UserSettings.currency, forKey: "currency")
            keyStore.set(UserSettings.pricePerMinute, forKey: "pricePerMinute")
            keyStore.set(UserSettings.isTimeCafe, forKey: "isTimeCafe")
            keyStore.set(UserSettings.isDarkThemeEnabled, forKey: "isDarkThemeEnabled")
            keyStore.synchronize()
        }
    }
}
