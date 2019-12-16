//
//  GuestAtTableTableViewCell.swift
//  CafeManager
//
//  Created by Denis Kurashko on 27.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit

class GuestAtTableTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    weak var cellDelegate: GuestAtTableTableViewCellDelegate?
    weak var didRefreshTableViewDelegate: GuestOrdersTableViewRefreshDelegate?
    var guest: Guest!
    
    @IBOutlet weak var addGuestOrderButton: UIButton!
    @IBOutlet weak var closeGuestButton: UIButton!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var guestAmountLabel: UILabel!
    @IBOutlet weak var guestOrdersTableView: UITableView!
    
    @IBAction func didPressCloseGuestButton(_ sender: UIButton) {
        cellDelegate?.didPressCloseGuestButton(guest: guest!)
    }
    
    @IBAction func didPressAddGuestOrderButton(_ sender: UIButton) {
        cellDelegate?.didPressAddGuestOrderButton(guest: self.guest!, sender: sender)
    }
    
    func updateGUI() {
        self.guestOrdersTableView.reloadData()
    }
    
    // MARK: Table view that contain current guest orders
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestOrderCell", for: indexPath) as! GuestOrderTableViewCell
        let order = self.guest.orders[indexPath.row]
        
        cell.cellDelegate = self
        cell.order = order
        
        cell.itemNameLabel.text = order.menuItemName
        cell.itemQuantityLabel.text = String(describing: order.quantity)
        cell.itemsPrice.text = NumberFormatter.localizedString(from: NSNumber(value: Float(order.quantity) * (order.price)), number: .decimal) + UserSettings.currencySymbol
        
        // Change cell buttons color theme
        cell.plusButton = ChangeGUITheme.setColorThemeFor(button: cell.plusButton)
        cell.minusButton = ChangeGUITheme.setColorThemeFor(button: cell.minusButton)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let order = self.guest.orders[indexPath.row]
            order.remove()
            self.didRefreshTableViewDelegate?.didRefreshGuestOrdersTableView()
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.guest.orders.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 0
    }
}

extension GuestAtTableTableViewCell:GuestOrdersTableViewCellDelegate {
    func didPressOrderIncreaseOrDecreaseButton(order: Order, action: String) {
        if action == "+" {
            order.increaseQuantity()
        } else {
            if action == "-", order.quantity > 1 {
                order.decreaseQuantity()
            } else {
                return
            }
        }
        didRefreshTableViewDelegate?.didRefreshGuestOrdersTableView()
    }
}
