//
//  TablesTableViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 09.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData

class TablesTableViewController: FetchedResultsTableViewController {
    // MARK: variables
//    private var fetchedResultsController: NSFetchedResultsController<TablesTable>?
    private var currentTable: TablesTable?
    private var currentTableSession: TableSessionTable?
    private var tablesArray: [TablesTable] = []
    private var tableNameTextField: UITextField!
    private var tableCapacityTextField: UITextField!
    internal var tableViewRefreshControl: UIRefreshControl?
    
    // MARK: IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: IBFunctions
    @IBAction func addTableBarButtonPressed(_ sender: UIBarButtonItem) {

        // Testing zone

        
        for table in self.tablesArray {
            print("\nTableName:")
            print(table.tableName)
            print("Opened at:")
            print(table.tableSession?.openTime)
            print("Guests count:")
            print(table.tableSession?.guests.count)
            print("First guest name:")
            print(table.tableSession?.guests[0].guestName)
            print("First guest orders count:")
            print(table.tableSession?.guests[0].orders.count)
            print("First guest first order name:")
            print(table.tableSession?.guests[0].orders[0].menuItem.itemName)
            print("First guest first order qty:")
            print(table.tableSession?.guests[0].orders[0].quantityOfItems)
            print("Other orders count:")
            print(table.tableSession?.orderedItems.count)
            print("First order name:")
            print(table.tableSession?.orderedItems[0].menuItem.itemName)
        }
        
    }
    
    
    //MARK: system functions for view
    override func viewWillAppear(_ animated: Bool) {
        updateGUI()
    }
    
