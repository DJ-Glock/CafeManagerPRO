//
//  CommonMenuTableViewCellDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 25.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

protocol CommonMenuTableViewCellDelegate : class {
    func itemPriceTextFieldChangeDidEnd (indexPath: IndexPath, price: Float?)
}
