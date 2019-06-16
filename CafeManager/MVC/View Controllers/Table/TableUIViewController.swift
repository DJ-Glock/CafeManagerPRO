//
//  TableUIViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 24.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import NotificationCenter

class TableUIViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Variables
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
    private var guestNameTextField: UITextField!
    private var currentGuest: GuestsTable? = nil
    private var guests: [GuestsTable] = []
    private var orders: [OrdersTable] = []
    private var actualTotalAmount: Float = 0
    private var totalAmount: Float = 0
    private var countOfGuests: Int = 0
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
        if let session = currentTableSession {
            let plainSession = TableSessionStruct(openTime: session.openTime as Date, closeTime: session.closeTime as Date?, totalAmount: session.totalAmount, totalTips: session.tips, discount: session.discount)
            let checkout = CheckoutAssembly.assembleModule()
            checkout.delegate = self
            checkout.checkoutWithParams(session: plainSession, originalTotalAmount: self.totalAmount, sender: sender)
        }

    }
    @IBAction func addCustomGuest(_ sender: UIButton) {
        guard tableCapacity > countOfGuests else {return}
        let customGuest = CustomGuestAssembly.assembleModule()
        customGuest.delegate = self
        customGuest.chooseCustomGuest(sender: sender)
    }
    @IBAction func addGuestButtonPressed(_ sender: UIButton) {addQuickGuest()}
    @IBAction func addOrderButtonPressed(_ sender: UIButton) {
        guard currentTableSession != nil else {return}
        
        let addOrder = AddOrderAssembly.assembleModule()
        addOrder.delegate = self
        addOrder.showMenuItemsToAddOrder(forSession: currentTableSession!, sender: sender)
    }
    @IBAction func moveSessionButtonPressed(_ sender: UIButton) {
        if let session = currentTableSession {
            let move = MoveGuestsAssembly.assembleModule()
            move.delegate = self
            move.chooseTargetTable(forSession: session, sender: sender)
        }
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
    
    private func reloadDataFromCoreData() {
        if self.currentTableSession == nil {
            self.guests = []
            self.orders = []
            self.actualTotalAmount = 0
            self.totalAmount = 0
            self.countOfGuests = 0
        } else {
            self.guests = GuestsTable.getAllGuestsForTableSorted(tableSession: currentTableSession!)
            self.orders = OrdersTable.getOrdersFor(tableSession: currentTableSession!)
            self.actualTotalAmount = TableSessionTable.calculateActualTotalAmount(for: currentTableSession)
            self.totalAmount = TableSessionTable.calculateTotalAmount(currentTableSession: currentTableSession)
            self.countOfGuests = GuestsTable.getActiveGuestsFor(tableSession: currentTableSession!).count
        }
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
        totalAmountLabel.text = NumberFormatter.localizedString(from: NSNumber(value: actualTotalAmount), number: .decimal) + UserSettings.currencySymbol + " (\(NumberFormatter.localizedString(from: NSNumber(value: totalAmount), number: .decimal))\(UserSettings.currencySymbol))"
    }
    
    private func updateGUI() {
        currentTableSession = TableSessionTable.getCurrentTableSession(table: currentTable!)
        self.reloadDataFromCoreData()
        updateGuestsTableView()
        updateOrdersTableView()
        updateLabels()
        if currentTableSession == nil {
            addOrderButton.isEnabled = false
        } else {
            addOrderButton.isEnabled = true
        }
    }
    
    // MARK: Functions for managing table, orders, guests
    private func addQuickGuest () {
        guard tableCapacity > countOfGuests else {return}
        if currentTableSession == nil {
            currentTableSession = TableSessionTable.createTableSession(table: currentTable!)
            addOrderButton.isEnabled = true
        }
        GuestsTable.addNewGuest(tableSession: currentTableSession!)
        self.updateGUI()
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
            cell.closeGuestButton.isEnabled = true
            
            // Change cell button color theme
            cell.closeGuestButton = ChangeGUITheme.setColorThemeFor(button: cell.closeGuestButton)
            cell.addGuestOrderButton = ChangeGUITheme.setColorThemeFor(button: cell.addGuestOrderButton)
            cell.guestNameLabel.textColor = ColorThemes.textColorNormal
            cell.openTimeLabel.textColor = ColorThemes.textColorNormal
            cell.guestAmountLabel.textColor = ColorThemes.textColorNormal
            
            cell.guestAmountLabel.text = NSLocalizedString("amount", comment: "") + ": " + NumberFormatter.localizedString(from: NSNumber(value: TableSessionTable.calculateIndividualAmount(guest: guest)), number: .decimal) + UserSettings.currencySymbol
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
                self.updateGUI()
            }
            deleteButton.backgroundColor = .red
            return [deleteButton]
        }
        if tableView == self.guestsTableView {
            let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let guest = self.guests[editActionsForRowAt.row]
                guest.removeFromTable()
                self.updateGUI()
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
                    self.updateGUI()
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

// MARK: Delegates
// Delegate of GuestsTableView
extension TableUIViewController: GuestAtTableTableViewCellDelegate {
    func didPressAddGuestOrderButton(guest: GuestsTable, sender: AnyObject) {
        self.currentGuest = guest
        
        let addOrder = AddOrderAssembly.assembleModule()
        addOrder.delegate = self
        addOrder.showMenuItemsToAddOrder(forGuest: self.currentGuest!, sender: sender)
    }
    
    func didPressCloseGuestButton(guest: GuestsTable) {
        let alert = UIAlertController(title: NSLocalizedString("alertConfirmGuestHasGone", comment: ""), message: NSLocalizedString("alertConfirmGuestHasGoneMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .destructive, handler: { (UIAlertAction) in
            guest.close()
            self.updateGUI()
        }))
        self.presentAlert(alert: alert, animated: true)
    }
}

