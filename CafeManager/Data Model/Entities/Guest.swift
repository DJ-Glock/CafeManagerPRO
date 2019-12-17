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
    
    public var sessionDurationMinutes: Double {
        let closeOrCurrentTime = self.closeTime ?? Date()
        let period = closeOrCurrentTime.timeIntervalSince(self.openTime as Date)/60
        return period
    }
    
    public var currentAmount: Float {
        var totalAmount: Float = 0.0
        
        if UserSettings.shared.isTimeCafe {
            let amountForTime = roundf(Float(self.sessionDurationMinutes) * UserSettings.shared.pricePerMinute)
            totalAmount += amountForTime
        }
        
        let orders = self.orders
        for order in orders {
            let price = order.price
            let quantity = order.quantity
            let amount = price * Float(quantity)
            totalAmount += amount
        }
        return totalAmount
    }
    
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
    
    // MARK: Methods
    func renameTo (newName name: String) {
        self.name = name
        DBGeneral.updateActiveSession(tableSession: self.tableSession!)
    }
    
    func changeTime (openTime: Date, closeTime: Date) {
        self.openTime = openTime
        self.closeTime = closeTime
        DBGeneral.updateActiveSession(tableSession: self.tableSession!)
    }
    
    func close () {
        self.closeTime = Date()
        DBGeneral.updateActiveSession(tableSession: self.tableSession!)
    }
    
    // MARK: TODO: TO BE CHECKED
    func move (to targetSesion: TableSession) {
        let sourceSession = self.tableSession!
        self.remove()
        DBGeneral.updateActiveSession(tableSession: sourceSession)
        
        targetSesion.guests.append(self)
        self.tableSession = targetSesion
        DBGeneral.updateActiveSession(tableSession: targetSesion)
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
        DBGeneral.updateActiveSession(tableSession: session)
    }
}
