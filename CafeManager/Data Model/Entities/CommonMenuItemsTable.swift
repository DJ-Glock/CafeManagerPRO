//
//  CommonMenuItemsTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData

class CommonMenuItemsTable: NSManagedObject {
    static let commonMenuItemsTableRequest: NSFetchRequest<CommonMenuItemsTable> = CommonMenuItemsTable.fetchRequest()

    class func getCommonMenuItemsTable () -> [CommonMenuItemsTable] {
        commonMenuItemsTableRequest.predicate = nil
        if let result = try? viewContext.fetch(commonMenuItemsTableRequest) {
            return result
        } else {
            return []
        }
    }
    
    class func deleteAllRecords() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CommonMenuItemsTable")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        //This code does not work with Seam3
//        do {
//            try viewContext.execute(deleteRequest)
//            try viewContext.save()
//        } catch {
//            print ("There was an error while cleaning CommonMenuItemsTable \(error)")
//        }
        
        // This works with Seam3
        let matchedRecords = try? viewContext.fetch(deleteFetch)
        guard matchedRecords != nil else {return}
        for record in matchedRecords! {
            viewContext.delete(record as! NSManagedObject)
        }
        try? viewContext.save()
    }
    
    class func fillCommonMenuItemsTable (items: [(itemCategory: String, itemName: String, itemDescription: String, itemLanguage: String)]) throws {
        for item in items {
            if #available(iOS 10.0, *) {
                let newRecord = CommonMenuItemsTable(context: viewContext)
                newRecord.itemCategory = item.itemCategory
                newRecord.itemName = item.itemName
                newRecord.itemDescription = item.itemDescription
                newRecord.itemLanguage = item.itemLanguage
                viewContext.insert(newRecord)
                try? viewContext.save()
            } else {
                let newRecord = CommonMenuItemsTable(entity: NSEntityDescription.entity(forEntityName: "CommonMenuItemsTable", in: viewContext)!, insertInto: viewContext)
                newRecord.itemCategory = item.itemCategory
                newRecord.itemName = item.itemName
                newRecord.itemDescription = item.itemDescription
                newRecord.itemLanguage = item.itemLanguage
                viewContext.insert(newRecord)
                try? viewContext.save()
            }
        }
    }

}

extension CommonMenuItemsTable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommonMenuItemsTable> {
        return NSFetchRequest<CommonMenuItemsTable>(entityName: "CommonMenuItemsTable")
    }
    @NSManaged public var itemLanguage: String?
    @NSManaged public var itemCategory: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemDescription: String?
}
