//
//  CommonAlert.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit

class CommonAlert {
    class var shared: CommonAlert {
        struct Static {
            static let instance: CommonAlert = CommonAlert()
        }
        return Static.instance
    }
    
    public func show(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
        
        if let topController = UIApplication.topViewController() {
            topController.presentAlert(alert: alert, animated: true)
        }
    }
}
