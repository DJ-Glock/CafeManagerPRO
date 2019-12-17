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
    
    public var guestSessionDurationInSeconds: Double {
        let currentCloseTime = closeTime ?? Date()
        let period = currentCloseTime.timeIntervalSince1970 - openTime.timeIntervalSince1970
        return period
    }
    
    
    // MARK: Methods
    class func calculateCurrentAmount(forGuest guest: Guest) -> Float {
        var totalAmount: Float = 0.0
        
        if UserSettings.shared.isTimeCafe {
            let closeOrCurrentTime = guest.closeTime ?? Date()
            let amountForTime = roundf(Float(closeOrCurrentTime.timeIntervalSince(guest.openTime as Date))/60) * UserSettings.shared.pricePerMinute
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
        DBGeneral.updateActiveSessionsOrders(tableSession: self.tableSession!)
    }
    
    func changeTime (openTime: Date, closeTime: Date) {
        self.openTime = openTime
        self.closeTime = closeTime
        DBGeneral.updateActiveSessionsOrders(tableSession: self.tableSession!)
    }
    
    func close () {
        self.closeTime = Date()
        DBGeneral.updateActiveSessionsOrders(tableSession: self.tableSession!)
    }
    
    // MARK: TODO: TO BE CHECKED
    func move (to targetSesion: TableSession) {
        let sourceSession = self.tableSession!
        self.remove()
        DBGeneral.updateActiveSessionsOrders(tableSession: sourceSession)
        
        targetSesion.guests.append(self)
        self.tableSession = targetSesion
        DBGeneral.updateActiveSessionsOrders(tableSession: targetSesion)
    }
    
    func remove () {
        let session = self.tableSession!
        let count = session.guests.count
        for i in 0..<count {
            let guest = session.guests[i]
            if guest === self {
                session.guests.remove(at: i)
                break
            }
        }
        DBGeneral.updateActiveSessionsOrders(tableSession: session)
    }
}
