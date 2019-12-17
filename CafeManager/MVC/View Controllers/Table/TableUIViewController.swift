//
//  TableUIViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import NotificationCenter

/// To do:
/// Move table session - needs to be refactored
/// Add order - needs to be refactored

class TableUIViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Variables
    //The following three variables will be set before segue to this view.
    var tableName: String? = nil
    var currentTable: Table? = nil
    var currentTableSession: TableSession? = nil
    
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
    private var guestNameTextField: UITextField!
    private var currentGuest: Guest? = nil
    private var guests: [Guest] {
        get {
            return self.currentTableSession?.guests ?? []
        }
    }
    private var orders: [Order] {
        get {
            return self.currentTableSession?.orders ?? []
        }
    }
    private var actualAmount: Float = 0
    private var amount: Float = 0
    private var countOfGuests: Int {
        get {
            return guests.count
        }
    }
    private var countOfActiveGuests: Int {
        get {
            let guests = self.guests
            var activeGuests = 0
            for guest in guests {
                if guest.closeTime == nil {
                    activeGuests += 1
                }
            }
            return activeGuests
        }
    }
    private var tableCapacity: Int {
        get {
            return Int(currentTable!.capacity)
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var tableCapacityLabel: UILabel!
    @IBOutlet weak var tableCountOfGuestsLabel: UILabel!
    @IBOutlet weak var tableOpenTimeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var addGuestButton: UIButton!
    @IBOutlet weak var addKnownGuestButton: UIButton!
    @IBOutlet weak var moveGuestsButton: UIButton!
    @IBOutlet weak var addOrderButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var guestsTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    //MARK: IBActions
    //@IBAction func saveDescriptionButtonPressed(_ sender: UIButton) {saveTableDescription()}
    @IBAction func closeTableBarButtonPressed(_ sender: UIBarButtonItem) {
        self.closeTableSession(sender: sender)
    }
    
    @IBAction func addCustomGuestButtonPressed(_ sender: UIButton) {
        self.addCustomGuest(sender: sender)
    }
    
    @IBAction func addGuestButtonPressed(_ sender: UIButton) {
        self.addQuickGuest(sender: sender)
    }
    
    @IBAction func addOrderButtonPressed(_ sender: UIButton) {
        self.addOrder(sender: sender)
    }
    
    @IBAction func moveSessionButtonPressed(_ sender: UIButton) {
        self.moveTableSession(sender: sender)
    }
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        updateGUI()
    }
    
    //MARK: System functions for View loading/appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewDidLoad()
        self.addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateGUI()
    }
    
    private func configureViewDidLoad() {
        // Setting delegates
        guestsTableView.dataSource = self
        guestsTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        // Change buttons Theme
        addGuestButton = ChangeGUITheme.setColorThemeFor(button: addGuestButton)
        addKnownGuestButton = ChangeGUITheme.setColorThemeFor(button: addKnownGuestButton)
        addOrderButton = ChangeGUITheme.setColorThemeFor(button: addOrderButton)
        moveGuestsButton = ChangeGUITheme.setColorThemeFor(button: moveGuestsButton)
        refreshButton = ChangeGUITheme.setColorThemeFor(button: refreshButton)
        
        //To dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // MARK: GUI update functions
    private func updateLabels() {
        tableCapacityLabel.text = String(describing: currentTable!.capacity)
        tableCountOfGuestsLabel.text = String(describing: countOfGuests)
        if currentTableSession != nil, currentTableSession?.openTime != nil {
            tableOpenTimeLabel.text = currentTableSession!.openTime.convertToString()
        } else {
            tableOpenTimeLabel.text = " - "
        }
        totalAmountLabel.text = NumberFormatter.localizedString(from: NSNumber(value: actualAmount), number: .decimal) + UserSettings.currencySymbol + " (\(NumberFormatter.localizedString(from: NSNumber(value: amount), number: .decimal))\(UserSettings.currencySymbol))"
    }
    
    private func updateGUI() {
        DBQuery.getActiveTableSessionAsync(forTable: self.currentTable!) { (tableSession, error) in
            self.currentTableSession = tableSession
            self.updateLabels()
            self.guestsTableView.reloadData()
            self.ordersTableView.reloadData()
        }
        
    }
    
    // MARK: Functions for managing table, orders, guests
    private func addQuickGuest(sender: Any) {
        guard tableCapacity > countOfActiveGuests else {return}
        
        let name = NSLocalizedString("guestNameForInsert", comment: "") + " \((self.countOfGuests) + 1)"
        
        if self.currentTableSession == nil {
            let tableSession = TableSession(firebaseID: nil, table: self.currentTable!, openTime: Date())
            let newGuest = Guest(name: name, openTime: Date(), tableSession: tableSession)
            tableSession.guests.append(newGuest)
            self.currentTableSession = tableSession
            
            DBPersist.createActiveTableSessionAsync(newTableSession: tableSession) {(error) in
                if let error = error {
                    CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving session data in the database: \(error)")
                }
            }
        } else {
            let newGuest = Guest(name: name, openTime: Date(), tableSession: self.currentTableSession!)
            self.currentTableSession?.guests.append(newGuest)
            DBUpdate.updateGuestsOfActiveTableSessionAsync(tableSessionToUpdate: self.currentTableSession!) {(error) in
                if let error = error {
                    CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving guests data in the database: \(error)")
                }
            }
        }
    }
    
    private func addCustomGuest(sender: AnyObject) {
        guard tableCapacity > countOfActiveGuests else {return}
        
        let customGuest = CustomGuestAssembly.assembleModule()
        customGuest.delegate = self
        customGuest.chooseCustomGuest(sender: sender)
    }
    
    private func addOrder(sender: AnyObject) {
        guard currentTableSession != nil else {return}
        
        let addOrder = AddOrderAssembly.assembleModule()
        addOrder.delegate = self
        addOrder.showMenuItemsToAddOrder(forSession: currentTableSession!, sender: sender)
    }
    
    // To be refactored
    private func moveTableSession (sender: AnyObject) {
        if let session = currentTableSession {
            let move = MoveGuestsAssembly.assembleModule()
            move.delegate = self
            move.chooseTargetTable(forSession: session, sender: sender)
        }
    }
    
    private func closeTableSession (sender: AnyObject) {
        if let session = currentTableSession {
            let checkout = CheckoutAssembly.assembleModule()
            checkout.delegate = self
            checkout.checkoutWithParams(session: session, originalTotalAmount: self.amount, sender: sender)
        }
    }
    
    // MARK: functions for tables update
    private func updateGuestsTableView() {
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
    
    private func updateOrdersTableView() {
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
            cell.guest = guest
            cell.guestOrdersTableView.delegate = cell
            cell.guestOrdersTableView.dataSource = cell
            
            cell.guestNameLabel.text = guest.name
            cell.openTimeLabel.text = NSLocalizedString("guestComeTime", comment: "") + guest.openTime.convertToString()
            cell.closeGuestButton.isEnabled = true
            
            // Change cell button color theme
            cell.closeGuestButton = ChangeGUITheme.setColorThemeFor(button: cell.closeGuestButton)
            cell.addGuestOrderButton = ChangeGUITheme.setColorThemeFor(button: cell.addGuestOrderButton)
            cell.guestNameLabel.textColor = ColorThemes.textColorNormal
            cell.openTimeLabel.textColor = ColorThemes.textColorNormal
            cell.guestAmountLabel.textColor = ColorThemes.textColorNormal
            
            cell.guestAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: Guest.calculateCurrentAmount(forGuest: guest)), number: .decimal) + UserSettings.currencySymbol
            if guest.closeTime != nil {
                cell.addGuestOrderButton.isEnabled = false
                cell.closeGuestButton.isEnabled = false
                cell.guestNameLabel.textColor = ColorThemes.textColorDisabled
                cell.openTimeLabel.textColor = ColorThemes.textColorDisabled
                cell.guestAmountLabel.textColor = ColorThemes.textColorDisabled
            }
            cell.updateGUI()
            
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
    
    
    //MARK: Function for swipe buttons
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        if tableView == self.ordersTableView {
            let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let order = self.orders[editActionsForRowAt.row]
                order.remove()
            }
            deleteButton.backgroundColor = .red
            return [deleteButton]
        }
        if tableView == self.guestsTableView {
            let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let guest = self.guests[editActionsForRowAt.row]
                guest.removeFromTable()
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
                        newGuestName = guest.name
                    }
                    guest.renameTo(newName: newGuestName)
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
            
            let moveGuestButton = UITableViewRowAction(style: .default, title: "Move", handler: { (action, index) in
                self.currentGuest = self.guests[editActionsForRowAt.row]
                let move = MoveGuestsAssembly.assembleModule()
                move.delegate = self
                move.chooseTargetTableSession(forGuest: self.currentGuest!, sender: self.moveGuestsButton)
            })
            moveGuestButton.backgroundColor = .blue
            
            changeTimeButton.backgroundColor = .blue
            self.currentGuest = self.guests[editActionsForRowAt.row]
            
            if currentGuest?.closeTime != nil {
                return [deleteButton, changeButton, changeTimeButton]
            } else {
                return [deleteButton, changeButton, moveGuestButton]
            }
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

