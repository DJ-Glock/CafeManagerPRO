//
//  ViewModel.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.12.2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation

class DBGeneral {
    // MARK: Read data from the database
    
    /// Read user settings and menu from database. Set data to variables of UserSettings and MenuCategory/Menu classes
    class func readUserSettingsFromDB() {
        if (userId != nil) {
            userData = appDelegate.db.collection("UserData").document(userId)
            DBQuery.getUserSettingsAndMenuAsync { (error) in
                if let error = error {
                    CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while retrieving settings and menu from the database \(String(describing: error))")
                }
            }
        }
    }
    
    // MARK: Update data in the database
    class func updateMenuAndSettings() {
        DBUpdate.updateUserSettingsAndMenuAsync { (error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving menu and settings in the Firestore: \(String(describing: error))")
            }
        }
    }
    
    class func updateActiveSession(tableSession: TableSession) {
        DBUpdate.updateTableSessionAsync(session: tableSession, type: .Active) { (error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while updating active session data in the Firestore: \(String(describing: error))")
            }
            
        }
    }
    
    class func moveActiveSessionToArchive(tableSession: TableSession) {
        DBUpdate.moveTableSessionToCollectionAsync(tableSession: tableSession, sourceCollection: .Active, targetCollection: .Archive, targetTable: nil) { (tableSession, error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while moving session data to archive in the Firestore: \(String(describing: error))")
            }
        }
    }
    
    class func moveActiveSession(tableSession: TableSession, targetTable: Table) {
        DBUpdate.moveTableSessionToCollectionAsync(tableSession: tableSession, sourceCollection: .Active, targetCollection: .Active, targetTable: targetTable) { (tableSession, error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while moving session data to archive in the Firestore: \(String(describing: error))")
            }
        }
    }
}
