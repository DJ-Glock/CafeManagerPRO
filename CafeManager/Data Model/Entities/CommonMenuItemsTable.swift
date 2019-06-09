//
//  CommonMenuItemsTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

class CommonMenuItemsTable {
    
    public var itemLanguage: String?
    public var itemCategory: String?
    public var itemName: String?
    public var itemDescription: String?

    class func getCommonMenuItemsTable () -> [CommonMenuItemsTable] {
        //commonMenuItemsTableRequest.predicate = nil
//        if let result = try? viewContext.fetch(commonMenuItemsTableRequest) {
//            return result
//        } else {
//            return []
//        }
        return []
    }
    
    class func deleteAllRecords() {
        //let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CommonMenuItemsTable")
        
        // This works with Seam3
//        let matchedRecords = try? viewContext.fetch(deleteFetch)
//        guard matchedRecords != nil else {return}
//        for record in matchedRecords! {
//            viewContext.delete(record as! NSManagedObject)
//        }
//        try? viewContext.save()
    }

}
