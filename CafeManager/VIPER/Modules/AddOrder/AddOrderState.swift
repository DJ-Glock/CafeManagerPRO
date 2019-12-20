//
//  AddOrderState.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class AddOrderState: NSObject {
    var currentGuest: Guest!
    var currentSession: TableSession!
    var selectedMenuItem: MenuItem!
    var categories: [String] {
        return menuItems.keys.sorted()
    }
    var menuItems: [String:[MenuItem]] = [:]
}
