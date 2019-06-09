//
//  AppRater.swift
//  CafeManager
//
//  Created by Denis Kurashko on 31.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit
import StoreKit

public class AppRater: NSObject {
    var application: UIApplication!
    var defaults = UserDefaults()
    let requiredLaunchesBeforeRate = 5
    var appId: String!
    var storeProductViewController = SKStoreProductViewController()
    
    public static var sharedInstance = AppRater()
    
    override public init() {
        super.init()
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidFinishLaunching(notification:)), name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
    }

    @objc func appDidFinishLaunching(notification: NSNotification) {
        if let app = notification.object as? UIApplication {
            self.application = app
            displayRatingsAlertIfRequired()
        }
    }
    
    private func displayRatingsAlertIfRequired() {
        let appLaunchesCount = getAppLaunchesCount()
        if appLaunchesCount >= self.requiredLaunchesBeforeRate && !hasAppRatingShown() {
            self.rateTheApp()
        }
        incrementAppLaunches()
    }
    
    // Functions for UserDefaults
    private func getAppLaunchesCount() -> Int {
        let launches = defaults.integer(forKey: "iCafeManagerLaunchesCount")
        return launches
    }
    
    private func incrementAppLaunches() {
        var launches = self.getAppLaunchesCount()
        launches += 1
        defaults.set(launches, forKey: "iCafeManagerLaunchesCount")
    }
    
    private func resetAppLaunches() {
        defaults.set(0, forKey: "iCafeManagerLaunchesCount")
    }
    
    private func setAppRatingShown() {
        defaults.set(true, forKey: "iCafeManagerRatingShown")
    }
    
    private func hasAppRatingShown() -> Bool {
        let shown = defaults.bool(forKey: "iCafeManagerRatingShown")
        return shown
    }
    
    // Function to show alert
    private func rateTheApp() {
        let rateAlert = UIAlertController(title: NSLocalizedString("Rate us", comment: ""), message: NSLocalizedString("Do you like our app? Have an issue? Please rate us or leave a feedback!", comment: ""), preferredStyle: .alert)
        rateAlert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
        rateAlert.addAction(UIAlertAction(title: NSLocalizedString("Rate us!", comment: ""), style: .default, handler: { (UIAlertAction) in
            let url = NSURL(string: "itms-apps://itunes.apple.com/app/id1247026710")
            UIApplication.shared.openURL(url! as URL)
            self.setAppRatingShown()
        }))
        appDelegate.window?.rootViewController?.presentAlert(alert: rateAlert, animated: true)
    }
}
