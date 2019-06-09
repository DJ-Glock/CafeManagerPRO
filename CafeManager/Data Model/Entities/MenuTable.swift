//
//  MenuTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing MenuTable in CoreData.

import Foundation

class MenuTable {
    
    public var itemDescription: String?
    public var itemName: String?
    public var itemPrice: Float = 0.0
    public var isHidden: Bool = false
    public var orders: NSSet?
    public var guestOrders: NSSet?
    public var category: MenuCategoryTable?
    
    
    
    // MARK: methods
    func changeMenuItemTo (newMenuItem: Menu) {
//        self.itemName = newMenuItem.itemName
//        self.itemPrice = newMenuItem.itemPrice
//        self.itemDescription = newMenuItem.itemDescription
//        let newCategory = MenuCategoryTable.getOrCreateCategory(category: newMenuItem.itemCategory)
//        self.category = newCategory
//        try? viewContext.save()
    }
    
    func hideMenuItem () {
//        self.isHidden = true
//        try? viewContext.save()
    }
    
    func showMenuItem () {
//        self.isHidden = false
//        try? viewContext.save()
    }
    
    func remove () {
//        let orders = MenuTable.getOrdersFor(menuItem: self)
//        for order in orders {
//            order.remove()
//        }
//
//        let guestOrders = MenuTable.getGuestOrdersFor(menuItem: self)
//        for guestOrder in guestOrders {
//            guestOrder.remove()
//        }
//
//        viewContext.delete(self)
//        try? viewContext.save()
    }
    
    // MARK: Class functions
    class func getOrdersFor (menuItem: MenuTable) -> [OrdersTable] {
//        //let ordersPredicate = appDelegate.smStore?.predicate(for: "menuItem", referencing: menuItem) ?? NSPredicate()
//        let request: NSFetchRequest<OrdersTable> = OrdersTable.fetchRequest()
//        request.predicate = ordersPredicate
//
//        if let orders = try? viewContext.fetch(request) {
//            return orders
//        } else {
//            return []
//        }
        return []
    }
    
    class func getGuestOrdersFor (menuItem: MenuTable) -> [GuestOrdersTable] {
//        //let ordersPredicate = appDelegate.smStore?.predicate(for: "menuItem", referencing: menuItem) ?? NSPredicate()
//        let request: NSFetchRequest<GuestOrdersTable> = GuestOrdersTable.fetchRequest()
//        request.predicate = ordersPredicate
//
//        if let orders = try? viewContext.fetch(request) {
//            return orders
//        } else {
//            return []
//        }
        return []
    }

    
    class func addMenuItem (item: Menu) {
//        if let itemCategory = MenuCategoryTable.getOrCreateCategory(category: item.itemCategory) {
//            do {
//                try viewContext.save()
//                if #available(iOS 10.0, *) {
//                    let newMenuItem = MenuTable(context: viewContext)
//                    newMenuItem.itemName = item.itemName
//                    newMenuItem.itemDescription = item.itemDescription
//                    newMenuItem.itemPrice = item.itemPrice
//                    itemCategory.addToMenuItem(newMenuItem)
//                } else {
//                    let newMenuItem = MenuTable(entity: NSEntityDescription.entity(forEntityName: "MenuTable", in: viewContext)!, insertInto: viewContext)
//                    newMenuItem.itemName = item.itemName
//                    newMenuItem.itemDescription = item.itemDescription
//                    newMenuItem.itemPrice = item.itemPrice
//                    itemCategory.addToMenuItem(newMenuItem)
//                }
//                do {
//                    try viewContext.save()
//                } catch {
//                    print("Error while saving context after MenuTable with category insert \(error)")
//                }
//            } catch {
//                print("Error while saving context after MenuCategoryTable insert \(error)")
//            }
//        }
    }
    
