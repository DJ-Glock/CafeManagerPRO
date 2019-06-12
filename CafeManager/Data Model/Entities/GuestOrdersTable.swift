//
//  GuestOrdersTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

class GuestOrdersTable {
    
    
    //// TO BE REPLACED WITH OrdersTable AND DECOMMED!!!

    public var quantityOfItems: Int16
    public var menuItem: MenuTable
    public weak var orderedGuest: GuestsTable?
    
    init (menuItem: MenuTable, quantity: Int16, orderedGuest: GuestsTable) {
        self.menuItem = menuItem
        self.quantityOfItems = quantity
        self.orderedGuest = orderedGuest
    }
    
    // MARK: methods
    func increaseQuantity() {
//        self.quantityOfItems += 1
//        try? viewContext.save()
    }
    
    func decreaseQuantity() {
//        self.quantityOfItems -= 1
//        try? viewContext.save()
    }
    
    func remove() {
//        viewContext.delete(self)
//        try? viewContext.save()
    }
    
    // MARK: class functions
    class func addOrIncreaseOrder(for guest: GuestsTable, menuItem: MenuTable) {
        
        //let sessionPredicate = appDelegate.smStore?.predicate(for: "orderedGuest", referencing: guest) ?? NSPredicate()
//        let request : NSFetchRequest<GuestOrdersTable> = GuestOrdersTable.fetchRequest()
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
//
//        if #available(iOS 10.0, *) {
//            let newOrder = GuestOrdersTable(context: viewContext)
//            newOrder.menuItem = menuItem
//            newOrder.orderedGuest = guest
//            newOrder.quantityOfItems = 1
//        } else {
//            let newOrder = GuestOrdersTable(entity: NSEntityDescription.entity(forEntityName: "GuestOrdersTable", in: viewContext)!, insertInto: viewContext)
//            newOrder.menuItem = menuItem
//            newOrder.orderedGuest = guest
//            newOrder.quantityOfItems = 1
//        }
//        try? viewContext.save()
    }
    
    class func getOrders (for guest: GuestsTable) -> [GuestOrdersTable] {
        
        //let sessionPredicate = appDelegate.smStore?.predicate(for: "orderedGuest", referencing: guest) ?? NSPredicate()
//        let request : NSFetchRequest<GuestOrdersTable> = GuestOrdersTable.fetchRequest()
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
