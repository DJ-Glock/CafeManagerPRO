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
    public var name: String
    public var description: String?
    public var price: Float = 0.0
    public var category: String
    
    init (name: String, description: String?, price: Float, category: String) {
        self.name = name
        self.description = description
        self.price = price
        self.category = category
    }
}
