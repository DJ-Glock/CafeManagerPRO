//
//  GuestsTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing GuestsTable in CoreData.
import Foundation

class Guest {
    
    public var name: String
    public var openTime: Date
    public weak var tableSession: TableSession?
    public var closeTime: Date?
    public var amount: Float = 0.0
    public var orders: [Order] = []
    
    init (name: String, openTime: Date, tableSession: TableSession) {
        self.name = name
        self.openTime = openTime
        self.tableSession = tableSession
    }
    
    convenience init(name: String,
                     openTime: Date,
                     tableSession: TableSession,
                     closeTime: Date?,
                     totalAmount: Float) {
        self.init(name: name, openTime: openTime, tableSession: tableSession)
        self.closeTime = closeTime
        self.amount = totalAmount
    }
    
    // Supporting properties
    public var guestSessionDurationInSeconds: Double {
        let currentCloseTime = closeTime ?? Date()
        let period = currentCloseTime.timeIntervalSince1970 - openTime.timeIntervalSince1970
        return period
    }
    
    
    // MARK: methods
    class func calculateCurrentAmount(forGuest guest: Guest) -> Float {
        var totalAmount: Float = 0.0
        
        if UserSettings.isTimeCafe {
            let closeOrCurrentTime = guest.closeTime ?? Date()
            let amountForTime = roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime as Date))/60) * UserSettings.pricePerMinute
            totalAmount += amountForTime
        }
        
        let orders = guest.orders
        for order in orders {
            let price = order.price
            let quantity = order.quantity
            let amount = price * Float(quantity)
            totalAmount += amount
        }
        return totalAmount
    }
    
    
    func renameTo (newName name: String) {
        self.name = name
        //try? viewContext.save()
    }
    
    func changeTime (openTime: Date, closeTime: Date) {
        self.openTime = openTime
        self.closeTime = closeTime
        //try? viewContext.save()
    }
    
    func close () {
        self.closeTime = Date()
        //try? viewContext.save()
    }
    
    func moveGuest (to targetTableSesion: TableSession) {
        self.tableSession = targetTableSesion
        //try? viewContext.save()
    }
    
    func removeFromTable () {
        let orders = GuestOrder.getOrders(for: self)
        for order in orders {
            order.remove()
        }
        
        //viewContext.delete(self)
        //try? viewContext.save()
    }
    
    // MARK: Class functions
    
    class func addNewGuestHistorical (tableSession: TableSession, openTime: Date, closeTime: Date) {
//        let allGuests = self.getAllGuestsForTableSorted(tableSession: tableSession)
//        let name = NSLocalizedString("guestNameForInsert", comment: "") + " \((allGuests.count) + 1)"
//        if #available(iOS 10.0, *) {
//            let newGuest = GuestsTable(context: viewContext)
//            newGuest.guestName = name
//            newGuest.openTime = openTime
//            newGuest.closeTime = closeTime
//            tableSession.addToGuest(newGuest)
//        } else {
//            let newGuest = GuestsTable(entity: NSEntityDescription.entity(forEntityName: "GuestsTable", in: viewContext)!, insertInto: viewContext)
//            newGuest.guestName = name
//            newGuest.openTime = openTime
//            newGuest.closeTime = closeTime
//            tableSession.addToGuest(newGuest)
//        }
        //try? viewContext.save()
    }
    
    class func addNewCustomGuest (guestName: String, tableSession: TableSession) {
//        if #available(iOS 10.0, *) {
//            let newGuest = GuestsTable(context: viewContext)
//            newGuest.guestName = guestName
//            newGuest.openTime = Date() as NSDate
//            newGuest.closeTime = nil
//            tableSession.addToGuest(newGuest)
//        } else {
//            let newGuest = GuestsTable(entity: NSEntityDescription.entity(forEntityName: "GuestsTable", in: viewContext)!, insertInto: viewContext)
//            newGuest.guestName = guestName
//            newGuest.openTime = Date() as NSDate
//            newGuest.closeTime = nil
//            tableSession.addToGuest(newGuest)
//        }
        //try? viewContext.save()
    }
    
    class func addNewCustomGuestHistorical (guestName: String, tableSession: TableSession, openTime: Date, closeTime: Date) {
//        if #available(iOS 10.0, *) {
//            let newGuest = GuestsTable(context: viewContext)
//            newGuest.guestName = guestName
//            newGuest.openTime = openTime
//            newGuest.closeTime = closeTime
//            tableSession.addToGuest(newGuest)
//        } else {
//            let newGuest = GuestsTable(entity: NSEntityDescription.entity(forEntityName: "GuestsTable", in: viewContext)!, insertInto: viewContext)
//            newGuest.guestName = guestName
//            newGuest.openTime = openTime
//            newGuest.closeTime = closeTime
//            tableSession.addToGuest(newGuest)
//        }
        //try? viewContext.save()
    }
    
    class func closeAllGuestsForTable (tableSession: TableSession) {
//        let guests = GuestsTable.getActiveGuestsFor(tableSession: tableSession)
//        let closeTime = Date()
//        for guest in guests {
//            guest.closeTime = closeTime as NSDate
//        }
        //try? viewContext.save()
    }
    
    class func getActiveGuestsFor (tableSession: TableSession) -> [Guest] {
        //let tablePredicate = appDelegate.smStore?.predicate(for: "table", referencing: tableSession) ?? NSPredicate()
//        let timePredicate = NSPredicate(format: "closeTime = %@", NSNull() as CVarArg)
//        let request: NSFetchRequest<GuestsTable> = GuestsTable.fetchRequest()
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [tablePredicate, timePredicate])
//
//        if let matchedGuests = try? viewContext.fetch(request) {
//            return matchedGuests
//        }
//
        return []
    }
    
    class func getAllGuestsFor (tableSession: TableSession) -> [Guest] {
        //let tablePredicate = appDelegate.smStore?.predicate(for: "table", referencing: tableSession) ?? NSPredicate()
//        let request: NSFetchRequest<GuestsTable> = GuestsTable.fetchRequest()
//        request.predicate = tablePredicate
//
//        if let matchedGuests = try? viewContext.fetch(request) {
//            return matchedGuests
//        }
        
        return []
    }
    
    class func getAllGuestsForTableSorted (tableSession: TableSession) -> [Guest] {
//        var guests = GuestsTable.getAllGuestsFor(tableSession: tableSession)
//        guests = guests.sorted(by: { $0.openTime?.compare($1.openTime! as Date) == ComparisonResult.orderedDescending })
//        return guests
        return []
    }
    
    
    class func getPopularGuestNames () -> [String] {
//        var popularGuestNames: [String] = []
//        let keypathExp = NSExpression(forKeyPath: "guestName")
//        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
//
//        let countDesc = NSExpressionDescription()
//        countDesc.expression = expression
//        countDesc.name = "count"
//        countDesc.expressionResultType = .integer64AttributeType
//        let startDate = Date() - 60*60*24*30
//
//        let request = NSFetchRequest<NSDictionary>(entityName: "GuestsTable")
//        request.predicate = NSPredicate(format: "NOT guestName CONTAINS[cd] %@ and NOT guestName CONTAINS[cd] %@ and openTime >= %@", "Гость", "Guest", startDate as CVarArg)
//        request.returnsObjectsAsFaults = false
//        request.propertiesToGroupBy = ["guestName"]
//        request.propertiesToFetch = ["guestName", countDesc]
//        request.resultType = .dictionaryResultType
//        var matchedGuests = [[String:Any]]()
//        if let result = try? viewContext.fetch(request) as! [[String:Any]] {
//            matchedGuests = result
//        }
//        var sortedGuests = [[String:Any]]()
//        sortedGuests = matchedGuests.sorted(by: {$0["count"] as! Int > $1["count"] as! Int})
//        guard sortedGuests.count != 0 else {return popularGuestNames}
//        var limit = 15
//        if sortedGuests.count <= limit {
//            limit = sortedGuests.count - 1
//        }
//        for index in 0...limit {
//            popularGuestNames.append(sortedGuests[index]["guestName"] as! String)
//        }
//        return popularGuestNames
        return []
    }
    
    //MARK: functions for stats
    // Old functions - to be decommed
    class func getStatsForGuests (startDate: Date, endDate: Date) -> (averageTimeSeconds: Int, totalCount: Int, averageGuestsPerTable: Int) {
        var totalTime: Int = 0
        var averageTime: Int = 0
        var totalCount: Int = 0
        var averageGuestsPerTable: Int = 0
        
//        guestTableRequest.predicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
//        tableSessionRequest.predicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
//        let matchedGuests = try? viewContext.fetch(guestTableRequest)
//        let matchedSessions = try? viewContext.fetch(tableSessionRequest)
//
//        guard matchedGuests != nil && matchedSessions != nil else {return (averageTime, totalCount, averageGuestsPerTable)}
//        totalCount = matchedGuests!.count
//        let sessionsCount = matchedSessions!.count
//
//        guard totalCount > 0 && sessionsCount > 0 else {return (averageTime, totalCount, averageGuestsPerTable)}
//
//        for guest in matchedGuests! {
//            totalTime += Int((guest.closeTime?.timeIntervalSince(guest.openTime! as Date))!)
//        }
//        averageTime = totalTime/totalCount
//        averageGuestsPerTable = Int(roundf(Float(totalCount)/Float(sessionsCount)))
        
        return (averageTime, totalCount, averageGuestsPerTable)
    }
    
    // New function
    class func getGuestSessionsTimings (from startDate: Date, to endDate: Date) -> (dates: [Date], durationsInSeconds: [Double]) {
//        let request = NSFetchRequest<GuestsTable>(entityName: "GuestsTable")
//        request.predicate = NSPredicate(format: "openTime >= %@ and openTime <= %@ and closeTime <> %@", startDate as CVarArg, endDate as CVarArg, NSNull() as CVarArg)
//        let sortDescriptor = NSSortDescriptor(key: "openTime", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        request.returnsObjectsAsFaults = false
//
//        guard let guestSessions = try? viewContext.fetch(request) else { return ([], []) }
        
        var dates: [Date] = []
        var durations: [Double] = []
        
//        for guestSession in guestSessions {
//            dates.append(guestSession.openTime! as Date)
//            durations.append(guestSession.guestSessionDurationInSeconds)
//        }
        
        return (dates, durations)
    }
}
