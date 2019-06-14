//
//  DBQuery.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation
import Firebase

class DBQuery {
    /// Funtion returns all tables with active sessions (if any)
    class func getTablesWithActiveSessions(completion: @escaping ([TablesTable], Error?) -> Void) {
        
        var tables = [TablesTable]()
        let tablesCollection = userData
            .collection("Tables")
            .order(by: "name", descending: false)
        tablesCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion (tables, error)
            }
        
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let firebaseID = document.documentID
                    let tableName = data["name"] as! String
                    let tableCapacity = data["capacity"] as! Int16
                    let tableDescription = data["description"] as? String
                    
                    let table = TablesTable(firebaseID: firebaseID, tableName: tableName, tableCapacity: tableCapacity, tableDescription: tableDescription)
                    tables.append(table)
                }
            }
        
            // Get active sessions for each table.
            // Run completion only when the last one is processed
            let tablesCount = tables.count
            for var i in 0...tablesCount-1 {
                let table = tables[i]
                
                DBQuery.getActiveTableSession(forTable: table, completion: { (tableSession, error) in
                    if let error = error {
                        CommonAlert.shared.show(title: "Error occurred", text: "An error occurred while retrieving data from DB: \(error)")
                        return
                    }
                    table.tableSession = tableSession
                    
                    i = i + 1
                    if (tablesCount != 1) && (i == tablesCount - 1) || (tablesCount == 1) && (i == tablesCount) {
                        completion(tables, nil)
                    }
                })
            }
            completion([], nil)
        }
    }
    
    class func getActiveTableSession (forTable table: TablesTable, completion: @escaping (TableSessionTable?, Error?) -> Void) {
        
        let tableSessionCollection = userData
            .collection("Tables")
            .document(table.firebaseID!)
            .collection("ActiveSessions")

        tableSessionCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                guard snapshot.count != 0 else {return}
                let document = snapshot.documents[0]
                let data = document.data()
                
                let openTimeStamp = data["openTime"] as! Timestamp
                let openTime = openTimeStamp.dateValue()
                let closeTimeStamp = data["closeTime"] as? Timestamp
                let closeTime = closeTimeStamp?.dateValue()
                let totalAmount = data["totalAmount"] as? Float ?? 0.0
                let tips = data["tips"] as? Float ?? 0.0
                let discount = data["discount"] as? Int16 ?? 0
                
                let tableSession = TableSessionTable(table: table, openTime: openTime, closeTime: closeTime, guests: [], orderedItems: [], totalAmount: totalAmount, tips: tips, discount: discount)
                
                var guests = [GuestsTable]()
                let guestsData = data["Guests"] as! [[String:Any]]
                
                // Get Guests and their individual orders
                for guestData in guestsData {
                    let guestName = guestData["name"] as! String
                    let guestOpenTimeStamp = guestData["openTime"] as! Timestamp
                    let guestOpenTime = guestOpenTimeStamp.dateValue()
                    let guestCloseTimeStamp = guestData["closeTime"] as? Timestamp
                    let guestCloseTime = guestCloseTimeStamp?.dateValue()
                    let guestTotalAmount = guestData["totalAmount"] as? Float ?? 0.0
                    
                    let guest = GuestsTable(guestName: guestName, openTime: guestOpenTime, tableSession: tableSession, closeTime: guestCloseTime, totalAmount: guestTotalAmount)
                    
                    var guestOrders = [OrdersTable]()
                    let guestOrdersData = guestData["Orders"] as! [[String:Any]]
                    for guestOrderData in guestOrdersData {
                        let menuItemName = guestOrderData["name"] as! String
                        let price = guestOrderData["price"] as! Float
                        let quantity = guestOrderData["quantity"] as! Int16
                        
                        let guestOrder = OrdersTable(menuItemName: menuItemName, quantity: quantity, price: price, orderedGuest: guest)
                        guestOrders.append(guestOrder)
                    }
                    guest.orders = guestOrders
                    guests.append(guest)
                }
                
                // Get shared orders
                var orders = [OrdersTable]()
                let ordersData = data["Orders"] as! [[String:Any]]
                for orderData in ordersData {
                    let menuItemName = orderData["name"] as! String
                    let price = orderData["price"] as! Float
                    let quantity = orderData["quantity"] as! Int16
                    
                    let order = OrdersTable(menuItemName: menuItemName, quantity: quantity, price: price, orderedTable: tableSession)
                    orders.append(order)
                }
                
                tableSession.orderedItems = orders
                tableSession.guests = guests
                
                // Check if database contains more than one active session for table (INCORRECT!!!) and throw an error
                if snapshot.documents.count > 1 {
                    let myError = iCafeManagerError.DatabaseError("Ambiguous sessions for table \(table.tableName) found. Notify iCafeManager support. UserID: \(userId)")
                    completion(tableSession, myError)
                }
                completion(tableSession, error)
            }
            completion(nil, error)
        }
    }
    
    
    
    
    /*
    class func getTables(completion: @escaping ([TablesTable], Error?) -> Void) {
        var tables = [TablesTable]()
        
        let tablesCollection = userData
            .collection("tables")
            .order(by: "name", descending: false)
        tablesCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(tables, error)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let fireBaseID = document.documentID
                    let tableName = data["name"] as! String
                    let tableCapacity = data["capacity"] as! Int16
                    let tableDescription = data["description"] as? String
                    
                    let table = TablesTable(firebaseID: fireBaseID, tableName: tableName, tableCapacity: tableCapacity, tableDescription: tableDescription, tableSession: nil)
                    
                    tables.append(table)
                }

                let tablesCount = tables.count
                for var i in 0...tablesCount-1 {
                    let table = tables[i]
                    DBQuery.getActiveTableSession(forTable: table, completion: { (tableSession, error) in
                        
                        if let error = error {
                            CommonAlert.shared.show(title: "Error occurred", text: "An error occurred while retrieving data from DB: \(error)")
                            return
                        }
                        table.tableSession = tableSession
                        
                        if i == tablesCount-1 {
                            completion(tables, nil)
                        }
                    })
                    i = i + 1
                }
            }
        }
    }
    
    class func getActiveTableSession (forTable table: TablesTable, completion: @escaping (TableSessionTable?, Error?) -> Void) {
        
        let tableReference = userData.collection("tables").document(table.firebaseID!)
        let tableSessionCollection = userData
            .collection("sessions")
            .whereField("tableReference", isEqualTo: tableReference)
            .whereField("isOpen", isEqualTo: true)
        tableSessionCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                guard snapshot.count != 0 else {return}
                let document = snapshot.documents[0]
                let data = document.data()
                let fireBaseID = document.documentID
                let openTimeStamp = data["openTime"] as! Timestamp
                let openTime = openTimeStamp.dateValue()
                
                let tableSession = TableSessionTable(firebaseID: fireBaseID, table: table, openTime: openTime)

                DBQuery.getGuests(forTableSession: tableSession, completion: { (guests, error) in
                    tableSession.guests = guests
                    
                    // Get session orders
                    DBQuery.getOrdersFromDB(forTableSession: tableSession, completion: { (orders, error) in
                        tableSession.orderedItems = orders
                    })
                    
                    completion(tableSession, error)
                })
                
                
                // Add guest and orderedItems variables once respective functions will be developed
                //let tableSession = TableSessionTable(table: table, openTime: openTime, guests: guests, orderedItems: orderedItems)
                
                if snapshot.documents.count > 1 {
                    let myError = iCafeManagerError.DatabaseError("Ambiguous sessions for table \(table.tableName) found. Notify iCafeManager support. UserID: \(userId)")
                    completion(tableSession, myError)
                }
            }
        }
    }
    
    class func getGuests(forTableSession tableSession: TableSessionTable, completion: @escaping ([GuestsTable], Error?) -> Void) {
        let tableSessionReference = userData.collection("sessions").document(tableSession.firebaseID!)

        let tableSessionCollection = userData
            .collection("guests")
            .whereField("sessionReference", isEqualTo: tableSessionReference)
        tableSessionCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            var guests = [GuestsTable]()

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let fireBaseID = document.documentID
                    let guestName = data["name"] as! String
                    let openTimeStamp = data["openTime"] as! Timestamp
                    let openTime = openTimeStamp.dateValue()
                    let closeTimeStamp = data["closeTime"] as? Timestamp
                    let closeTime = closeTimeStamp?.dateValue()
                    let totalAmount = data["totalAmount"] as? Float ?? 0.0
                    
                    let guest = GuestsTable(firebaseID: fireBaseID, guestName: guestName, openTime: openTime, tableSession: tableSession, closeTime: closeTime, totalAmount: totalAmount, orders: [])
                    
                    // Get guest's orders
                    DBQuery.getOrdersFromDB(forGuest: guest, completion: { (orders, error) in
                        if error != nil {
                            guest.orders = orders
                            guests.append(guest)
                        }
                    })
                }
                completion(guests, nil)
            }
        }
    }

    class func getOrdersFromDB(forTableSession tableSession: TableSessionTable, completion: @escaping ([OrdersTable], Error?) -> Void) {
        let tableSessionReference = userData.collection("sessions").document(tableSession.firebaseID!)
        
        let orderCollection = userData
            .collection("orders")
            .whereField("sessionReference", isEqualTo: tableSessionReference)
        orderCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            var orders = [OrdersTable]()
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let fireBaseID = document.documentID
                    let quantity = data["quantity"] as! Int16
                    let menuItemReference = data["menuItemReference"] as! DocumentReference
                    
                    DBQuery.getMenuItem(forMenuItemReference: menuItemReference, completion: { (menuItem, error) in
                        if let error = error {
                            completion([], error)
                        }
                        
                        let order = OrdersTable(firebaseID: fireBaseID, menuItem: menuItem!, quantity: quantity, orderedTable: tableSession)
                        orders.append(order)
                    })
                }
                completion(orders, nil)
            }
        }
    }

    class func getOrdersFromDB(forGuest guest: GuestsTable, completion: @escaping ([OrdersTable], Error?) -> Void) {
        let guestReference = userData.collection("guests").document(guest.firebaseID!)
        
        let orderCollection = userData
            .collection("orders")
            .whereField("guestReference", isEqualTo: guestReference)
        orderCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            var orders = [OrdersTable]()
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let fireBaseID = document.documentID
                    let quantity = data["quantity"] as! Int16
                    let menuItemReference = data["menuItemReference"] as! DocumentReference
                    
                    DBQuery.getMenuItem(forMenuItemReference: menuItemReference, completion: { (menuItem, error) in
                        if let error = error {
                            completion([], error)
                        }
                        
                        let order = OrdersTable(firebaseID: fireBaseID, menuItem: menuItem!, quantity: quantity, orderedGuest: guest)
                        orders.append(order)
                    })
                }
                completion(orders, nil)
            }
        }
    }
    
    class func getMenuItem(forMenuItemReference menuItemReference: DocumentReference, completion: @escaping (MenuTable?, Error?) -> Void){
        menuItemReference.getDocument(completion: { (document, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let data = document!.data() else {return}
            let firebaseID = document?.documentID
            let itemName = data["name"] as! String
            let itemDescription = data["Description"] as? String
            let itemPrice = data["price"] as! Float
            let menuItem = MenuTable(firebaseID: firebaseID, itemName: itemName, itemDescription: itemDescription, itemPrice: itemPrice)
            completion(menuItem, nil)
        })
    }
 */
}