// MARK: Delegate of GuestsTableView
extension TableUIViewController: GuestAtTableTableViewCellDelegate {
    func didPressAddGuestOrderButton(guest: Guest, sender: AnyObject) {
        self.currentGuest = guest
        
        let addOrder = AddOrderAssembly.assembleModule()
        addOrder.delegate = self
        addOrder.showMenuItemsToAddOrder(forGuest: self.currentGuest!, sender: sender)
    }
    
    func didPressCloseGuestButton(guest: Guest) {
        let alert = UIAlertController(title: NSLocalizedString("alertConfirmGuestHasGone", comment: ""), message: NSLocalizedString("alertConfirmGuestHasGoneMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .destructive, handler: { (UIAlertAction) in
            guest.close()
        }))
        self.presentAlert(alert: alert, animated: true)
    }
}

// MARK: Delegate of OrdersTableView
extension TableUIViewController: OrderInTableTableViewCellDelegate {
    func didPressIncreaseOrDecreaseOrderQuantityButton(order: Order, action: String) {
        if action == "+" {
            order.increaseQuantity()
        } else {
            if action == "-", order.quantity > 1 {
                order.decreaseQuantity()
            } else {
                return
            }
        }
    }
}

// PeriodPicker delegate
extension TableUIViewController: PeriodPickerDelegate {
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date) {
        self.currentGuest?.changeTime(openTime: startDate, closeTime: endDate)
    }
}

