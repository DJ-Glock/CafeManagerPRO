//
//  HistoryTableUIViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.08.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableUIViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: variables:
    //The following three variables will be set before segue to this view.
    var tableName: String? = nil
    var currentTable: TablesTable? = nil
    var currentTableSession: TableSessionTable? = nil
    
    private var selectedCellIndexPath: IndexPath?
    private var selectedCellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 240
        } else {
            return 120
        }
    }
    private var unselectedCellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 45
        } else {
            return 40
        }
    }
    private var currentGuest: GuestsTable? = nil
    private var guestNameTextField: UITextField!
    private var guests: [GuestsTable] {
        if currentTableSession != nil {
            return GuestsTable.getAllGuestsForTableSorted(tableSession: currentTableSession!)
        } else {
            return []
        }
    }
    private var orders: [OrdersTable] {
        if currentTableSession != nil {
            return OrdersTable.getOrdersFor(tableSession: currentTableSession!)
        } else {
            return []
        }
    }
    private var originalAmount: Float {
        return TableSessionTable.calculateTotalAmount(currentTableSession: currentTableSession)
    }
    private var totalAmount: Float {
        guard currentTableSession != nil else {return 0}
        if currentTableSession!.totalAmount != -1 {
            return currentTableSession!.totalAmount
        } else {
            return TableSessionTable.calculateTotalAmount(currentTableSession: currentTableSession)
        }
    }
    private var discount: Int16 {
        guard currentTableSession != nil else {return 0}
        if currentTableSession!.totalAmount != -1 {
            return currentTableSession!.discount
        } else {
            return 0
        }
    }
    
    private var tips: Float {
        if let tips = currentTableSession?.tips {
            return tips
        }
        return 0
    }
    private var countOfGuests: Int {
        get {
            guard currentTableSession != nil else {return 0}
            return GuestsTable.getAllGuestsForTableSorted(tableSession: currentTableSession!).count
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var tableCapacityLabel: UILabel!
    @IBOutlet weak var tableCountOfGuestsLabel: UILabel!
    @IBOutlet weak var tableOpenTimeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var addGuestButton: UIButton!
    @IBOutlet weak var addKnownGuestButton: UIButton!
    @IBOutlet weak var addOrderButton: UIButton!
    @IBOutlet weak var guestsTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    //MARK: IBActions
    @IBAction func addCustomGuest(_ sender: UIButton) {
        let customGuest = CustomGuestAssembly.assembleModule()
        customGuest.delegate = self
        customGuest.chooseCustomGuest(sender: sender)
    }
    @IBAction func addGuestButtonPressed(_ sender: UIButton) {addQuickGuest()}
    @IBAction func addOrderButtonPressed(_ sender: UIButton) {
        let addOrder = AddOrderAssembly.assembleModule()
        addOrder.delegate = self
        addOrder.showMenuItemsToAddOrder(forSession: currentTableSession!, sender: sender)
    }
    @IBAction func recalculateButtonPressed(_ sender: UIBarButtonItem) {
        if let session = currentTableSession {
            let plainSession = TableSessionStruct(openTime: session.openTime as Date, closeTime: session.closeTime as Date?, totalAmount: session.totalAmount, totalTips: session.tips, discount: session.discount)
            let checkout = CheckoutAssembly.assembleModule()
            checkout.delegate = self as CheckoutDelegate
            checkout.checkoutWithParams(session: plainSession, originalTotalAmount: self.originalAmount, sender: sender)
        }
    }
    
    // MARK: Functions
    fileprivate func configureViewDidLoad() {
        guestsTableView.dataSource = self
        guestsTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        // To dismiss keyboard
        self.addGestureRecognizer()
        
        // Change buttons Theme
        addGuestButton = ChangeGUITheme.setColorThemeFor(button: addGuestButton)
        addKnownGuestButton = ChangeGUITheme.setColorThemeFor(button: addKnownGuestButton)
        addOrderButton = ChangeGUITheme.setColorThemeFor(button: addOrderButton)
    }
    
    // MARK: System functions for View loading/appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewDidLoad()
//        addSyncObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateGuestsTableView()
        updateOrdersTableView()
        updateLabelsViewWillAppear()
    }
     
    // MARK: GUI update functions
    private func updateLabelsViewWillAppear() {
        tableCapacityLabel.text = String(describing: currentTable!.tableCapacity)
        tableCountOfGuestsLabel.text = String(describing: countOfGuests)
        tableOpenTimeLabel.text = currentTableSession!.openTime.convertToString() + "-" + currentTableSession!.closeTime!.convertToString()
        
        if tips > 0 {
            totalAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal) + UserSettings.currencySymbol + " " + NSLocalizedString("tips", comment: "") + "\(tips)" + UserSettings.currencySymbol
        } else {
            totalAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal) + UserSettings.currencySymbol + " " + NSLocalizedString("discount", comment: "") + "\(discount)" + "%"
        }
    }
    
    private func updateLabels() {
        tableCapacityLabel.text = String(describing: currentTable!.tableCapacity)
        tableCountOfGuestsLabel.text = String(describing: countOfGuests)
        tableOpenTimeLabel.text = currentTableSession!.openTime.convertToString() + "-" + currentTableSession!.closeTime!.convertToString()
        
        if tips > 0 {
            if self.totalAmount != self.originalAmount {
                totalAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal) + UserSettings.currencySymbol + " " + NSLocalizedString("original", comment: "") + NumberFormatter.localizedString(from: NSNumber(value: originalAmount), number: .decimal) + UserSettings.currencySymbol
            } else {
                totalAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal) + UserSettings.currencySymbol + " " + NSLocalizedString("tips", comment: "") + "\(tips)" + UserSettings.currencySymbol
            }
        } else {
            if self.totalAmount != self.originalAmount {
                totalAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal) + UserSettings.currencySymbol + " " + NSLocalizedString("original", comment: "") + NumberFormatter.localizedString(from: NSNumber(value: originalAmount), number: .decimal) + UserSettings.currencySymbol
            } else {
                totalAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal) + UserSettings.currencySymbol + " " + NSLocalizedString("discount", comment: "") + "\(discount)" + "%"
            }
        }
    }
    
    private func updateGUI() {
        updateGuestsTableView()
        updateOrdersTableView()
        updateLabels()
    }
    
    
    private func addQuickGuest () {
        GuestsTable.addNewGuestHistorical(tableSession: currentTableSession!, openTime: (currentTableSession?.openTime ?? Date()), closeTime: (currentTableSession?.closeTime)!)
        updateGuestsTableView()
        updateLabels()
    }
    
    // MARK: functions for tables update
    private func updateGuestsTableView () {
        let tableView = guestsTableView
        if currentTableSession != nil {
            tableView?.reloadData()
            if tableView?.numberOfRows(inSection: 0) != 0 {
                tableView?.scrollToRow(at: [0,0], at: UITableViewScrollPosition.top, animated: true)
            }
        } else {
            tableView?.reloadData()
        }
    }
    
    private func updateOrdersTableView () {
        let tableView = ordersTableView
        tableView?.reloadData()
    }
    
    // MARK: Functions for Alert window for changing guest
    private func configureTableNameTextField (textField: UITextField!) {
        textField.tintColor = UIColor.darkGray
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.keyboardType = .default
        guestNameTextField = textField
    }
    
    // MARK: Functions for tableViews
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.guestsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath) as! GuestAtTableTableViewCell
            let guest = guests[indexPath.row]
            
            cell.cellDelegate = self
            cell.didRefreshTableViewDelegate = self
            cell.guest = guest
            cell.guestOrdersTableView.delegate = cell
            cell.guestOrdersTableView.dataSource = cell
            
            cell.guestNameLabel.text = guest.guestName
            cell.openTimeLabel.text = NSLocalizedString("guestComeTime", comment: "") + guest.openTime.convertToString()
            if UserSettings.isTimeCafe == true {
                cell.guestAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: Float(TableSessionTable.calculateIndividualAmount(guest: guest))), number: .decimal) + UserSettings.currencySymbol
            } else {
                cell.guestAmountLabel.text = NSLocalizedString("guestGoneTime", comment: "") + guest.closeTime!.convertToString()
            }
            
            cell.guestOrdersTableView.reloadData()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderInTableTableViewCell
            let order = orders[indexPath.row]
            
            cell.cellDelegate = self
            cell.order = order
            //cell.menuItem = order.menuItem
            
            cell.itemNameLabel.text = order.menuItemName
            cell.itemQuantityLabel.text = String(describing: order.quantity)
            cell.itemsPrice.text = NumberFormatter.localizedString(from: NSNumber(value: Float(order.quantity) * (order.price)), number: .decimal) + UserSettings.currencySymbol
            
            // Change cell buttons color theme
            cell.plusButton = ChangeGUITheme.setColorThemeFor(button: cell.plusButton)
            cell.minusButton = ChangeGUITheme.setColorThemeFor(button: cell.minusButton)
            
            return cell
        }
    }
    
    // MARK: Functions for adding orders into Guests table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.guestsTableView {
            if indexPath == self.selectedCellIndexPath {
                self.selectedCellIndexPath = nil
                tableView.beginUpdates()
                tableView.endUpdates()
            } else {
                self.selectedCellIndexPath = indexPath
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == self.guestsTableView {
            self.selectedCellIndexPath = nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.guestsTableView {
            if self.selectedCellIndexPath == indexPath {
                return self.selectedCellHeight
            } else {
                return self.unselectedCellHeight
            }
        }
        return UITableViewAutomaticDimension
    }
    
    // MARK: Function for Edit/Delete swipe button
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        if tableView == self.ordersTableView {
            let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let order = self.orders[editActionsForRowAt.row]
                order.remove()
                self.updateLabels()
                self.updateOrdersTableView()
            }
            deleteButton.backgroundColor = .red
            return [deleteButton]
        }
        if tableView == self.guestsTableView {
            let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let guest = self.guests[editActionsForRowAt.row]
                guest.removeFromTable()
                self.updateLabels()
                self.updateGuestsTableView()
            }
            deleteButton.backgroundColor = .red
            
            let changeButton = UITableViewRowAction(style: .default, title: "Rename") { action, index in
                let alert = UIAlertController(title: NSLocalizedString("alertInputGuestName", comment: ""), message: nil, preferredStyle: .alert)
                alert.addTextField(configurationHandler: self.configureTableNameTextField)
                alert.textFields?[0].autocapitalizationType = .sentences
                alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .default, handler: { (UIAlertAction) in
                    let guest = self.guests[editActionsForRowAt.row]
                    var newGuestName: String = ""
                    if self.guestNameTextField.text != "" {
                        newGuestName = self.guestNameTextField.text!
                    } else {
                        newGuestName = guest.guestName
                    }
                    guest.renameTo(newName: newGuestName)
                    self.updateLabels()
                    self.updateGuestsTableView()
                }))
                self.presentAlert(alert: alert, animated: true)
            }
            changeButton.backgroundColor = .lightGray
            
            let changeTimeButton = UITableViewRowAction(style: .destructive, title: "Time") { action, index in
                self.currentGuest = self.guests[editActionsForRowAt.row]
                let periodPicker = PeriodPickerAssembly.assembleModule()
                periodPicker.delegate = self as PeriodPickerDelegate
                periodPicker.choosePeriodWithParams(startDateLimit: self.currentTableSession?.openTime as Date?, endDateLimit: self.currentTableSession?.closeTime as Date?, currentStartDate: self.currentGuest?.openTime as Date?, currentEndDate: self.currentGuest?.closeTime as Date?, sender: self.addGuestButton)
            }
            changeTimeButton.backgroundColor = .blue
        
            return [deleteButton, changeButton, changeTimeButton]
        }
        else {
            return []
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.guestsTableView {
            return guests.count
        }
        else if tableView == self.ordersTableView {
            return orders.count
        }
        else {return 0}
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

// MARK: Delegates
// Delegate of GuestsTableView
extension HistoryTableUIViewController: GuestAtTableTableViewCellDelegate {
    func didPressAddGuestOrderButton(guest: GuestsTable, sender: AnyObject) {
        self.currentGuest = guest
        
        let addOrder = AddOrderAssembly.assembleModule()
        addOrder.delegate = self
        addOrder.showMenuItemsToAddOrder(forGuest: self.currentGuest!, sender: sender)
    }
    
    func didPressCloseGuestButton(guest: GuestsTable) {
    }
}

// Delegate for GuestOrders table view refresh - to refresh Table GUI
extension HistoryTableUIViewController: GuestOrdersTableViewRefreshDelegate {
    func didRefreshGuestOrdersTableView() {
        self.updateGUI()
    }
}

// Delegate for OrdersTableView
extension HistoryTableUIViewController: OrderInTableTableViewCellDelegate {
    func didPressIncreaseOrDecreaseOrderQuantityButton(order: OrdersTable, menuItem: MenuTable, action: String) {
        if action == "+" {
            order.increaseQuantity()
        } else {
            if action == "-", order.quantity > 1 {
                order.decreaseQuantity()
            } else {
                return
            }
        }
        updateLabels()
        updateOrdersTableView()
    }
}

// PeriodPicker delegate
extension HistoryTableUIViewController: PeriodPickerDelegate {
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date) {
        self.currentGuest?.changeTime(openTime: startDate, closeTime: endDate)
    }
}

