//
//  AppDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 03.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import Seam3
import UserNotifications

// Global constants
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let viewContext = AppDelegate.viewContext

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var smStore: SMStore?
    var syncDidFinishNotification: String = SMStoreNotification.SyncDidFinish
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // AppRater for rating app
        let _ = AppRater.sharedInstance
        
        // Pre upload CommonMenu from csv file
        let csvFile: URL = Bundle.main.bundleURL.appendingPathComponent("iCafeManagerCommonMenu.csv")
        let csvExists = FileManager.default.fileExists(atPath: csvFile.path)
        let alreadyLoaded = UserDefaults.standard.bool(forKey: "CommonMenuAlreadyLoaded")
        if csvExists && !alreadyLoaded {
            if let menuItems = try? MenuCSVParsing.parseCommonMenuCSVFile(contentsOfURL: csvFile, encoding: .windowsCP1251) {
                let commonMenuItems = CommonMenuItemsTable.getCommonMenuItemsTable()
                if commonMenuItems.count != menuItems?.count {
                    CommonMenuItemsTable.deleteAllRecords()
                    do {
                        try CommonMenuItemsTable.fillCommonMenuItemsTable(items: menuItems!)
                        UserDefaults.standard.set(true, forKey: "CommonMenuAlreadyLoaded")
                    } catch {
                        print("\(error)")
                    }
                }
            }
        }
        
        // Support for menu items that were created before 1.2.2 version
        // Migrate old menu items without categories to default category
        MenuTable.migrateItemsWithoutCategory()
        
        /// UIAppearance configuration
        ChangeGUITheme.configureThemeForApplication()
        
        // Seam3 configuring
        if #available(iOS 11.0, *) {
            let storeDescriptionType = AppDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.type
            if storeDescriptionType == SMStore.type {
                print("Store is SMStore\n")
                self.smStore = AppDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first as? SMStore
            }
        } else {
            let storeDescriptionType = AppDelegate.managedObjectContext.persistentStoreCoordinator?.persistentStores.first?.type
            if storeDescriptionType == SMStore.type {
                print("Store is SMStore\n")
                self.smStore = AppDelegate.managedObjectContext.persistentStoreCoordinator?.persistentStores.first as? SMStore
            }
        }
        
        // DISABLING AUTO SYNC
        //self.smStore?.syncAutomatically = UserSettings.isAutosyncEnabled
        self.smStore?.syncAutomatically = false
        
        // Closure for ClientTellWhichRecordWins conflict resolution way
        self.smStore?.recordConflictResolutionBlock =  ({(serverRecord, clientRecord, ancestorRecord) -> CKRecord in
            if let serverInt = serverRecord["intAttribute"] as? NSNumber,
                let clientInt = clientRecord["intAttribute"] as? NSNumber {
                if clientInt.intValue > serverInt.intValue {
                    serverRecord["intAttribute"] = clientInt
                }
            }
            return serverRecord
        } )
        
        // Save sync status and remove ambiguous opened table sessions after sync is finished
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: SMStoreNotification.SyncDidFinish), object: nil, queue: nil) { notification in
            if notification.userInfo != nil {
                UserSettings.syncStatus = "BAD"
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.smStore?.triggerSync(complete: true)
            } else {
                UserSettings.syncStatus = Date().convertToString()
            }
            TableSessionTable.removeAmbiguousOpenSessions()
        }
        
        // Register for remote notifications
        //let notificationSettings = UIUserNotificationSettings(types: .badge, categories: nil)
        //application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
        // Run validateCloudKitAnd do NOT run sync
        self.validateCloudKitAnd(runSync: false, {})
        
        // DISABLING AUTO SYNC
        // Run sync if autosync is enabled
