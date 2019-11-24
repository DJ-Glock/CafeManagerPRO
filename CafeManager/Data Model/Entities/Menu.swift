//
//  Menu.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Foundation

class Menu {
    var menuItems: [String:[MenuItem]] = [:]
    static let shared = Menu()
    
    private init (){}
}
