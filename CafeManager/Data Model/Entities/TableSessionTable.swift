//
//  TableSessionTble.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing TableSessionsTable in CoreData.

import UIKit
import CoreData

class TableSessionTable: NSManagedObject {
    // MARK: variables
    static let tableSessionRequest: NSFetchRequest<TableSessionTable> = TableSessionTable.fetchRequest()
    
    // MARK: functions for managing sessions
    class func createTableSession (table: TablesTable) -> TableSessionTable {
        if #available(iOS 10.0, *) {
            let newTableSession = TableSessionTable(context: viewContext)
            newTableSession.openTime = Date() as NSDate
            newTableSession.closeTime = nil
            table.addToTableSession(newTableSession)
            try? viewContext.save()
            return newTableSession
        } else {
            let newTableSession = TableSessionTable(entity: NSEntityDescription.entity(forEntityName: "TableSessionTable", in: viewContext)!, insertInto: viewContext)
            newTableSession.openTime = Date() as NSDate
            newTableSession.closeTime = nil
            table.addToTableSession(newTableSession)
            try? viewContext.save()
            return newTableSession
        }
    }
    
    class func saveRecalculated (tableSession: TableSessionTable, totalAmount: Float, discount: Int16, tips: Float) throws {
        tableSession.totalAmount = totalAmount
        tableSession.discount = discount
        tableSession.totalTips = tips
        do {
            try viewContext.save()
        } catch {
            throw (iCafeManagerError.CoreDataException("Error during saveAmountAndDiscount \(error)"))
        }
    }
    
    class func checkout (tableSession: TableSessionTable, totalAmount: Float, discount: Int16, tips: Float) throws {
        GuestsTable.closeAllGuestsForTable(tableSession: tableSession)
        tableSession.totalAmount = totalAmount
        tableSession.discount = discount
        tableSession.totalTips = tips
        tableSession.closeTime = Date() as NSDate
        do {
            try viewContext.save()
        } catch {
            throw (iCafeManagerError.CoreDataException("Error during closeTableSession \(error)"))
        }
    }
    
    class func getCurrentTableSession (table: TablesTable) -> TableSessionTable? {
        let tablePredicate = appDelegate.smStore?.predicate(for: "table", referencing: table) ?? NSPredicate()
        let timePredicate = NSPredicate(format: "closeTime = %@", NSNull() as CVarArg)
        let request: NSFetchRequest<TableSessionTable> = TableSessionTable.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [tablePredicate, timePredicate])
        
        let matchedSessions = try? viewContext.fetch(request)
        
        if matchedSessions?.count != 0 {
            var sessions = [TableSessionTable]()
            for session in matchedSessions! {
                sessions.append(session)
            }
            if sessions.count == 1 {
                return sessions.first
            } else if (sessions.count) > 1 {
                print("CRITICAL ERROR: More than one opened session for table found! Returning the oldest one.")
                sessions = sessions.sorted(by: { $0.openTime?.compare($1.openTime! as Date) == ComparisonResult.orderedAscending })
                return sessions.first
            }
        }
        return nil
    }
    
    class func moveTableSessionTo (targetTable: TablesTable, currentSession: TableSessionTable) {
        currentSession.table = targetTable
        try? viewContext.save()
    }
    
    private static func removeSession(_ session: TableSessionTable) {
        let guests = GuestsTable.getAllGuestsFor(tableSession: session)
        
        for guest in guests {
            let guestOrders = GuestOrdersTable.getOrders(for: guest)
            for order in guestOrders {
                viewContext.delete(order)
            }
            viewContext.delete(guest)
        }
        
        let orders = OrdersTable.getOrdersFor(tableSession: session)
        for order in orders {
            viewContext.delete(order)
        }
        
        viewContext.delete(session)
        try? viewContext.save()
    }
    
    class func removeTableSessionsForTable (table: TablesTable) {
        let predicate = appDelegate.smStore?.predicate(for: "table", referencing: table)
        tableSessionRequest.predicate = predicate
        if let matchedTableSessions = try? viewContext.fetch(tableSessionRequest) {
            for session in matchedTableSessions {
                removeSession(session)
            }
        }
    }
    
    // MARK: functions for amounts calculation
    class func calculateAmountForTime(tableSession: TableSessionTable) -> Float {
        var amount: Float = 0
        guard UserSettings.isTimeCafe == true else {return amount}
        
        let guestsTable = GuestsTable.getAllGuestsForTableSorted(tableSession: tableSession)
        for guest in guestsTable {
            let closeOrCurrentTime = guest.closeTime ?? Date() as NSDate
            amount = amount + roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime! as Date))/60) * UserSettings.pricePerMinute
        }
        return amount
    }
    
    class func calculateIndividualAmount (guest: GuestsTable) -> Float {
        var amount: Float = 0
        var ordersAmount: Float = 0
        var amountForTime: Float = 0
        
        if UserSettings.isTimeCafe {
            let closeOrCurrentTime = guest.closeTime ?? Date() as NSDate
            amountForTime = roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime! as Date))/60) * UserSettings.pricePerMinute
        }
        
        let orders = GuestOrdersTable.getOrders(for: guest)
        if orders.count > 0 {
            for order in orders {
                var currentAmount: Float = 0
                let currentOrderQuantity = order.quantityOfItems
                if let currentOrderPrice = order.menuItem?.itemPrice {
                    currentAmount = currentOrderPrice * Float(currentOrderQuantity)
                }
                ordersAmount += currentAmount
            }
        }
        amount = amountForTime + ordersAmount
        
        return amount
    }
    
    class func calculateActualTotalAmount (for currentTableSession: TableSessionTable?) -> Float {
        guard currentTableSession != nil else {return 0}
        
        var totalAmount: Float = 0
        var ordersAmount: Float = 0
        var guestsAmount: Float = 0
        
        let currentOrders = OrdersTable.getOrdersFor(tableSession: currentTableSession!)
        for order in currentOrders {
            ordersAmount += Float(order.quantityOfItems) * (order.menuItem?.itemPrice)!
        }
        
        let guests = GuestsTable.getActiveGuestsFor(tableSession: currentTableSession!)
        for guest in guests {
            guestsAmount += TableSessionTable.calculateIndividualAmount(guest: guest)
        }
        
        totalAmount = ordersAmount + guestsAmount
        
        return totalAmount
    }
    
    class func calculateTotalAmount (currentTableSession: TableSessionTable?) -> Float {
        guard currentTableSession != nil else {return 0}
        
        var totalAmount: Float = 0
        var ordersAmount: Float = 0
        var guestsAmount: Float = 0
        
        let currentOrders = OrdersTable.getOrdersFor(tableSession: currentTableSession!)
        for order in currentOrders {
            ordersAmount += Float(order.quantityOfItems) * (order.menuItem?.itemPrice)!
        }
        
        let guests = GuestsTable.getAllGuestsFor(tableSession: currentTableSession!)
        for guest in guests {
            guestsAmount += TableSessionTable.calculateIndividualAmount(guest: guest)
        }
        
        totalAmount = ordersAmount + guestsAmount
        
        return totalAmount
    }
    
    // MARK: Functions for resolving post-sync conflicts
    /// Function should be called after sync completion. It will find and remove ambiguous open table sessions.
    /// The oldest session will be left, others will be removed.
    class func removeAmbiguousOpenSessions() {
        let tables = TablesTable.getAllTables()
        guard tables != nil else {return}
        
        for table in tables! {
            let tablePredicate = appDelegate.smStore?.predicate(for: "table", referencing: table) ?? NSPredicate()
            let timePredicate = NSPredicate(format: "closeTime = %@", NSNull() as CVarArg)
            let request: NSFetchRequest<TableSessionTable> = TableSessionTable.fetchRequest()
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [tablePredicate, timePredicate])
            
            let matchedSessions = try? viewContext.fetch(request)
            guard matchedSessions != nil else {return}
            
            if matchedSessions!.count > 1 {
                print("Ambiguous open sessions found")
                var sessions = [TableSessionTable]()
                for session in matchedSessions! {
                    sessions.append(session)
                }
                
                sessions = sessions.sorted(by: { $0.openTime?.compare($1.openTime! as Date) == ComparisonResult.orderedAscending })
                sessions.removeFirst()
                
                for session in sessions {
                    self.removeSession(session)
                    do {
                        try viewContext.save()
                        print("Ambiguous opened sessions removed")
                    } catch {
                        NSLog("Unable to save context after removing ambiguous open sessions \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: functions for statistics
    // Old function - to be decommed
    class func getTableSessionsStatistics (startDate: Date, endDate: Date) -> (averageAmount: Float, profit: Float, sessionsCount: Int, minimumAmount: Float, maximumAmount: Float, averageTimeSeconds: Int) {
        var averageAmount: Float = 0
        var totalAmount: Float = 0
        var minimumAmount: Float = 0
        var maximumAmount: Float = 0
        var arrayOfAmounts: [Float] = []
        var averageTime: Int = 0
        var totalTime: Int = 0
        var sessionsCount: Int = 0
        
        tableSessionRequest.predicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
        let matchedSessions = try? viewContext.fetch(tableSessionRequest)
        guard (matchedSessions?.count)! > 0 else {return (averageAmount, totalAmount, sessionsCount, minimumAmount, maximumAmount, averageTime)}
        
        for session in matchedSessions! {
            var currentAmount: Float = 0
            totalTime += Int((session.closeTime?.timeIntervalSince(session.openTime! as Date))!)
            
            // If totalAmount is set for session, get it
            // If not - calculate it using orders and guests time
            if session.totalAmount != -1 {
                currentAmount += session.totalAmount
                totalAmount += session.totalAmount
            } else {
                let calculatedAmount = calculateTotalAmount(currentTableSession: session)
                currentAmount += calculatedAmount
                totalAmount += calculatedAmount
            }
            
            //Array to calculate maximum and minimum amount
            if arrayOfAmounts.count > 0 {
                //Nice try to reduce size of the array
                if arrayOfAmounts.max()! < currentAmount {
                    arrayOfAmounts.append(currentAmount)
                }
                if arrayOfAmounts.min()! > currentAmount {
                    arrayOfAmounts.append(currentAmount)
                }
            } else {
                arrayOfAmounts.append(currentAmount)
            }
        }
        sessionsCount = matchedSessions!.count
        averageAmount = totalAmount/Float(sessionsCount)
        averageAmount = roundf(averageAmount)
        minimumAmount = arrayOfAmounts.min()!
        maximumAmount = arrayOfAmounts.max()!
        averageTime = totalTime/sessionsCount
        let result = (averageAmount, totalAmount, sessionsCount, minimumAmount, maximumAmount, averageTime)
        return result
    }
    
    // New function
    class func getTableSessionsTimingsAndAmounts (from startDate: Date, to endDate: Date) -> (dates: [Date], durationsInSeconds: [Double], amounts: [Double]) {
        let request = NSFetchRequest<TableSessionTable>(entityName: "TableSessionTable")
        request.predicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: "openTime", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.returnsObjectsAsFaults = false
        
        guard let sessions = try? viewContext.fetch(request) else { return ([],[],[]) }
        
        var dates: [Date] = []
        var durations: [Double] = []
        var amounts: [Double] = []
        
        for session in sessions {
            dates.append(session.openTime! as Date)
            durations.append(session.sessionDurationInSeconds)
            amounts.append(Double(session.totalAmount))
        }
        
        return (dates, durations, amounts)
    }
}

extension TableSessionTable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TableSessionTable> {
        return NSFetchRequest<TableSessionTable>(entityName: "TableSessionTable")
    }
    
    @NSManaged public var closeTime: NSDate?
    @NSManaged public var openTime: NSDate?
    @NSManaged public var totalAmount: Float
    @NSManaged public var totalTips: Float
    @NSManaged public var discount: Int16
    @NSManaged public var guest: NSSet?
    @NSManaged public var orderedItems: NSSet?
    @NSManaged public var table: TablesTable?
    
    // Supporting properties
    @objc var openTimeTruncatedToDay: String {
        return openTime!.getTimeStrWithDayPrecision()
    }
    @objc var openTimeTruncatedToMonth: String {
        return openTime!.getTimeStrWithMonthPrecision()
    }
    
    @objc var sessionDurationInSeconds: Double {
        let currentCloseTime = closeTime ?? NSDate()
        let period = currentCloseTime.timeIntervalSince1970 - openTime!.timeIntervalSince1970
        return period
    }
}


// MARK: Generated accessors for orderedItems
extension TableSessionTable {
    @objc(addOrderedItemsObject:)
    @NSManaged public func addToOrderedItems(_ value: OrdersTable)
    
    @objc(removeOrderedItemsObject:)
    @NSManaged public func removeFromOrderedItems(_ value: OrdersTable)
    
    @objc(addOrderedItems:)
    @NSManaged public func addToOrderedItems(_ values: NSSet)
    
    @objc(removeOrderedItems:)
    @NSManaged public func removeFromOrderedItems(_ values: NSSet)
}

// MARK: Generated accessors for guest
extension TableSessionTable {
    @objc(addGuestObject:)
    @NSManaged public func addToGuest(_ value: GuestsTable)
    
    @objc(removeGuestObject:)
    @NSManaged public func removeFromGuest(_ value: GuestsTable)
    
    @objc(addGuest:)
    @NSManaged public func addToGuest(_ values: NSSet)
    
    @objc(removeGuest:)
    @NSManaged public func removeFromGuest(_ values: NSSet)
}
