//
//  AddOrderRouterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol AddOrderRouterInterface {
    /// Method shows Menu view for adding order for guest
    func showMenuItemsToAddOrder(forGuest guest: GuestsTable, sender: AnyObject)
    
    /// Method shows Menu view for adding order for session
    func showMenuItemsToAddOrder(forSession session: TableSessionTable, sender: AnyObject)
    
    // Method is getting called when item is chosen. It calls respective delegate method
    func didChooseMenuItem()
}
