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
    public var tableCapacity: Int16
    public var tableDescription: String?
    public var tableName: String
    public var tableSession: TableSessionTable?
    
    init (firebaseID: String?, tableName: String, tableCapacity: Int16, tableDescription: String?) {
        self.firebaseID = firebaseID
        self.tableName = tableName
        self.tableCapacity = tableCapacity
        self.tableDescription = tableDescription
    }
    
    convenience init (firebaseID: String?, tableName: String, tableCapacity: Int16, tableDescription: String?, tableSession: TableSessionTable?) {
        self.init(firebaseID: firebaseID, tableName: tableName, tableCapacity: tableCapacity, tableDescription: tableDescription)
        self.tableSession = tableSession
    }
    
    
    // MARK: methods
    func changeTable (to changedTable: TableStruct) {
//        self.tableName = changedTable.tableName
//        self.tableCapacity = Int16(changedTable.tableCapacity)
//        try? viewContext.save()
    }
    
    func remove () {
//        TableSessionTable.removeTableSessionsForTable(table: self)
//        viewContext.delete(self)
//        try? viewContext.save()
    }
    
    // MARK: class functions
    class func getOrCreateTable (table: TableStruct) throws -> TablesTable? {
//        tablesTableRequest.predicate = NSPredicate(format: "tableName = %@", table.tableName)
//        do {
//            let matchedTableName = try viewContext.fetch(tablesTableRequest)
//            tablesTableRequest.predicate = nil
//            if matchedTableName.count > 0 {
//                return matchedTableName[0]
//            }
//        }
//        catch {
//            throw error
//        }
//        if #available(iOS 10.0, *) {
//            let newTable = TablesTable(context: viewContext)
//            newTable.tableName = table.tableName
//            newTable.tableCapacity = Int16(table.tableCapacity)
//            try? viewContext.save()
//            return newTable
//        } else {
//            let newTable = TablesTable(entity: NSEntityDescription.entity(forEntityName: "TablesTable", in: viewContext)!, insertInto: viewContext)
//            newTable.tableName = table.tableName
//            newTable.tableCapacity = Int16(table.tableCapacity)
//            try? viewContext.save()
//            return newTable
//        }
        return TablesTable(firebaseID: nil, tableName: "Fake", tableCapacity: 1, tableDescription: "Fake")
    }
    
    class func getTable (withName name: String) -> TablesTable? {
//        tablesTableRequest.predicate = NSPredicate(format: "tableName = %@", name)
//        do {
//            let matchedTableName = try viewContext.fetch(tablesTableRequest)
//            tablesTableRequest.predicate = nil
//            if matchedTableName.count > 0 {
//                return matchedTableName[0]
//            }
//        }
//        catch {
//            print(error.localizedDescription)
//        }
        return nil
    }
    
    class func getAllTables () -> [TablesTable]? {
//        tablesTableRequest.predicate = nil
//        tablesTableRequest.sortDescriptors = [NSSortDescriptor(key: "tableName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
//        let table = try? viewContext.fetch(tablesTableRequest)
//        return table
        return []
    }
}
