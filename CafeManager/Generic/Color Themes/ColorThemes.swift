//
//  ColorThemes.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.11.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

struct ColorThemes {
    
    /// Global tintColor
    static var tintColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.white
        } else {
            return UIColor(red: 5/255, green: 72/255, blue: 149/255, alpha: 1.0)
        }
    }
    
    /// Global default text color
    static var textColorNormal: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    /// Global disabled text color
    static var textColorDisabled: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.lightGray
        } else {
            return UIColor.gray
        }
    }
    
    /// Global background color
    static var backgroundColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    /// NavigationBar style
    static var barStyle: UIBarStyle {
        if UserSettings.isDarkThemeEnabled {
            return UIBarStyle.blackOpaque
        } else {
            return UIBarStyle.default
        }
    }
    
    // UIButtons
    /// UIButton normal text color
    static var buttonTextColorNormal: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.white
        } else {
            return UIColor.blue
        }
    }
    
    /// UIButton destructive text color
    static var buttonTextColorDestructive: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.red
        } else {
            return UIColor.red
        }
    }
    
    /// UIAlertViewController button text color
    static var alertViewButtonTextColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    /// UIActivityViewTextColor
    static var uiActivityViewTextColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.darkGray
        } else {
            return UIColor.black
        }
    }
    
    /// UISwitchOnTintColor
    static var uiSwitchOnTintColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.white
        } else {
            return UIColor(red: 5/255, green: 72/255, blue: 149/255, alpha: 1.0)
        }
    }
    
    /// UISwitchTintColor
    static var uiSwitchTintColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.white
        } else {
            return UIColor.lightGray
        }
    }
    
    /// UISearchBarTintColor
    static var searchBarTintColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.black
        } else {
            return UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        }
    }
    /// UITextFieldBackgroundColor
    static var uiTextFieldBackgroundColor: UIColor {
        if UserSettings.isDarkThemeEnabled {
            return UIColor.lightGray
        } else {
            return UIColor.white
        }
    }
    
    /// UIKeyboardAppearance
    static var uiKeyboardAppearance: UIKeyboardAppearance {
        if UserSettings.isDarkThemeEnabled {
            return UIKeyboardAppearance.dark
        } else {
            return UIKeyboardAppearance.default
        }
    }
    
    /// UITableViewCellSelectedBackgroundColor
    static var uiTableViewCellSelectedBackgroundColor: UIColor {
        return ColorThemes.backgroundColor
    }
}
