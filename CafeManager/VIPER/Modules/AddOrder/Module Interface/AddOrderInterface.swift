//
//  AddOrderInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol AddOrderInterface: class {
    /// Delegate should be set to onwer. Owner should conform to protocol AddOrderDelegate
    var delegate: AddOrderDelegate! {get set}
    
    /// Method shows Menu view that allows user to select desired menu item. When user selects menu item, module will return selected menu item entity and guest entity for further addition of order.
    func showMenuItemsToAddOrder(forGuest: Guest, sender: AnyObject)
    
    /// Method shows Menu view that allows user to select desired menu item. When user selects menu item, module will return selected menu item entity and session entity for further addition of order.
    func showMenuItemsToAddOrder(forSession: TableSession, sender: AnyObject)
}
