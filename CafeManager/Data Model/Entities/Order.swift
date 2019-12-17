//
//  OrdersTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing OrdersTable in CoreData.

import Foundation

class Order {
    public var menuItemName: String
    public var quantity: Int16
    public var price: Float
    public var amount: Float {
        return price * Float(quantity)
    }
    public weak var orderedTable: TableSession?
    public weak var orderedGuest: Guest?
    private var tableSession: TableSession? {
        self.orderedTable ?? self.orderedGuest?.tableSession
    }
    
    init (menuItemName: String, quantity: Int16, price: Float, orderedTable: TableSession) {
        self.menuItemName = menuItemName
        self.quantity = quantity
        self.price = price
        self.orderedTable = orderedTable
    }
    
    init (menuItemName: String, quantity: Int16, price: Float, orderedGuest: Guest) {
        self.menuItemName = menuItemName
        self.quantity = quantity
        self.price = price
        self.orderedGuest = orderedGuest
    }
    
    
    // MARK: methods
    func increaseQuantity() {
        self.quantity += 1
        let tableSession = self.tableSession!
        DBGeneral.updateActiveSession(tableSession: tableSession)
    }
    
    func decreaseQuantity() {
        self.quantity -= 1
        let tableSession = self.tableSession!
        DBGeneral.updateActiveSession(tableSession: tableSession)
    }
    
    func remove() {
        let tableSession = self.tableSession!
        
        if let session = self.orderedTable {
            let count = session.orders.count
            for i in 0..<count {
                let order = session.orders[i]
                if order === self {
                    session.orders.remove(at: i)
                    break
                }
            }
        } else if let session = self.orderedGuest {
            let count = session.orders.count
            for i in 0..<count {
                let order = session.orders[i]
                if order === self {
                    session.orders.remove(at: i)
                    break
                }
            }
        }
        DBGeneral.updateActiveSession(tableSession: tableSession)
    }
}
