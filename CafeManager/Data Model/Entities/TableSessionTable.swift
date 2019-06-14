//
//  TableSessionTble.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing TableSessionsTable in CoreData.

import Foundation

class TableSessionTable {
    
    public weak var table: TablesTable?
    public var openTime: Date
    public var closeTime: Date?
    public var guests: [GuestsTable] = []
    public var orderedItems: [OrdersTable] = []
    public var totalAmount: Float = 0.0
    public var tips: Float = 0.0
    public var discount: Int16 = 0

    
    init (table: TablesTable, openTime: Date) {
        self.table = table
        self.openTime = openTime
    }
    
    convenience init (table: TablesTable,
                     openTime: Date,
                     closeTime: Date?,
                     guests: [GuestsTable],
                     orderedItems: [OrdersTable],
                     totalAmount: Float,
                     tips :Float,
                     discount: Int16) {
        self.init(table: table, openTime: openTime)
        self.closeTime = closeTime
        self.guests = guests
        self.orderedItems = orderedItems
        self.totalAmount = totalAmount
        self.tips = tips
        self.discount = discount
    }

    // Supporting properties
    public var openTimeTruncatedToDay: String {
        return openTime.getTimeStrWithDayPrecision()
    }
    public var openTimeTruncatedToMonth: String {
        return openTime.getTimeStrWithMonthPrecision()
    }

    public var sessionDurationInSeconds: Double {
        let currentCloseTime = closeTime ?? Date()
        let period = currentCloseTime.timeIntervalSince1970 - openTime.timeIntervalSince1970
        return period
    }
    
    
    
    
    // MARK: functions for managing sessions
    class func createTableSession (table: TablesTable) -> TableSessionTable {
//        if #available(iOS 10.0, *) {
//            let newTableSession = TableSessionTable(context: viewContext)
//            newTableSession.openTime = Date() as NSDate
//            newTableSession.closeTime = nil
//            table.addToTableSession(newTableSession)
//            try? viewContext.save()
//            return newTableSession
//        } else {
//            let newTableSession = TableSessionTable(entity: NSEntityDescription.entity(forEntityName: "TableSessionTable", in: viewContext)!, insertInto: viewContext)
//            newTableSession.openTime = Date() as NSDate
//            newTableSession.closeTime = nil
//            table.addToTableSession(newTableSession)
//            try? viewContext.save()
//            return newTableSession
//        }
        return TableSessionTable(table: table, openTime: Date())
    }
    
    class func saveRecalculated (tableSession: TableSessionTable, totalAmount: Float, discount: Int16, tips: Float) throws {
//        tableSession.totalAmount = totalAmount
//        tableSession.discount = discount
//        tableSession.totalTips = tips
//        do {
//            try viewContext.save()
//        } catch {
//            throw (iCafeManagerError.CoreDataException("Error during saveAmountAndDiscount \(error)"))
//        }
    }
    
    class func checkout (tableSession: TableSessionTable, totalAmount: Float, discount: Int16, tips: Float) throws {
//        GuestsTable.closeAllGuestsForTable(tableSession: tableSession)
//        tableSession.totalAmount = totalAmount
//        tableSession.discount = discount
//        tableSession.totalTips = tips
//        tableSession.closeTime = Date() as NSDate
//        do {
//            try viewContext.save()
//        } catch {
//            throw (iCafeManagerError.CoreDataException("Error during closeTableSession \(error)"))
//        }
    }
    