// MARK: Delegate of AddOrder view
extension TableUIViewController: AddOrderDelegate {
    func didChoose(menuItem item: MenuItem, forGuest guest: Guest) {
        let order = Order(menuItemName: item.name, quantity: 1, price: item.price, orderedGuest: guest)
        guest.orders.append(order)
        DBGeneral.updateActiveSessionsOrders(tableSession: guest.tableSession!)
    }
    
    func didChoose(menuItem item: MenuItem, forSession session: TableSession) {
        let order = Order(menuItemName: item.name, quantity: 1, price: item.price, orderedTable: session)
        session.orders.append(order)
        DBGeneral.updateActiveSessionsOrders(tableSession: session)
    }
}

// Delegate of CustomGuest module that allows user to choose custom guest name
extension TableUIViewController: CustomGuestDelegate {
    func didChooseCustomGuest(name: String) {
        if self.currentTableSession == nil {
            let tableSession = TableSession(firebaseID: nil, table: self.currentTable!, openTime: Date())
            let newGuest = Guest(name: name, openTime: Date(), tableSession: tableSession)
            tableSession.guests.append(newGuest)
            self.currentTableSession = tableSession
            
            DBPersist.createActiveTableSessionAsync(newTableSession: tableSession) {(error) in
                if let error = error {
                    CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving session data in the database: \(error)")
                }
            }
        } else {
            let newGuest = Guest(name: name, openTime: Date(), tableSession: self.currentTableSession!)
            self.currentTableSession?.guests.append(newGuest)
            DBUpdate.updateGuestsOfActiveTableSessionAsync(tableSessionToUpdate: self.currentTableSession!) {(error) in
                if let error = error {
                    CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving guests data in the database: \(error)")
                }
            }
        }
    }
}

// Delegate of MoveGuests module that allows user to choose target table/table session to move session/guest
extension TableUIViewController: MoveGuestsDelegate {
    func didChoose(targetTableSession: TableSession, forGuest guest: Guest) {
        guest.moveGuest(to: targetTableSession)
//        self.updateGUI()
    }
    
    func didChoose(targetTable: Table, forSession session: TableSession) {
        TableSession.moveTableSessionTo(targetTable: targetTable, currentSession: session)
//        self.updateGUI()
    }
}

// Delegate of Checkout module that allows user to calculate final check
extension TableUIViewController: CheckoutDelegate {
    func didPerformCheckout(totalAmount: Float, discount: Int16, tips: Float) {
        do {
            try TableSession.checkout(tableSession: currentTableSession!, totalAmount: totalAmount, discount: discount, tips: tips)
        } catch {
            CommonAlert.shared.show(title: "Failed to close session", text: error.localizedDescription)
        }
//        self.updateGUI()
        self.navigationController?.popViewController(animated: true)
    }
}
