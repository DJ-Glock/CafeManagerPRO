//
//  MenuTableViewCell.swift
//  CafeManager
//
//  Created by Denis Kurashko on 09.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    var menuItem: MenuItem? = nil
    
    @IBOutlet weak var menuItemNameLabel: UILabel!
    @IBOutlet weak var menuItemDescriptionLabel: UILabel!
    @IBOutlet weak var menuItemPriceLabel: UILabel!
}