    class func getCurrentTableSession (table: TablesTable) -> TableSessionTable? {
//        //let tablePredicate = appDelegate.smStore?.predicate(for: "table", referencing: table) ?? NSPredicate()
//        let timePredicate = NSPredicate(format: "closeTime = %@", NSNull() as CVarArg)
//        let request: NSFetchRequest<TableSessionTable> = TableSessionTable.fetchRequest()
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [tablePredicate, timePredicate])
//
//        let matchedSessions = try? viewContext.fetch(request)
//
//        if matchedSessions?.count != 0 {
//            var sessions = [TableSessionTable]()
//            for session in matchedSessions! {
//                sessions.append(session)
//            }
//            if sessions.count == 1 {
//                return sessions.first
//            } else if (sessions.count) > 1 {
//                print("CRITICAL ERROR: More than one opened session for table found! Returning the oldest one.")
//                sessions = sessions.sorted(by: { $0.openTime?.compare($1.openTime! as Date) == ComparisonResult.orderedAscending })
//                return sessions.first
//            }
//        }
        return nil
    }
    
    class func moveTableSessionTo (targetTable: TablesTable, currentSession: TableSessionTable) {
//        currentSession.table = targetTable
//        try? viewContext.save()
    }
    
    private static func removeSession(_ session: TableSessionTable) {
//        let guests = GuestsTable.getAllGuestsFor(tableSession: session)
//
//        for guest in guests {
//            let guestOrders = GuestOrdersTable.getOrders(for: guest)
//            for order in guestOrders {
//                viewContext.delete(order)
//            }
//            viewContext.delete(guest)
//        }
//
//        let orders = OrdersTable.getOrdersFor(tableSession: session)
//        for order in orders {
//            viewContext.delete(order)
//        }
//
//        viewContext.delete(session)
//        try? viewContext.save()
    }
    
    class func removeTableSessionsForTable (table: TablesTable) {
//        //let predicate = appDelegate.smStore?.predicate(for: "table", referencing: table)
//        tableSessionRequest.predicate = predicate
//        if let matchedTableSessions = try? viewContext.fetch(tableSessionRequest) {
//            for session in matchedTableSessions {
//                removeSession(session)
//            }
//        }
    }
    
    // MARK: functions for amounts calculation
    class func calculateAmountForTime(tableSession: TableSessionTable) -> Float {
        var amount: Float = 0
        guard UserSettings.isTimeCafe == true else {return amount}
        
        let guestsTable = GuestsTable.getAllGuestsForTableSorted(tableSession: tableSession)
        for guest in guestsTable {
            let closeOrCurrentTime = guest.closeTime ?? Date()
            amount = amount + roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime as Date))/60) * UserSettings.pricePerMinute
        }
        return amount
    }
    
    class func calculateIndividualAmount (guest: GuestsTable) -> Float {
        var amount: Float = 0
        var ordersAmount: Float = 0
        var amountForTime: Float = 0
        
//        if UserSettings.isTimeCafe {
//            let closeOrCurrentTime = guest.closeTime ?? Date() as NSDate
//            amountForTime = roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime! as Date))/60) * UserSettings.pricePerMinute
//        }
//
//        let orders = GuestOrdersTable.getOrders(for: guest)
//        if orders.count > 0 {
//            for order in orders {
//                var currentAmount: Float = 0
//                let currentOrderQuantity = order.quantityOfItems
//                if let currentOrderPrice = order.menuItem?.itemPrice {
//                    currentAmount = currentOrderPrice * Float(currentOrderQuantity)
//                }
//                ordersAmount += currentAmount
//            }
//        }
//        amount = amountForTime + ordersAmount
        
        return amount
    }
    
    class func calculateActualTotalAmount (for currentTableSession: TableSessionTable?) -> Float {
        guard currentTableSession != nil else {return 0}
        
        var totalAmount: Float = 0
        var ordersAmount: Float = 0
        var guestsAmount: Float = 0
        
//        let currentOrders = OrdersTable.getOrdersFor(tableSession: currentTableSession!)
//        for order in currentOrders {
//            ordersAmount += Float(order.quantityOfItems) * (order.menuItem?.itemPrice)!
//        }
//
//        let guests = GuestsTable.getActiveGuestsFor(tableSession: currentTableSession!)
//        for guest in guests {
//            guestsAmount += TableSessionTable.calculateIndividualAmount(guest: guest)
//        }
//
//        totalAmount = ordersAmount + guestsAmount
        
        return totalAmount
    }
    
    class func calculateTotalAmount (currentTableSession: TableSessionTable?) -> Float {
        guard currentTableSession != nil else {return 0}
        
        var totalAmount: Float = 0
        var ordersAmount: Float = 0
        var guestsAmount: Float = 0
//
//        let currentOrders = OrdersTable.getOrdersFor(tableSession: currentTableSession!)
//        for order in currentOrders {
//            ordersAmount += Float(order.quantityOfItems) * (order.menuItem?.itemPrice)!
//        }
//
//        let guests = GuestsTable.getAllGuestsFor(tableSession: currentTableSession!)
//        for guest in guests {
//            guestsAmount += TableSessionTable.calculateIndividualAmount(guest: guest)
//        }
//
//        totalAmount = ordersAmount + guestsAmount
        
        return totalAmount
    }
    
    
    // MARK: functions for statistics
    class func getTableSessionsTimingsAndAmounts (from startDate: Date, to endDate: Date) -> (dates: [Date], durationsInSeconds: [Double], amounts: [Double]) {
//        let request = NSFetchRequest<TableSessionTable>(entityName: "TableSessionTable")
//        request.predicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
//        let sortDescriptor = NSSortDescriptor(key: "openTime", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        request.returnsObjectsAsFaults = false
//
//        guard let sessions = try? viewContext.fetch(request) else { return ([],[],[]) }
        
        var dates: [Date] = []
        var durations: [Double] = []
        var amounts: [Double] = []
        
//        for session in sessions {
//            dates.append(session.openTime! as Date)
//            durations.append(session.sessionDurationInSeconds)
//            amounts.append(Double(session.totalAmount))
//        }
        
        return (dates, durations, amounts)
    }
}
