//
//  OrdersTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing OrdersTable in CoreData.

import UIKit
import CoreData

class OrdersTable: NSManagedObject {
    static let menuTableRequest : NSFetchRequest<MenuTable> = MenuTable.fetchRequest()
    static let tableSessionRequest: NSFetchRequest<TableSessionTable> = TableSessionTable.fetchRequest()
    
    // MARK: methods
    func increaseQuantity() {
        self.quantityOfItems += 1
        try? viewContext.save()
    }
    
    func decreaseQuantity() {
        self.quantityOfItems -= 1
        try? viewContext.save()
    }
    
    func remove () {
        viewContext.delete(self)
        try? viewContext.save()
    }
    
    // MARK: class functions
    class func addOrIncreaseOrder (tableSession: TableSessionTable, menuItem: MenuTable) {
        
        let sessionPredicate = appDelegate.smStore?.predicate(for: "orderedTable", referencing: tableSession) ?? NSPredicate()
        let request : NSFetchRequest<OrdersTable> = OrdersTable.fetchRequest()
        request.predicate = sessionPredicate
        
        if let matchedOrders = try? viewContext.fetch(request) {
            for order in matchedOrders {
                if order.menuItem == menuItem {
                    order.quantityOfItems = order.quantityOfItems + 1
                    try? viewContext.save()
                    return
                }
            }
        }
        if #available(iOS 10.0, *) {
            let newOrder = OrdersTable(context: viewContext)
            newOrder.menuItem = menuItem
            newOrder.orderedTable = tableSession
            newOrder.quantityOfItems = 1
        } else {
            let newOrder = OrdersTable(entity: NSEntityDescription.entity(forEntityName: "OrdersTable", in: viewContext)!, insertInto: viewContext)
            newOrder.menuItem = menuItem
            newOrder.orderedTable = tableSession
            newOrder.quantityOfItems = 1
        }
        try? viewContext.save()
    }
    
    class func getOrdersFor (tableSession: TableSessionTable) -> [OrdersTable] {
        let sessionPredicate = appDelegate.smStore?.predicate(for: "orderedTable", referencing: tableSession) ?? NSPredicate()
        let request : NSFetchRequest<OrdersTable> = OrdersTable.fetchRequest()
        request.predicate = sessionPredicate
        
        if let matchedOrders = try? viewContext.fetch(request) {
            return matchedOrders
        } else {
            return []
        }
    }
}

extension OrdersTable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrdersTable> {
        return NSFetchRequest<OrdersTable>(entityName: "OrdersTable")
    }
    
    @NSManaged public var isActive: Bool
    @NSManaged public var quantityOfItems: Int32
    @NSManaged public var menuItem: MenuTable?
    @NSManaged public var orderedTable: TableSessionTable?
    
}
