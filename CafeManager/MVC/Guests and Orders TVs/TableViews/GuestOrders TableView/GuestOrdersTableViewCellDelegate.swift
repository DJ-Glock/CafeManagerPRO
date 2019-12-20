//
//  GuestOrdersTableViewCellDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

//Protocol for tableView to support segues with sending data to new view
protocol GuestOrdersTableViewCellDelegate : class {
    func didPressOrderIncreaseOrDecreaseButton (order: Order, action: String)
}
