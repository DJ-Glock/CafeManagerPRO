//
//  DBUpdate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 16/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation
import Firebase

class DBUpdate {
    class func updateTableAsync (tableToChange table: Table, completion: @escaping (Error?)-> Void) {
        guard let documentID = table.firebaseID else { completion(iCafeManagerError.DatabaseError("firebaseID is null for table: \(table.name)")); return }
        
        var tableData = [String:Any]()
        tableData["name"] = table.name
        tableData["capacity"] = table.capacity
        
        
        let tableDocument = userData.collection("Tables").document(documentID)
        tableDocument.updateData(tableData) { (error) in
            completion(error)
        }
    }
    
    class func updateGuestsOfActiveTableSessionAsync (tableSessionToUpdate tableSession: TableSession, completion: @escaping (Error?)->Void) {
        guard let tableDocumentID = tableSession.table?.firebaseID else { completion(iCafeManagerError.DatabaseError("firebaseID is null for table: \(String(describing: tableSession.table!.name))")); return }
        guard let tableSessionDocumentID = tableSession.firebaseID else {completion(iCafeManagerError.DatabaseError("firebaseID is null for tableSession of table: \(String(describing: tableSession.table!.name))")); return}
        
        var tableSessionData = [String:Any]()
        let guests = tableSession.guests
        var guestsData = [[String:Any]]()
        
        for guest in guests {
            let name = guest.name
            let openTime = guest.openTime
            let amount = guest.amount
            let closeTime = guest.closeTime
            
            var guestData = [String:Any]()
            guestData["name"] = name
            guestData["openTime"] = openTime
            guestData["amount"] = amount
            guestData["closeTime"] = closeTime
            
            var ordersData = [[String:Any]]()
            let orders = guest.orders
            for order in orders {
                let menuItemName = order.menuItemName
                let quantity = order.quantity
                let price = order.price
                var orderData = [String:Any]()
                orderData["name"] = menuItemName
                orderData["quantity"] = quantity
                orderData["price"] = price
                ordersData.append(orderData)
            }
            guestData["Orders"] = ordersData
            
            guestsData.append(guestData)
        }
        tableSessionData["Guests"] = guestsData
        
        let sessionDocument = userData.collection("Tables").document(tableDocumentID).collection("ActiveSession").document(tableSessionDocumentID)
        sessionDocument.updateData(tableSessionData) { (error) in
            completion(error)
        }
    }
    
    class func updateActiveTableSession (session tableSession: TableSession, completion: @escaping (Error?)->Void) {
        guard let tableDocumentID = tableSession.table!.firebaseID else { completion(iCafeManagerError.DatabaseError("firebaseID is null for table: \(String(describing: tableSession.table!.name))")); return }
        guard let tableSessionDocumentID = tableSession.firebaseID else {completion(iCafeManagerError.DatabaseError("firebaseID is null for tableSession of table: \(String(describing: tableSession.table!.name))")); return}
        
        var tableSessionData = [String:Any]()
        let orders = tableSession.orders
        var ordersData = [[String:Any]]()
        
        for order in orders {
            let menuItemName = order.menuItemName
            let quantity = order.quantity
            let price = order.price
            var orderData = [String:Any]()
            orderData["name"] = menuItemName
            orderData["quantity"] = quantity
            orderData["price"] = price
            ordersData.append(orderData)
        }
        tableSessionData["Orders"] = ordersData
        
        let guests = tableSession.guests
        var guestsData = [[String:Any]]()
        
        for guest in guests {
            let orders = guest.orders
            var ordersData = [[String:Any]]()
            
            for order in orders {
                let menuItemName = order.menuItemName
                let quantity = order.quantity
                let price = order.price
                var orderData = [String:Any]()
                orderData["name"] = menuItemName
                orderData["quantity"] = quantity
                orderData["price"] = price
                ordersData.append(orderData)
            }
            
            var guestData = [String:Any]()
            guestData["name"] = guest.name
            guestData["openTime"] = guest.openTime
            guestData["closeTime"] = guest.closeTime
            guestData["Orders"] = ordersData
            guestData["amount"] = guest.amount
            
            guestsData.append(guestData)
        }
        tableSessionData["Guests"] = guestsData
        
        
        let sessionDocument = userData.collection("Tables").document(tableDocumentID).collection("ActiveSession").document(tableSessionDocumentID)
        sessionDocument.updateData(tableSessionData) { (error) in
            completion(error)
        }
    }
    
    
    class func updateUserSettingsAndMenuAsync (completion: @escaping (Error?)-> Void) {
        var settings = [String:Any]()
        settings["cafeName"] = UserSettings.shared.cafeName
        settings["isTimeCafe"] = UserSettings.shared.isTimeCafe
        settings["currencyCode"] = UserSettings.shared.currencyCode
        settings["pricePerMinute"] = UserSettings.shared.pricePerMinute
        
        var menu = [String:[[String:Any]]]()
        let categories = Menu.shared.menuItems.keys
        for category in categories {
            if let items = Menu.shared.menuItems[category] {
                for item in items {
                    let name = item.name
                    let description = item.description
                    let price = item.price
                    
                    var plainItem = [String:Any]()
                    plainItem["name"] = name
                    plainItem["description"] = description
                    plainItem["price"] = price
                    
                    var currentItems = menu[category] ?? []
                    currentItems.append(plainItem)
                    menu[category] = currentItems
                }
            }
        }
        
        var data = [String:Any]()
        data["Settings"] = settings
        data["Menu"] = menu
        
        let userDocument = userData
        userDocument!.updateData(data) { (error) in
            completion(error)
        }
    }
}
