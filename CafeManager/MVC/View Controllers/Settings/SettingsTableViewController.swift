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
    private let defaults = UserDefaults.standard
    private let currencies = ["USD", "EUR", "RUR", "UAH", "BYN", "NIS"]
    private var selectedCellIndexPath: IndexPath?
    private var skipCellsFromGestureRecognition = [IndexPath]()
    private let selectedCellHeight: CGFloat = 122.0
    private let unselectedCellHeight: CGFloat = 44.0
    
    // IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var isTimeCafeSwitch: UISwitch!
    @IBOutlet weak var isDarkThemeEnabled: UISwitch!
    //@IBOutlet weak var isAutoSyncEnabled: UISwitch!
    @IBOutlet weak var pricePerHourTextField: UITextField!
    @IBOutlet var currencyPicker: UIPickerView!
    @IBOutlet weak var syncStatusLabel: UILabel!
    
    // IBActions
    // UISwitches
    @IBAction func isTimeCafeSwitchValueChanged(_ sender: UISwitch) {
        UserSettings.isTimeCafe = sender.isOn
    }
    
    @IBAction func isDarkThemeEnabledValueChanged(_ sender: UISwitch) {
        UserSettings.isDarkThemeEnabled = sender.isOn
        let alert = UIAlertController(title: NSLocalizedString("ColorThemeChangedTitle", comment: ""), message: NSLocalizedString("ColorThemeChangedMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ColorThemeChangedButton", comment: ""), style: .destructive, handler: { UIAlertAction in
            exit(0)
        }))
        self.presentAlert(alert: alert, animated: true)
    }
//    @IBAction func isAutoSyncEnabledValueChanged(_ sender: UISwitch) {
//        UserSettings.isAutosyncEnabled = sender.isOn
//    }
    
    @IBAction func pricePerHourTextFieldDidEdit(_ sender: UITextField) {
        UserSettings.pricePerMinute = pricePerHourTextField.text!.getFloatNumber() ?? 0
    }
    @IBAction func runSyncButtonPressed(_ sender: UIButton) {
        self.showSyncAlert()
    }
    
    // LifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        configureViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViewWillAppear()
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
        
        // To dismiss keyboard
        self.addGestureRecognizer()
        
        // Refresh sync status
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: appDelegate.syncDidFinishNotification), object: nil, queue: nil) { notification in
            self.syncStatusLabel.text = UserSettings.syncStatus
        }
    }
    
    // Configure view before it appears
    private func configureViewWillAppear() {
        currencyPicker.selectRow(currencies.index(of: UserSettings.currency)!, inComponent: 0, animated: true)
        pricePerHourTextField.text = NumberFormatter.localizedString(from: NSNumber(value: UserSettings.pricePerMinute), number: .decimal)
        isTimeCafeSwitch.isOn = UserSettings.isTimeCafe
        isDarkThemeEnabled.isOn = UserSettings.isDarkThemeEnabled
        //isAutoSyncEnabled.isOn = UserSettings.isAutosyncEnabled
        syncStatusLabel.text = UserSettings.syncStatus
    }
    
    // Alert window to warn user about synchronization process.
    private func showSyncAlert() {
        let alert = UIAlertController(title: NSLocalizedString("synchronizationWarningTitle", comment: ""), message: NSLocalizedString("synchronizationWarningText", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("synchronizationWarningDeny", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("synchronizationWarningConfirm", comment: ""), style: .default, handler: {(UIAlertAction) in
            
            appDelegate.validateCloudKitAnd(runSync: true){}
            UserSettings.syncUserDefaults()
            self.configureViewWillAppear()
        }))
        self.presentAlert(alert: alert, animated: true)
    }
    
    // TableView functions
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
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHelpAboutSync" {
            if let helpVC = segue.destination as? HelpViewController {
                helpVC.predefinedSection = "#Sync"
            }
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
        UserSettings.currency = currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: currencies[row], attributes: [NSAttributedStringKey.foregroundColor:ColorThemes.textColorNormal])
    }
}
