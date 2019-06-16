//
//  TablesTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing TableTable in CoreData.

import Foundation

class TablesTable {
    
    public var firebaseID: String?
    public var capacity: Int16
    public var name: String
    public var tableSession: TableSessionTable?
    
    init (firebaseID: String?, tableName: String, tableCapacity: Int16) {
        self.firebaseID = firebaseID
        self.name = tableName
        self.capacity = tableCapacity
    }
    
    convenience init (firebaseID: String?, tableName: String, tableCapacity: Int16, tableDescription: String?, tableSession: TableSessionTable?) {
        self.init(firebaseID: firebaseID, tableName: tableName, tableCapacity: tableCapacity)
        self.tableSession = tableSession
    }
    
    
    // MARK: methods
    func changeTable (to changedTable: TableStruct) {
    }
    
    func remove () {
    }
    
    
    class func getTable (withName name: String) -> TablesTable? {
        return nil
    }
    
    class func getAllTables () -> [TablesTable]? {
        return []
    }
}
