//
//  SettingsTableViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 10.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter
import CloudKit

class SettingsTableViewController: UITableViewController {
    // Variables and constants
    private let pricePerHour: Float = 0
    private let currencies = ["USD", "EUR", "RUB", "UAH", "BYN", "NIS", "INS"]
    private var selectedCellIndexPath: IndexPath?
    private var skipCellsFromGestureRecognition = [IndexPath]()
    private let selectedCellHeight: CGFloat = 122.0
    private let unselectedCellHeight: CGFloat = 44.0
    internal var tableViewRefreshControl: UIRefreshControl?
    
    // IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var isTimeCafeSwitch: UISwitch!
    @IBOutlet weak var isDarkThemeEnabled: UISwitch!
    @IBOutlet weak var pricePerHourTextField: UITextField!
    @IBOutlet var currencyPicker: UIPickerView!
    
    // IBActions
    // UISwitches
    @IBAction func isTimeCafeSwitchValueChanged(_ sender: UISwitch) {
        UserSettings.shared.isTimeCafe = sender.isOn
        DBUpdate.updateUserSettingsAsync { (error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving setting in the Firestore: \(String(describing: error))")
            }
        }
    }
    
    @IBAction func isDarkThemeEnabledValueChanged(_ sender: UISwitch) {
        UserSettings.isDarkThemeEnabled = sender.isOn
        let alert = UIAlertController(title: NSLocalizedString("ColorThemeChangedTitle", comment: ""), message: NSLocalizedString("ColorThemeChangedMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ColorThemeChangedButton", comment: ""), style: .destructive, handler: { UIAlertAction in
            exit(0)
        }))
        self.presentAlert(alert: alert, animated: true)
    }

    @IBAction func pricePerHourTextFieldDidEdit(_ sender: UITextField) {
        UserSettings.shared.pricePerMinute = pricePerHourTextField.text!.getFloatNumber() ?? 0
        DBUpdate.updateUserSettingsAsync { (error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving setting in the Firestore: \(String(describing: error))")
            }
        }
    }
    
    // LifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        configureViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateGUI()
    }

    // MARK: Functions
    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // Configure view after loading
    private func configureViewDidLoad() {
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.setValue(ColorThemes.textColorNormal, forKey: "textColor")
        currencyPicker.isUserInteractionEnabled = false
        currencyPicker.alpha = 0.6
        
        // TableView refresh control
        configureRefreshControl()
        
        // To dismiss keyboard
        self.addGestureRecognizer()
    }
    
    // Configure view before it appears
    @objc private func updateGUI() {
        currencyPicker.selectRow(currencies.index(of: UserSettings.shared.currencyCode)!, inComponent: 0, animated: true)
        pricePerHourTextField.text = NumberFormatter.localizedString(from: NSNumber(value: UserSettings.shared.pricePerMinute), number: .decimal)
        isTimeCafeSwitch.isOn = UserSettings.shared.isTimeCafe
        isDarkThemeEnabled.isOn = UserSettings.isDarkThemeEnabled
        self.tableViewRefreshControl?.endRefreshing()
    }
    
    // TableView functions
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let reuseIdentifier = cell.reuseIdentifier
            guard reuseIdentifier != nil else {return}
            
            if reuseIdentifier == "currencyPickerTableViewCell" && self.selectedCellIndexPath == nil {
                self.skipCellsFromGestureRecognition.append(indexPath)
                self.selectedCellIndexPath = indexPath
                UIView.animate(withDuration: 0.5, animations: {
                    self.currencyPicker.isUserInteractionEnabled = true
                    self.currencyPicker.alpha = 1
                })
                tableView.beginUpdates()
                tableView.endUpdates()
            } else if reuseIdentifier == "currencyPickerTableViewCell" && self.selectedCellIndexPath != nil {
                self.selectedCellIndexPath = nil
                UIView.animate(withDuration: 0.5, animations: {
                    self.currencyPicker.isUserInteractionEnabled = false
                    self.currencyPicker.alpha = 0.6
                })
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedCellIndexPath == indexPath {
            return self.selectedCellHeight
        } else {
            return self.unselectedCellHeight
        }
    }
}

// Extension for currency UIPicker
extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserSettings.shared.currencyCode = currencies[row]
        DBUpdate.updateUserSettingsAsync { (error) in
            if let error = error {
                CommonAlert.shared.show(title: "Error occurred", text: "Error occurred while saving setting in the Firestore: \(String(describing: error))")
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: currencies[row], attributes: [NSAttributedStringKey.foregroundColor:ColorThemes.textColorNormal])
    }
}
