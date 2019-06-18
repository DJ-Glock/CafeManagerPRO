//
//  DBPersist.swift
//  CafeManager
//
//  Created by Denis Kurashko on 16/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation
import Firebase

class DBPersist {
    class func createTableAsync (newTable table: Table, completion: @escaping (Error?)-> Void) {
        var tableData = [String:Any]()
        tableData["name"] = table.name
        tableData["capacity"] = table.capacity
        
        let tableDocumentRef = userData.collection("Tables").addDocument(data: tableData) { (error) in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
        table.firebaseID = tableDocumentRef.documentID
    }

    class func createActiveTableSessionAsync (newTableSession tableSession: TableSession, completion: @escaping (Error?)-> Void) {
        guard let tableDocumentID = tableSession.table?.firebaseID else { completion(iCafeManagerError.DatabaseError("firebaseID is null for table: \(String(describing: tableSession.table!.name))")); return }
        
        var tableSessionData = [String:Any]()
        
        tableSessionData["openTime"] = tableSession.openTime
        
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
        
        let tableSessionDocumentRef = userData.collection("Tables").document(tableDocumentID).collection("ActiveSession").addDocument(data: tableSessionData) { (error) in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
        tableSession.firebaseID = tableSessionDocumentRef.documentID
    }
}
