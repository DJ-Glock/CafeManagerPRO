//
//  CommonMenuTableViewCell.swift
//  CafeManager
//
//  Created by Denis Kurashko on 21.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit

class CommonMenuTableViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceTextField: UITextField!
    
    // MARK: IBActions
    @IBAction func itemPriceTextFieldChangeDidEnd(_ sender: UITextField) {
        let price = self.itemPriceTextField.text!.getFloatNumber()
        
        if currentIndexPath != nil {
            delegate?.itemPriceTextFieldChangeDidEnd(indexPath: currentIndexPath!, price: price)
        }
    }
    
    // MARK: Variables
    var currentIndexPath: IndexPath?
    var currentPrice: Float?
    weak var delegate: CommonMenuTableViewCellDelegate?
}
