//
//  OrderInTbleTableViewCell.swift
//  CafeManager
//
//  Created by Denis Kurashko on 27.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit

class OrderInTableTableViewCell: UITableViewCell {
    weak var cellDelegate: OrderInTableTableViewCellDelegate?
    var order: OrdersTable? = nil
    var menuItem: MenuTable? = nil
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemsPrice: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    @IBAction func didPressOrderCellButton(_ sender: UIButton) {
        cellDelegate?.didPressIncreaseOrDecreaseOrderQuantityButton(order: order!, menuItem: menuItem!, action: sender.accessibilityIdentifier!)
    }
}
