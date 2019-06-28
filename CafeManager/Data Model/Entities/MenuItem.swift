//
//  MenuTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing MenuTable in CoreData.

import Foundation

class MenuItem {
    public var itemName: String
    public var itemDescription: String?
    public var itemPrice: Float = 0.0
    public weak var category: MenuCategory?
    
    init (itemName: String, itemDescription: String?, itemPrice: Float) {
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemPrice = itemPrice
    }
    
    convenience init (itemName: String, itemDescription: String?, itemPrice: Float, category: MenuCategory?) {
        self.init(itemName: itemName, itemDescription: itemDescription, itemPrice: itemPrice)
    }
    
    
    // MARK: methods
    func changeMenuItemTo (newMenuItem: MenuStruct) {
    }
    
    func hideMenuItem () {
    }
    
    func showMenuItem () {
    }
    
    func remove () {
    }
    
    // MARK: Class functions
    class func getOrdersFor (menuItem: MenuItem) -> [Order] {
        return []
    }
    
    class func getGuestOrdersFor (menuItem: MenuItem) -> [GuestOrder] {
        return []
    }

    
    class func addMenuItem (item: MenuStruct) {
    }
    
    class func getActiveMenuItem (withName name: String) -> MenuItem? {
        return nil
    }

    class func getActiveMenuItems () -> [MenuItem] {
        return []
    }
    
    class func getActiveMenuItems (withNameContains text: String) -> [MenuItem] {
        return []
    }
    
    class func bulkAddMenuItems (items: [MenuStruct]) throws {
    }
    
    // New function for ordered items statistics
    class func getDetailedOrdersStatistics (from startDate: Date, to endDate: Date) -> [String:[Date]] {
        var result: [String:[Date]] = [:]
        return result
    }
    
}