    // MARK: Functions
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        configureRefreshControl()
    }
    
    // Menu
    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    
    // TableView refresh control
    func configureRefreshControl () {
     self.tableViewRefreshControl = UIRefreshControl()
    
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = tableViewRefreshControl
        } else {
            tableView.addSubview(tableViewRefreshControl!)
        }
        tableViewRefreshControl?.addTarget(self, action: #selector(self.updateGUI), for: .valueChanged)
    }
    
    //Functions for Alert window for adding table
    private func configureTableNameTextField (textField: UITextField!) {
        textField.keyboardType = .default
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.darkGray
        textField.placeholder = NSLocalizedString("tableName", comment: "")
        tableNameTextField = textField
    }
    private func configureTableCapacityTextField (textField: UITextField!) {
        textField.keyboardType = .numberPad
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.darkGray
        textField.placeholder = NSLocalizedString("tableCapacity", comment: "")
        tableCapacityTextField = textField
    }
    
    private func showAlertParamsNotFilledProperly() {
        let alertNoCanDo = UIAlertController(title: NSLocalizedString("alertNoCanDo", comment: ""), message: NSLocalizedString("paramsNotFilledProperly", comment: ""), preferredStyle: .alert)
        alertNoCanDo.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
        self.presentAlert(alert: alertNoCanDo, animated: true)
    }
    
    private func showAlertUnableToSave() {
        let alertNoCanDo = UIAlertController(title: NSLocalizedString("alertUnableToSaveData", comment: ""), message: NSLocalizedString("checkInputParameters", comment: ""), preferredStyle: .alert)
        alertNoCanDo.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
        self.presentAlert(alert: alertNoCanDo, animated: true)
    }
    
    //Functions for managing tables
    private func addTable() {
        let alert = UIAlertController(title: NSLocalizedString("inputTableParams", comment: ""), message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: configureTableNameTextField)
        alert.addTextField(configurationHandler: configureTableCapacityTextField)
        alert.textFields?[0].autocapitalizationType = .sentences
        alert.textFields?[1].autocapitalizationType = .sentences
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .default, handler: { (UIAlertAction) in
            if self.tableNameTextField.text == "" || self.tableCapacityTextField.text == "" {
                self.showAlertParamsNotFilledProperly()
                return
            }
            if let capacity = self.tableCapacityTextField.text!.getIntNumber() {
                let newTable = Table(tableName: self.tableNameTextField.text!, tableCapacity: capacity)
                let result = try? TablesTable.getOrCreateTable(table: newTable)
                if result != nil {
                    self.updateGUI()
                }
            } else {
                self.showAlertParamsNotFilledProperly()
                return
            }
        }))
        self.presentAlert(alert: alert, animated: true)
    }
    
    private func editTable (table: TablesTable) {
        let alert = UIAlertController(title: NSLocalizedString("inputTableParams", comment: ""), message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: configureTableNameTextField)
        alert.textFields?[0].text = table.tableName
        alert.textFields?[0].autocapitalizationType = .sentences
        alert.addTextField(configurationHandler: configureTableCapacityTextField)
        alert.textFields?[1].text = String(describing: table.tableCapacity)
        alert.textFields?[1].autocapitalizationType = .sentences
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .default, handler: { (UIAlertAction) in
            if self.tableNameTextField.text == "" || self.tableCapacityTextField.text == "" {
                self.showAlertParamsNotFilledProperly()
                return
            }
            if let capacity = self.tableCapacityTextField.text!.getIntNumber() {
                let changedTable = Table(tableName: self.tableNameTextField.text!, tableCapacity: capacity)
                table.changeTable(to: changedTable)
                self.updateGUI()
            } else {
                self.showAlertParamsNotFilledProperly()
                return
            }
        }))
        self.presentAlert(alert: alert, animated: true)
    }

    
    //MARK: functions for table update
    @objc private func updateGUI () {
//        let request : NSFetchRequest<TablesTable> = TablesTable.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "tableName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
//        fetchedResultsController = NSFetchedResultsController<TablesTable>(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
        self.tableViewRefreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TablesTableViewCell
//        if let tablesTable = fetchedResultsController?.object(at: indexPath) {
//            currentTableSession = TableSessionTable.getCurrentTableSession(table: tablesTable)
//            cell.tableNameLabel.text = tablesTable.tableName
//            if currentTableSession != nil {
//                cell.tableStatusLabel.textColor = ColorThemes.textColorNormal
//                cell.tableStatusLabel.text = NSLocalizedString("tableOpened", comment: "") + "\(currentTableSession!.openTime!.convertToString())"
//                cell.currentAmountLabel.text = NSLocalizedString("amount", comment: "") + " \(String(describing: TableSessionTable.calculateTotalAmount(currentTableSession: currentTableSession)))" + UserSettings.currencySymbol
//            } else {
//                cell.tableStatusLabel.textColor = ColorThemes.textColorNormal
//                cell.tableStatusLabel.text = NSLocalizedString("tableIsClosed", comment: "")
//                cell.currentAmountLabel.text = ""
//            }
//        }
        return cell
    }
    //Functions for Edit/Delete swipe buttons
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
//            let table = self.fetchedResultsController?.object(at: editActionsForRowAt)
//            let alert = UIAlertController(title: NSLocalizedString("confirmTableDeletion", comment: ""), message: NSLocalizedString("confirmTableDeletionMessage", comment: ""), preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: NSLocalizedString("alertDelete", comment: ""), style: .destructive, handler: { (UIAlertAction) in
//                table!.remove()
//                self.updateGUI()
//            }))
//            self.presentAlert(alert: alert, animated: true)
        }
        deleteButton.backgroundColor = .red
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
//            let table = self.fetchedResultsController?.object(at: editActionsForRowAt)
//            self.editTable(table: table!)
        }
        editButton.backgroundColor = .lightGray
        
        return [deleteButton, editButton]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath as IndexPath)
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        currentTable = fetchedResultsController?.object(at: indexPath)
//        currentTableSession = TableSessionTable.getCurrentTableSession(table: currentTable!)
//        performSegue(withIdentifier: "openTableSegue", sender: cell)
    }
    
    
    //MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openTableSegue" {
            if let tableTVC = segue.destination as? TableUIViewController {
                tableTVC.title = currentTable!.tableName
                tableTVC.tableName = currentTable!.tableName
                tableTVC.currentTable = currentTable!
                tableTVC.currentTableSession = currentTableSession
            }
        }
    }
}


// Common extension for fetchedResultsController
extension TablesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController?.sections?.count ?? 1
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let sections = fetchedResultsController?.sections, sections.count > 0 {
//            return sections[section].numberOfObjects
//        }
//        else {
//            return 0
//        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let sections = fetchedResultsController?.sections, sections.count > 0 {
//            return sections[section].name
//        }
//        else {
//            return nil
//        }
        return nil
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return fetchedResultsController?.sectionIndexTitles
        return []
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
        return 0
    }
}
