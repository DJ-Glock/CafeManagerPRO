//
//  MenuCategoryTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

class MenuCategory {
    
    public var categoryName: String
    public var menuItems: [MenuItem] = []
    
    init (categoryName: String) {
        self.categoryName = categoryName
    }

}
