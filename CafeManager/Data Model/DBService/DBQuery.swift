//
//  DBQuery.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation
import Firebase
import Dispatch

class DBQuery {
    /// Async function returns all tables with active sessions (if any)
    class func getTablesWithActiveSessionAsync(completion: @escaping ([Table], Error?) -> Void) {
        let tablesCollection = userData
            .collection("Tables")
            .order(by: "name", descending: false)
        
        tablesCollection.addSnapshotListener { (snapshot, error) in
            var tables = [Table]()
            
            if let error = error {
                completion (tables, error)
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let firebaseID = document.documentID
                    let tableName = data["name"] as! String
                    let tableCapacity = data["capacity"] as! Int16
                    
                    let table = Table(firebaseID: firebaseID, tableName: tableName, tableCapacity: tableCapacity)
                    tables.append(table)
                }
            }
        
            // Get active sessions for each table.
            // Run completion only when the last one is processed.
            var counter = tables.count
            
            for table in tables {
                DBQuery.getActiveTableSessionAsync(forTable: table, completion: { (tableSession, error) in
                    if let error = error {
                        completion([], error)
                        return
                    }
                    table.tableSession = tableSession
                    
                    counter = counter - 1
                    if (counter <= 0) {
                        completion(tables, nil)
                    }
                })
            }
        }
    }
    
    /// Async function returns table session for table or nil if no active session is opened.
    class func getActiveTableSessionAsync (forTable table: Table, completion: @escaping (TableSession?, Error?) -> Void) {
        let tableSessionCollection = userData
            .collection("Tables")
            .document(table.firebaseID!)
            .collection("ActiveSession")
        
        tableSessionCollection.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let snapshot = snapshot {
                guard snapshot.documents.count != 0 else { completion(nil, error); return }
                
                let document = snapshot.documents[0]
                let data = document.data()
                let firebaseID = document.documentID
                
                let openTimeStamp = data["openTime"] as! Timestamp
                let openTime = openTimeStamp.dateValue()
                let closeTimeStamp = data["closeTime"] as? Timestamp
                let closeTime = closeTimeStamp?.dateValue()
                let totalAmount = data["totalAmount"] as? Float ?? 0.0
                let tips = data["tips"] as? Float ?? 0.0
                let discount = data["discount"] as? Int16 ?? 0
                
                let tableSession = TableSession(firebaseID: firebaseID, table: table, openTime: openTime, closeTime: closeTime, guests: [], orders: [], amount: totalAmount, tips: tips, discount: discount)
                
                var guests = [Guest]()
                let guestsData = data["Guests"] as? [[String:Any]] ?? []
                
                // Get Guests and their individual orders
                for guestData in guestsData {
                    let guestName = guestData["name"] as! String
                    let guestOpenTimeStamp = guestData["openTime"] as! Timestamp
                    let guestOpenTime = guestOpenTimeStamp.dateValue()
                    let guestCloseTimeStamp = guestData["closeTime"] as? Timestamp
                    let guestCloseTime = guestCloseTimeStamp?.dateValue()
                    let guestTotalAmount = guestData["totalAmount"] as? Float ?? 0.0
                    
                    let guest = Guest(name: guestName, openTime: guestOpenTime, tableSession: tableSession, closeTime: guestCloseTime, totalAmount: guestTotalAmount)
                    
                    var guestOrders = [Order]()
                    let guestOrdersData = guestData["Orders"] as? [[String:Any]] ?? []
                    for guestOrderData in guestOrdersData {
                        let menuItemName = guestOrderData["name"] as! String
                        let price = guestOrderData["price"] as! Float
                        let quantity = guestOrderData["quantity"] as! Int16
                        
                        let guestOrder = Order(menuItemName: menuItemName, quantity: quantity, price: price, orderedGuest: guest)
                        guestOrders.append(guestOrder)
                    }
                    guest.orders = guestOrders
                    guests.append(guest)
                }
                
                // Get shared orders
                var orders = [Order]()
                let ordersData = data["Orders"] as? [[String:Any]] ?? []
                for orderData in ordersData {
                    let menuItemName = orderData["name"] as! String
                    let price = orderData["price"] as! Float
                    let quantity = orderData["quantity"] as! Int16
                    
                    let order = Order(menuItemName: menuItemName, quantity: quantity, price: price, orderedTable: tableSession)
                    orders.append(order)
                }
                
                tableSession.orders = orders
                tableSession.guests = guests
                
                // Check if database contains more than one active session for table (INCORRECT!!!) and throw an error
                if snapshot.documents.count > 1 {
                    let myError = iCafeManagerError.DatabaseError("Ambiguous sessions for table \(table.name) found. Notify iCafeManager support. UserID: \(String(describing: userId))")
                    completion(tableSession, myError)
                    return
                } else {
                    completion(tableSession, error)
                    return
                }
            }
            completion(nil,nil)
        }
    }
    
    class func getUserSettingsAndMenuAsync(completion: @escaping (Error?) -> Void) {
        let userDocument = userData
        userDocument!.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion (error)
            }
            if let snapshot = snapshot {
                guard let data = snapshot.data() else {return}
                
                let settings = data["Settings"] as! [String:Any]
                let cafeName = settings["cafeName"] as? String ?? ""
                let currencyCode = settings["currencyCode"] as? String ?? "USD"
                let isTimeCafe = settings["isTimeCafe"] as? Bool ?? false
                let pricePerMinute = settings["pricePerMinute"] as? Float ?? 0.0
                UserSettings.shared.cafeName = cafeName
                UserSettings.shared.currencyCode = currencyCode
                UserSettings.shared.isTimeCafe = isTimeCafe
                UserSettings.shared.pricePerMinute = pricePerMinute
                
                let menu = Menu.shared
                let menuData = data["Menu"] as? [String:Any] ?? [:]
                for (category, items) in menuData {
                    let items = items as? [[String:Any]] ?? []
                    var menuItems = [MenuItem]()
                    
                    for item in items {
                        let name = item["name"] as! String
                        let description = item["description"] as? String
                        let price = item["price"] as! Float
                        let menuItem = MenuItem(name: name, description: description, price: price, category: category)
                        menuItems.append(menuItem)
                    }
                    menuItems = menuItems.sorted(by: { $0.name < $1.name })
                    menu.menuItems[category] = menuItems
                }
                completion (nil)
            }
        }
    }

}
