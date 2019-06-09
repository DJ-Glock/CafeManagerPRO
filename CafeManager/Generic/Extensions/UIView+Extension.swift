//
//  UIView+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Workaround for issue with disclosure indicator for iPads with iOS 9. If not used, disclosure background will be white.
    /// Input parameters: UITableview, UITableViewCell.
    /// Output: UIView. It should be set as UIBackgroundView of cell.
    /// Example:
    /// if UIDevice.current.userInterfaceIdiom == .pad && (UIDevice.current.systemVersion.range(of: "9.") != nil) {
    ///    cell.backgroundView = tableView.fixedAccessoryViewBackgroundForIPadsWithIOS9()
    /// }
    func fixedAccessoryViewBackgroundForIPadsWithIOS9() -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = self.backgroundColor
        return backgroundView
    }
}

extension UIView {
    /// Width for my custom alert views
    func myCustomAlertViewWidth() -> Int {
        var shift: Int {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 200
            } else {
                return 40
            }
        }
        return Int(self.bounds.width) - shift
    }
}
