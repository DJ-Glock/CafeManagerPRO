//
//  AddOrderDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol AddOrderDelegate: class {
    /// Method is getting called when menu item was chosen
    func didChoose(menuItem: MenuTable, forGuest: GuestsTable)
    
    /// Method is getting called when menu item was chosen
    func didChoose(menuItem: MenuTable, forSession: TableSessionTable)
}