    class func getActiveMenuItem (withName name: String) -> MenuTable? {
//        let request: NSFetchRequest<MenuTable> = MenuTable.fetchRequest()
//        request.predicate = NSPredicate(format: "itemName = %@ AND isHidden = %@", name, NSNumber(value: false))
//        if let result = try? viewContext.fetch(request) {
//            return result.first
//        }
        return nil
    }
//
    class func getActiveMenuItems () -> [MenuTable] {
//        let request: NSFetchRequest<MenuTable> = MenuTable.fetchRequest()
//        request.predicate = NSPredicate(format: "isHidden = %@", NSNumber(value: false))
//        let theFirstSortDescriptor = NSSortDescriptor(key: "category.categoryName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//        let theSecondSortDescriptor = NSSortDescriptor(key: "itemName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//        request.sortDescriptors = [theFirstSortDescriptor, theSecondSortDescriptor]
//        if let result = try? viewContext.fetch(request) {
//            return result
//        }
        return []
    }
    
    class func getActiveMenuItems (withNameContains text: String) -> [MenuTable] {
//        let request: NSFetchRequest<MenuTable> = MenuTable.fetchRequest()
//        request.predicate = NSPredicate(format: "isHidden = %@ AND itemName CONTAINS[cd] %@", NSNumber(value: false), text)
//        let theFirstSortDescriptor = NSSortDescriptor(key: "category.categoryName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//        let theSecondSortDescriptor = NSSortDescriptor(key: "itemName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//        request.sortDescriptors = [theFirstSortDescriptor, theSecondSortDescriptor]
//        if let result = try? viewContext.fetch(request) {
//            return result
//        }
        return []
    }
    
    class func bulkAddMenuItems (items: [Menu]) throws {
//        do {
//            for item in items {
//                if let itemCategory = MenuCategoryTable.getOrCreateCategory(category: item.itemCategory) {
//                    if #available(iOS 10.0, *) {
//                        let newMenuItem = MenuTable(context: viewContext)
//                        newMenuItem.itemName = item.itemName
//                        newMenuItem.itemDescription = item.itemDescription
//                        newMenuItem.itemPrice = item.itemPrice
//                        itemCategory.addToMenuItem(newMenuItem)
//                    } else {
//                        let newMenuItem = MenuTable(entity: NSEntityDescription.entity(forEntityName: "MenuTable", in: viewContext)!, insertInto: viewContext)
//                        newMenuItem.itemName = item.itemName
//                        newMenuItem.itemDescription = item.itemDescription
//                        newMenuItem.itemPrice = item.itemPrice
//                        itemCategory.addToMenuItem(newMenuItem)
//                    }
//                }
//            }
//            try viewContext.save()
//        } catch {
//            throw (iCafeManagerError.CoreDataException("Error during bulk addition to MenuTable \(error)"))
//        }
    }
    
    // New function for ordered items statistics
    class func getDetailedOrdersStatistics (from startDate: Date, to endDate: Date) -> [String:[Date]] {
        var result: [String:[Date]] = [:]
        
//        let menuItems = try? viewContext.fetch(menuTableRequest)
//        guard menuItems != nil else {return [:]}
//
//        let tableSessionPredicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
//        tableSessionRequest.predicate = tableSessionPredicate
//
//        if let matchedTableSessions = try? viewContext.fetch(tableSessionRequest) {
//            var orders: [OrdersTable] = []
//            var guestOrders: [GuestOrdersTable] = []
//
//            for session in matchedTableSessions {
//                // Get session orders
//                let sessionOrders = OrdersTable.getOrdersFor(tableSession: session)
//                for sessionOrder in sessionOrders {
//                    orders.append(sessionOrder)
//                }
//
//                // Get guest orders
//                let guests = GuestsTable.getAllGuestsFor(tableSession: session)
//                for guest in guests {
//                    let currentGuestOrders = GuestOrdersTable.getOrders(for: guest)
//                    for currentGuestOrder in currentGuestOrders {
//                        guestOrders.append(currentGuestOrder)
//                    }
//                }
//            }
//
//            // Transform objects to plain data
//            for order in orders {
//                let itemName = order.menuItem!.itemName!
//                if let date = order.orderedTable?.openTime as Date? {
//                    var value = result[itemName] ?? []
//                    value.append(date)
//                    result[itemName] = value
//                }
//            }
//
//            for guestOrder in guestOrders {
//                let itemName = guestOrder.menuItem!.itemName!
//                if let date = guestOrder.orderedGuest?.openTime as Date? {
//                    var value = result[itemName] ?? []
//                    value.append(date)
//                    result[itemName] = value
//                }
//            }
//        }

        return result
    }
    
}
