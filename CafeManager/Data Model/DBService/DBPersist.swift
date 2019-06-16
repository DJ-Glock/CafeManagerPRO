//
//  DBPersist.swift
//  CafeManager
//
//  Created by Denis Kurashko on 16/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation
import Firebase

class DBPersist {
    class func createTableInDatabase (newTable table: Table, completion: @escaping (Error?)-> Void) {
        var tableData = [String:Any]()
        tableData["name"] = table.name
        tableData["capacity"] = table.capacity
        
        userData.collection("Tables").addDocument(data: tableData) { (error) in
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