//        if UserSettings.isAutosyncEnabled {
//            self.validateCloudKitAnd(runSync: true, {})
//        }

        return true
    }
    
    // MARK: Import file (CSV)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {        
        do {
            do {
                if let parsedMenuItems = try MenuCSVParsing.parseExportedMenuCSVFile(contentsOfURL: url, encoding: String.Encoding.utf8) {
                    try MenuTable.bulkAddMenuItems(items: parsedMenuItems)
                    let alertSuccess = UIAlertController(title: NSLocalizedString("Import of menu performed successfully!", comment: ""), message: nil, preferredStyle: .alert)
                    alertSuccess.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
                    self.window?.rootViewController?.presentAlert(alert: alertSuccess, animated: true)
                }
            } catch iCafeManagerError.ParsingError(let message) {
                if message.contains("Domain=NSCocoaErrorDomain Code=261") {
                    if let parsedMenuItems = try MenuCSVParsing.parseExportedMenuCSVFile(contentsOfURL: url, encoding: String.Encoding.windowsCP1251) {
                        try MenuTable.bulkAddMenuItems(items: parsedMenuItems)
                        let alertSuccess = UIAlertController(title: NSLocalizedString("Import of menu performed successfully!", comment: ""), message: nil, preferredStyle: .alert)
                        alertSuccess.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
                        self.window?.rootViewController?.presentAlert(alert: alertSuccess, animated: true)
                    }
                } else {
                    throw iCafeManagerError.ParsingError(message)
                }
            }
        } catch {
            let alertNoCanDo = UIAlertController(title: NSLocalizedString("Import of menu failed!", comment: ""), message: "Error: \(error)", preferredStyle: .alert)
            alertNoCanDo.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
            self.window?.rootViewController?.presentAlert(alert: alertNoCanDo, animated: true)
        }
        return true
    }
    
    // Remote notification for Seam
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notifications")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification registration failed")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(Date()) Received push")
        self.smStore?.handlePush(userInfo: userInfo)
        completionHandler(.newData)
    }
    
    // Function to start sync
    func validateCloudKitAnd(runSync: Bool, _ completion:@escaping (() -> Void)) {
        self.smStore?.verifyCloudKitConnectionAndUser() { (status, user, error) in
            guard status == .available, error == nil else {
                NSLog("Unable to verify CloudKit Connection \(error!)")
                return
            }
            guard let currentUser = user else {
                NSLog("No current CloudKit user")
                return
            }
            let previousUser = UserDefaults.standard.string(forKey: "CloudKitUser")
            if  previousUser != currentUser && previousUser != nil {
                do {
                    print("New user")
                    try self.smStore?.resetBackingStore()
                } catch {
                    NSLog("Error resetting backing store - \(error.localizedDescription)")
                    return
                }
            }
            UserDefaults.standard.set(currentUser, forKey:"CloudKitUser")
            if runSync {
                self.smStore?.triggerSync(complete: true)
                UserSettings.syncUserDefaults()
                completion()
            }
        }
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
        self.saveContext()
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Core Data stack for iOS 11+
    @available(iOS 11.0, *)
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CafeManager")
        let persistentStoreCoordinator = container.persistentStoreCoordinator
        
        // Preparing URL
        let applicationDocumentsDirectory: URL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
        }()
        
        // Initializing Seam3
        SMStore.registerStoreClass()
        SMStore.syncAutomatically = false
        
        let newURL = applicationDocumentsDirectory.appendingPathComponent("CafeManagerSeam3.sqlite")
        
        // Check if SQLite store has been already migrated by checking if CafeManagerSeam3.sqlite exists.
        let seamStoreExists = FileManager.default.fileExists(atPath: newURL.path)
        
        if seamStoreExists {
            // If exists, then use it because it has been already migrated to Seam3 storage
            print("Already migrated, using \(newURL)")
            
            let storeDescription = NSPersistentStoreDescription(url: newURL)
            storeDescription.type = SMStore.type
            storeDescription.setOption("iCloud.iGlock.CafeManager.com" as NSString, forKey: SMStore.SMStoreContainerOption)
            storeDescription.setOption(NSNumber(value:SMSyncConflictResolutionPolicy.clientTellsWhichWins.rawValue), forKey:SMStore.SMStoreSyncConflictResolutionPolicyOption)
            container.persistentStoreDescriptions=[storeDescription]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            print("Current persistent store descriptions are: \(container.persistentStoreDescriptions)")
            return container
            
        } else {
            // If does not exist, then migrate old storage to Seam3.
            print("Not yet migrated, migrating to \(newURL)")
            
            // Loadig default store
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Failed to load default store \(error), \(error.userInfo)")
                }
            })
            let defaultPersistentStore = container.persistentStoreCoordinator.persistentStores.last
            print("Default store is located here: \(defaultPersistentStore!.url!)")
            
            // Migrating default store to new Seam store
            let options: [String : Any] = [SMStore.SMStoreContainerOption: "iCloud.iGlock.CafeManager.com"]
            do {
                try persistentStoreCoordinator.migratePersistentStore(defaultPersistentStore!, to: newURL, options: nil, withType:SMStore.type)
            }
            catch {
                fatalError("Failed to migrate to Seam store: \(error)")
            }
            return container
        }
    }()
    
    // MARK: - Core Data stack for iOS 9 (8+)
    static var managedObjectContext: NSManagedObjectContext = {
        var managedObjectModel: NSManagedObjectModel = {
            let momURL = Bundle.main.url(forResource: "CafeManager v 4 (indexes)", withExtension: "mom", subdirectory: "CafeManager.momd")
            guard let url = momURL else { fatalError("model version \(self) not found") }
            guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError("cannot open model at \(url)") }
            return model
        }()
        
        // Preparing URL
        var applicationDocumentsDirectory: URL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
        }()
        
        // Initializing Seam3
        SMStore.registerStoreClass()
        SMStore.syncAutomatically = false
        
        let oldURL = applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        let wrongMigrationURL = applicationDocumentsDirectory.appendingPathComponent("CafeManagerSeam3.sqlite")
        let newURLv1 = applicationDocumentsDirectory.appendingPathComponent("CafeManagerSeam3v1.sqlite")
        
        // Check if SQLite store has been already migrated by checking if CafeManagerSeam3.sqlite exists.
        let seamStoreExists = FileManager.default.fileExists(atPath: newURLv1.path)
        
        if seamStoreExists {
            // If exists, then use it because it has been already migrated to Seam3 storage
            print("Already migrated, using \(newURLv1)")
            
            var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                do
                {
                    let options: [String : Any] = [NSMigratePersistentStoresAutomaticallyOption: true,
                                                   NSInferMappingModelAutomaticallyOption: true,
                                                   SMStore.SMStoreContainerOption: "iCloud.iGlock.CafeManager.com",
                                                   SMStore.SMStoreSyncConflictResolutionPolicyOption: NSNumber(value:SMSyncConflictResolutionPolicy.clientTellsWhichWins.rawValue)]
                    try coordinator.addPersistentStore(ofType: SMStore.type, configurationName: nil, at: newURLv1, options: options)
                } catch {
                    NSLog("Error initializing smStore for iOS 8+ - \(error.localizedDescription)")
                }
                return coordinator
            }()
            
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            return managedObjectContext
        } else {
            // If wrong migration was performed, fix it by migration to Seam3 properly
            let brokernSeamStoreExists = FileManager.default.fileExists(atPath: wrongMigrationURL.path)
            if brokernSeamStoreExists {
                print("Migration was performed not properly migrating to \(newURLv1)")
                
                var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
                    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                    
                    // Initializing old store
                    do {
                        let options: [String : Any] = [NSMigratePersistentStoresAutomaticallyOption: true,
                                                       NSInferMappingModelAutomaticallyOption: true]
                        let oldStore = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: wrongMigrationURL, options: options)
                        
                        // Migrate old store to Seam3
                        do
                        {
                            let options: [String : Any] = [NSMigratePersistentStoresAutomaticallyOption: true,
                                                           NSInferMappingModelAutomaticallyOption: true,
                                                           SMStore.SMStoreContainerOption: "iCloud.iGlock.CafeManager.com",
                                                           SMStore.SMStoreSyncConflictResolutionPolicyOption: NSNumber(value:SMSyncConflictResolutionPolicy.clientTellsWhichWins.rawValue)]
                            try coordinator.migratePersistentStore(oldStore, to: newURLv1, options: options, withType: SMStore.type)
                        } catch {
                            NSLog("Error initializing smStore for iOS 9 - \(error.localizedDescription)")
                        }
                    } catch {
                        NSLog("Error initializing default NSSQLiteStore for iOS 9 - \(error.localizedDescription)")
                    }
                    
                    return coordinator
                }()
                
                var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
                return managedObjectContext
            } else {
                // If does not exist, then migrate old storage to Seam3.
                print("Not yet migrated, migrating to \(newURLv1)")
                
                var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
                    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                    
                    // Initializing old store
                    do {
                        let options: [String : Any] = [NSMigratePersistentStoresAutomaticallyOption: true,
                                                       NSInferMappingModelAutomaticallyOption: true]
                        let oldStore = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: oldURL, options: options)
                        
                        // Migrate old store to Seam3
                        do
                        {
                            let options: [String : Any] = [NSMigratePersistentStoresAutomaticallyOption: true,
                                                           NSInferMappingModelAutomaticallyOption: true,
                                                           SMStore.SMStoreContainerOption: "iCloud.iGlock.CafeManager.com",
                                                           SMStore.SMStoreSyncConflictResolutionPolicyOption: NSNumber(value:SMSyncConflictResolutionPolicy.clientTellsWhichWins.rawValue)]
                            try coordinator.migratePersistentStore(oldStore, to: newURLv1, options: options, withType: SMStore.type)
                        } catch {
                            NSLog("Error initializing smStore for iOS 9 - \(error.localizedDescription)")
                        }
                    } catch {
                        NSLog("Error initializing default NSSQLiteStore for iOS 9 - \(error.localizedDescription)")
                    }
                    
                    return coordinator
                }()
                
                var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
                return managedObjectContext
            }
        }
    }()
    
    // MARK: View Context for all iOS versions
    static var viewContext: NSManagedObjectContext {
        if #available(iOS 11.0, *) {
            return persistentContainer.viewContext
        } else {
            return AppDelegate.managedObjectContext
        }
    }
    
    // MARK: Core Data Saving context for all iOS versions
    func saveContext () {
        let context = AppDelegate.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

