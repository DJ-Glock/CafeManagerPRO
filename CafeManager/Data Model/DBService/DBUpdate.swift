//
//  DBUpdate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 16/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation
import Firebase

class DBUpdate {
    class func changeTableInDatabase (tableToChange table: Table, completion: @escaping (Error?)-> Void) {
        guard let documentID = table.firebaseID else { completion(iCafeManagerError.DatabaseError("firebaseID is null for table: \(table.name)")); return }
        
        var tableData = [String:Any]()
        tableData["name"] = table.name
        tableData["capacity"] = table.capacity
        
        
        let tableDocument = userData.collection("Tables").document(documentID)
        tableDocument.updateData(tableData) { (error) in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
}
