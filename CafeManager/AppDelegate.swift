//
//  AppDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 03.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseUI

// Global constants
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let userId: String! = appDelegate.auth?.currentUser?.uid
var userData: DocumentReference! = nil

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var auth: Auth?
    var db: Firestore!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        self.db = Firestore.firestore()
        self.auth = Auth.auth()
        ViewModel.readUserSettingsFromDB()
        
        // AppRater for rating app - needs to be fixed.
        //let _ = AppRater.sharedInstance
        
        /// UIAppearance configuration
        ChangeGUITheme.configureThemeForApplication()
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // Handle Google Authentication URL
    func application(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            ViewModel.readUserSettingsFromDB()
            return true
        }
        return false
    }
    
    // Remote notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notifications")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification registration failed")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification")
    }
    
    // Lifecycle functions
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}