// Delegate for GuestOrders table view refresh - to refresh Table GUI
extension TableUIViewController: GuestOrdersTableViewRefreshDelegate {
    func didRefreshGuestOrdersTableView() {
        self.updateGUI()
    }
}

// Delegate of OrdersTableView
extension TableUIViewController: OrderInTableTableViewCellDelegate {
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
        self.updateGUI()
    }
}

// PeriodPicker delegate
extension TableUIViewController: PeriodPickerDelegate {
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date) {
        self.currentGuest?.changeTime(openTime: startDate, closeTime: endDate)
    }
}

// Delegate of AddOrder module that allows user to choose items to order
extension TableUIViewController: AddOrderDelegate {
    func didChoose(menuItem item: MenuTable, forGuest guest: GuestsTable) {
        GuestOrdersTable.addOrIncreaseOrder(for: guest, menuItem: item)
        self.updateGUI()
    }
    
    func didChoose(menuItem item: MenuTable, forSession session: TableSessionTable) {
        OrdersTable.addOrIncreaseOrder(tableSession: session, menuItem: item)
        self.updateGUI()
    }
}

// Delegate of CustomGuest module that allows user to choose custom guest name
extension TableUIViewController: CustomGuestDelegate {
    func didChooseCustomGuest(name: String) {
        if let session = self.currentTableSession {
            GuestsTable.addNewCustomGuest(guestName: name, tableSession: session)
        } else {
            let session = TableSessionTable.createTableSession(table: self.currentTable!)
            GuestsTable.addNewCustomGuest(guestName: name, tableSession: session)
        }
        self.updateGUI()
    }
}

// Delegate of MoveGuests module that allows user to choose target table/table session to move session/guest
extension TableUIViewController: MoveGuestsDelegate {
    func didChoose(targetTableSession: TableSessionTable, forGuest guest: GuestsTable) {
        guest.moveGuest(to: targetTableSession)
        self.updateGUI()
    }
    
    func didChoose(targetTable: TablesTable, forSession session: TableSessionTable) {
        TableSessionTable.moveTableSessionTo(targetTable: targetTable, currentSession: session)
        self.updateGUI()
    }
}

// Delegate of Checkout module that allows user to calculate final check
extension TableUIViewController: CheckoutDelegate {
    func didPerformCheckout(totalAmount: Float, discount: Int16, tips: Float) {
        do {
            try TableSessionTable.checkout(tableSession: currentTableSession!, totalAmount: totalAmount, discount: discount, tips: tips)
        } catch {
            CommonAlert.shared.show(title: "Failed to close session", text: error.localizedDescription)
        }
        self.updateGUI()
        self.navigationController?.popViewController(animated: true)
    }
}
