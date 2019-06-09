//
//  ChangeGUITheme.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.11.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation
import UIKit

class ChangeGUITheme {
    
    class func setColorThemeFor(button: UIButton) -> UIButton? {
        var theme: String {
            if UserSettings.isDarkThemeEnabled {
                return "DarkTheme"
            } else {
                return "LightTheme"
            }
        }
        
        if let buttonName = button.currentTitle {
            let imageName = buttonName + theme
            if let image = UIImage(named: imageName) {
                button.setImage(image, for: .normal)
                button.setTitleColor(ColorThemes.tintColor, for: .normal)
            }
        }
        return button
    }
    
    class func configureThemeForApplication() {
        let textColor = ColorThemes.textColorNormal
        let tintColor = ColorThemes.tintColor
        let backgroundColor = ColorThemes.backgroundColor
        
        // Change colors of items. DO NOT change the order of commands. Order is DRAMATICALLY important!
        // UINavigationBars
        UINavigationBar.appearance().barStyle = ColorThemes.barStyle
        UINavigationBar.appearance().isTranslucent = true
        let navigationBars: [UIAppearanceContainer.Type] = [UINavigationBar.self]
        UIView.appearance(whenContainedInInstancesOf: navigationBars).backgroundColor = UINavigationBar.appearance().backgroundColor
        
        // UIViews
        UIView.appearance().tintColor = tintColor
        
        // UITableViews
        UITableView.appearance().backgroundColor = backgroundColor
        UITableViewCell.appearance().backgroundColor = backgroundColor
        UITableViewCell.appearance().tintColor = tintColor
        let colorView = UIView()
        colorView.backgroundColor = ColorThemes.uiTableViewCellSelectedBackgroundColor
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        
        // UILabels
        UILabel.appearance().textColor = textColor
        
        // UISwitchers
        UISwitch.appearance().onTintColor = ColorThemes.uiSwitchOnTintColor
        UISwitch.appearance().tintColor = ColorThemes.uiSwitchTintColor
        
        // UITextFields
        UITextField.appearance().textColor = ColorThemes.textColorNormal
        UITextField.appearance().backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        UITextField.appearance().tintColor = ColorThemes.tintColor
        UITextField.appearance().keyboardAppearance = ColorThemes.uiKeyboardAppearance
        
        // UITextField placeholder
        UILabel.appearance(whenContainedInInstancesOf: [UITextField.self as UIAppearanceContainer.Type]).textColor = UIColor.darkGray
        
        // UIDatePickers
        UIDatePicker.appearance().backgroundColor = backgroundColor
        UIDatePicker.appearance().tintColor = textColor
        
        // UIAlertController, UIActivityViewController
        let alertViews: [UIAppearanceContainer.Type] = [UIAlertController.self, UIActivityViewController.self]
        UIView.appearance(whenContainedInInstancesOf: alertViews).tintColor = ColorThemes.uiActivityViewTextColor
        
        // UISearchBar
        UISearchBar.appearance().barTintColor = ColorThemes.searchBarTintColor
        UISearchBar.appearance().isTranslucent = true

        if #available(iOS 11.0, *) {
            let searchBarView: [UIAppearanceContainer.Type] = [UISearchBar.self]
            UIView.appearance(whenContainedInInstancesOf: searchBarView).backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        }
        
    }
}

