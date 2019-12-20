//
//  Menu.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation

class Global {
    var menuItems: [String:[MenuItem]] = [:]
    var tables: [Table] = []
    
    static let shared = Global()
    
    private init (){}
}
