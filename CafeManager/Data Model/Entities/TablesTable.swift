//
//  TablesTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//
// This class contains functions for managing TableTable in CoreData.

import UIKit
import CoreData

class TablesTable: NSManagedObject {
    static let tablesTableRequest : NSFetchRequest<TablesTable> = TablesTable.fetchRequest()
    
    // MARK: methods
    func changeTable (to changedTable: Table) {
        self.tableName = changedTable.tableName
        self.tableCapacity = Int16(changedTable.tableCapacity)
        try? viewContext.save()
    }
    
    func remove () {
        TableSessionTable.removeTableSessionsForTable(table: self)
        viewContext.delete(self)
        try? viewContext.save()
    }
    
    // MARK: class functions
    class func getOrCreateTable (table: Table) throws -> TablesTable {
        tablesTableRequest.predicate = NSPredicate(format: "tableName = %@", table.tableName)
        do {
            let matchedTableName = try viewContext.fetch(tablesTableRequest)
            tablesTableRequest.predicate = nil
            if matchedTableName.count > 0 {
                return matchedTableName[0]
            }
        }
        catch {
            throw error
        }
        if #available(iOS 10.0, *) {
            let newTable = TablesTable(context: viewContext)
            newTable.tableName = table.tableName
            newTable.tableCapacity = Int16(table.tableCapacity)
            try? viewContext.save()
            return newTable
        } else {
            let newTable = TablesTable(entity: NSEntityDescription.entity(forEntityName: "TablesTable", in: viewContext)!, insertInto: viewContext)
            newTable.tableName = table.tableName
            newTable.tableCapacity = Int16(table.tableCapacity)
            try? viewContext.save()
            return newTable
        }
    }
    
    class func getTable (withName name: String) -> TablesTable? {
        tablesTableRequest.predicate = NSPredicate(format: "tableName = %@", name)
        do {
            let matchedTableName = try viewContext.fetch(tablesTableRequest)
            tablesTableRequest.predicate = nil
            if matchedTableName.count > 0 {
                return matchedTableName[0]
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    class func getAllTables () -> [TablesTable]? {
        tablesTableRequest.predicate = nil
        tablesTableRequest.sortDescriptors = [NSSortDescriptor(key: "tableName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        let table = try? viewContext.fetch(tablesTableRequest)
        return table
    }
}

extension TablesTable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TablesTable> {
        return NSFetchRequest<TablesTable>(entityName: "TablesTable")
    }
    
    @NSManaged public var tableCapacity: Int16
    @NSManaged public var tableDescription: String?
    @NSManaged public var tableName: String?
    @NSManaged public var tableSession: NSSet?
    
}

// MARK: Generated accessors for tableSession
extension TablesTable {
    
    @objc(addTableSessionObject:)
    @NSManaged public func addToTableSession(_ value: TableSessionTable)
    
    @objc(removeTableSessionObject:)
    @NSManaged public func removeFromTableSession(_ value: TableSessionTable)
    
    @objc(addTableSession:)
    @NSManaged public func addToTableSession(_ values: NSSet)
    
    @objc(removeTableSession:)
    @NSManaged public func removeFromTableSession(_ values: NSSet)
}
