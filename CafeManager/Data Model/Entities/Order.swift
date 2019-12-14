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
    public weak var orderedTable: TableSession?
    public weak var orderedGuest: Guest?
    
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
//        self.quantityOfItems += 1
//        try? viewContext.save()
    }
    
    func decreaseQuantity() {
        self.quantity -= 1
//        self.quantityOfItems -= 1
//        try? viewContext.save()
    }
    
    func remove () {
//        viewContext.delete(self)
//        try? viewContext.save()
    }
    
    // MARK: class functions
    class func addOrIncreaseOrder (tableSession: TableSession, menuItem: MenuItem) {
//
//        //let sessionPredicate = appDelegate.smStore?.predicate(for: "orderedTable", referencing: tableSession) ?? NSPredicate()
//        let request : NSFetchRequest<OrdersTable> = OrdersTable.fetchRequest()
//        request.predicate = sessionPredicate
//
//        if let matchedOrders = try? viewContext.fetch(request) {
//            for order in matchedOrders {
//                if order.menuItem == menuItem {
//                    order.quantityOfItems = order.quantityOfItems + 1
//                    try? viewContext.save()
//                    return
//                }
//            }
//        }
//        if #available(iOS 10.0, *) {
//            let newOrder = OrdersTable(context: viewContext)
//            newOrder.menuItem = menuItem
//            newOrder.orderedTable = tableSession
//            newOrder.quantityOfItems = 1
//        } else {
//            let newOrder = OrdersTable(entity: NSEntityDescription.entity(forEntityName: "OrdersTable", in: viewContext)!, insertInto: viewContext)
//            newOrder.menuItem = menuItem
//            newOrder.orderedTable = tableSession
//            newOrder.quantityOfItems = 1
//        }
//        try? viewContext.save()
    }
    
    class func getOrdersFor (tableSession: TableSession) -> [Order] {
//        //let sessionPredicate = appDelegate.smStore?.predicate(for: "orderedTable", referencing: tableSession) ?? NSPredicate()
//        let request : NSFetchRequest<OrdersTable> = OrdersTable.fetchRequest()
//        request.predicate = sessionPredicate
//
//        if let matchedOrders = try? viewContext.fetch(request) {
//            return matchedOrders
//        } else {
//            return []
//        }
        return []
    }
}
