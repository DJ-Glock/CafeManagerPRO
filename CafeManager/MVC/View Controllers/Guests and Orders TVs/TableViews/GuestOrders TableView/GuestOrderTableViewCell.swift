//
//  GuestOrderTableViewCell.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit

class GuestOrderTableViewCell: UITableViewCell {
    weak var cellDelegate: GuestOrdersTableViewCellDelegate?
    var order: Order? = nil
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemsPrice: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    @IBAction func didPressOrderIncreaseOrDecreaseButton(_ sender: UIButton) {
        cellDelegate?.didPressOrderIncreaseOrDecreaseButton(order: order!, action: sender.accessibilityIdentifier!)
    }
}