// Delegate of CustomGuest module that allows user to choose custom guest name
extension HistoryTableUIViewController: CustomGuestDelegate {
    func didChooseCustomGuest(name: String) {
        GuestsTable.addNewCustomGuestHistorical(guestName: name, tableSession: currentTableSession!, openTime: currentTableSession!.openTime, closeTime: currentTableSession!.closeTime!)
        updateGUI()
    }
}

// Delegate of AddOrder module that allows user to choose items to order
extension HistoryTableUIViewController: AddOrderDelegate {
    func didChoose(menuItem item: MenuTable, forGuest guest: GuestsTable) {
        GuestOrdersTable.addOrIncreaseOrder(for: guest, menuItem: item)
        self.updateGUI()
    }
    
    func didChoose(menuItem item: MenuTable, forSession session: TableSessionTable) {
        OrdersTable.addOrIncreaseOrder(tableSession: session, menuItem: item)
        self.updateGUI()
    }
}

// Delegate of Checkout module that allows user to calculate final check
extension HistoryTableUIViewController:CheckoutDelegate {
    func didPerformCheckout(totalAmount: Float, discount: Int16, tips: Float) {
        do {
            try TableSessionTable.saveRecalculated(tableSession: currentTableSession!, totalAmount: totalAmount, discount: discount, tips: tips)
        } catch {
            CommonAlert.shared.show(title: "Failed to close session", text: error.localizedDescription)
        }
        self.updateGUI()
        self.navigationController?.popViewController(animated: true)
    }
}
