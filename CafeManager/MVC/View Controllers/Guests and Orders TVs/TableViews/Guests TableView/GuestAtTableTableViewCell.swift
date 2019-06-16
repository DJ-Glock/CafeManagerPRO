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
    var guest: Guest? = nil
    var guestOrders: [GuestOrder] = []
    
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
    
    private func reloadDataFromCoreData() {
        if guest == nil {
            self.guestOrders = []
        } else {
            self.guestOrders = GuestOrder.getOrders(for: self.guest!)
        }
    }
    
    func updateGUI() {
        self.reloadDataFromCoreData()
        self.guestOrdersTableView.reloadData()
    }
    
    // MARK: Table view that contain current guest orders
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestOrderCell", for: indexPath) as! GuestOrderTableViewCell
        let order = self.guestOrders[indexPath.row]
        
        cell.cellDelegate = self
        cell.order = order
        cell.menuItem = order.menuItem
        
        cell.itemNameLabel.text = order.menuItem.itemName
        cell.itemQuantityLabel.text = String(describing: order.quantityOfItems)
        cell.itemsPrice.text = NumberFormatter.localizedString(from: NSNumber(value: Float(order.quantityOfItems) * (order.menuItem.itemPrice)), number: .decimal) + UserSettings.currencySymbol
        
        // Change cell buttons color theme
        cell.plusButton = ChangeGUITheme.setColorThemeFor(button: cell.plusButton)
        cell.minusButton = ChangeGUITheme.setColorThemeFor(button: cell.minusButton)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let order = self.guestOrders[indexPath.row]
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
        return guestOrders.count
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
    func didPressOrderIncreaseOrDecreaseButton(order: GuestOrder, action: String) {
        if action == "+" {
            order.increaseQuantity()
        } else {
            if action == "-", order.quantityOfItems > 1 {
                order.decreaseQuantity()
            } else {
                return
            }
        }
        self.updateGUI()
        didRefreshTableViewDelegate?.didRefreshGuestOrdersTableView()
    }
}
