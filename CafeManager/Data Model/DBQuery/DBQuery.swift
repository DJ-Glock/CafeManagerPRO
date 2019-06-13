//
//  DBQuery.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation

class DBQuery {
    class func getTables(completion: @escaping ([TablesTable], Error?) -> Void) {
        
        // Test query to Firestore
        let userId = appDelegate.auth?.currentUser?.uid ?? ""
        
        var tables = [TablesTable]()
        
        let tablesCollection = appDelegate.db.collection("usersData").document(userId).collection("tables")
        tablesCollection.order(by: "name", descending: false)
        tablesCollection.getDocuments { (snapshot, error) in
            if let error = error {
                completion(tables, error)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let tableName = data["name"] as! String
                    let tableCapacity = data["capacity"] as! Int16
                    let tableDescription = data["description"] as? String
                    
                    let table = TablesTable(tableName: tableName, tableCapacity: tableCapacity, tableDescription: tableDescription, tableSession: nil)
                    tables.append(table)
                }
                completion(tables, nil)
            }
        }
    }
    
//    class func getGuests(forTableSession tableSession: TableSessionTable) -> [GuestsTable] {
//
//    }
//
//    class func getOrdersFromDB(forTableSession tableSession: TableSessionTable) -> [OrdersTable] {
//
//    }
//
//    class func getOrdersFromDB(forGuest guest: GuestsTable) -> [OrdersTable] {
//
//    }
//
}
