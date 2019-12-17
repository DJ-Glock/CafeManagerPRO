//
//  TableSessionTble.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing TableSessionsTable in CoreData.

import Foundation

class TableSession {
    
    public var firebaseID: String?
    public weak var table: Table?
    public var openTime: Date
    public var closeTime: Date?
    public var guests: [Guest] = []
    public var orders: [Order] = []
    public var amount: Float = 0.0
    public var tips: Float = 0.0
    public var discount: Int16 = 0

    
    init (firebaseID: String?, table: Table, openTime: Date) {
        self.firebaseID = firebaseID
        self.table = table
        self.openTime = openTime
    }
    
    convenience init (firebaseID: String?,
                     table: Table,
                     openTime: Date,
                     closeTime: Date?,
                     guests: [Guest],
                     orders: [Order],
                     amount: Float,
                     tips :Float,
                     discount: Int16) {
        self.init(firebaseID: firebaseID, table: table, openTime: openTime)
        self.closeTime = closeTime
        self.guests = guests
        self.orders = orders
        self.amount = amount
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
    class func createTableSession (table: Table) -> TableSession? {
        return TableSession(firebaseID: nil, table: table, openTime: Date())
    }
    
    class func saveRecalculated (tableSession: TableSession, totalAmount: Float, discount: Int16, tips: Float) throws {
//        tableSession.totalAmount = totalAmount
//        tableSession.discount = discount
//        tableSession.totalTips = tips
//        do {
//            try viewContext.save()
//        } catch {
//            throw (iCafeManagerError.CoreDataException("Error during saveAmountAndDiscount \(error)"))
//        }
    }
    
    class func checkout (tableSession: TableSession, totalAmount: Float, discount: Int16, tips: Float) throws {
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
    
    class func getCurrentTableSession (table: Table) -> TableSession? {
        return nil
    }
    
    class func moveTableSessionTo (targetTable: Table, currentSession: TableSession) {
    }
    
    private static func removeSession(_ session: TableSession) {
    }
    
    class func removeTableSessionsForTable (table: Table) {
    }
    
    // MARK: functions for amount calculation
    class func calculateAmountForTime(tableSession: TableSession) -> Float {
        var amount: Float = 0
        guard UserSettings.shared.isTimeCafe == true else {return amount}
        
//        let guestsTable = Guest.getAllGuestsForTableSorted(tableSession: tableSession)
//        for guest in guestsTable {
//            let closeOrCurrentTime = guest.closeTime ?? Date()
//            amount = amount + roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime as Date))/60) * UserSettings.shared.pricePerMinute
//        }
        return amount
    }
    
    class func calculateActualTotalAmount (for currentTableSession: TableSession?) -> Float {
        guard currentTableSession != nil else {return 0}
        
        var totalAmount: Float = 0
        
        let currentOrders = currentTableSession?.orders ?? []
        for order in currentOrders {
            let price = order.price
            let quantity = order.quantity
            let amount = price * Float(quantity)
            totalAmount += amount
        }
        
        let currentGuests = currentTableSession?.guests ?? []
        for guest in currentGuests {
            let guestAmount = Guest.calculateCurrentAmount(forGuest: guest)
            totalAmount += guestAmount
        }
        
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
