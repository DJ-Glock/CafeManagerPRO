//
//  MenuTableViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 09.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter
import SearchTextField

class MenuTableViewController: UITableViewController {
    // MARK: IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: IBActions
    @IBAction func addMenuItemBarButtonPressed(_ sender: UIBarButtonItem) {
        showActionSheet()
    }
    
    // MARK: UI variables
    private var itemNameTextField: UITextField!
    private var itemDescriptionTextField: UITextField!
    private var itemPriceTextField: UITextField!
    private var addingItemView = UIView()
    internal var tableViewRefreshControl: UIRefreshControl?
    
    // MARK: Variables
    private var selectedLanguage = GenericStuff.MenuLanguage.english
    private var isFilterApplied : Bool = false
    private var filteredMenuCategories: [String] = []
    private var filteredMenuItems: [String : [MenuItem]] = [:]
    private var menuCategories: [String] {
        return Global.shared.menuItems.keys.sorted()
    }
    private var menuItems: [String : [MenuItem]] {
        return Global.shared.menuItems
    }
    // Flag for disabling actions with tableView while adding or changing menuItem
    private var isAddingOrChangingMenuItem = false
    private var currentMenuItem: MenuItem?
    private var currentMenuItemOriginal: MenuItem?
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCommonMenu" {
            let targetVC = segue.destination as! CommonMenuTableViewController
            targetVC.selectedLanguage = self.selectedLanguage
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        updateGUI()
        self.searchBar.delegate = self
        
        configureRefreshControl()
        
        // To dismiss keyboard
        self.addGestureRecognizer()
        
        // To move view when keyboard appears/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateGUI()
    }
    
    // MARK: Action Sheet
    private func showActionSheet () {
        guard self.isAddingOrChangingMenuItem == false else {return}
        
        let actionSheet = UIAlertController.init(title: NSLocalizedString("Please choose an option", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Add manually", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            if self.tableView?.numberOfRows(inSection: 0) != 0 && self.tableView.numberOfSections > 0 {
                self.tableView?.scrollToRow(at: [0,0], at: UITableViewScrollPosition.top, animated: true)
            }
            self.addSubViewForAddingMenuItem()
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Add from catalogue (English)", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.selectedLanguage = .english
            self.performSegue(withIdentifier: "showCommonMenu", sender: self)
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Add from catalogue (Russian)", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.selectedLanguage = .russian
            self.performSegue(withIdentifier: "showCommonMenu", sender: self)
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("alertCancel", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.presentAlert(alert: actionSheet, animated: true)
    }
    
    // MARK: Side Menu
    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // MARK: GUI Update
    @objc private func updateGUI () {
        self.tableView.reloadData()
        self.tableViewRefreshControl?.endRefreshing()
    }
    
    // MARK: TableView functions
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        var menuItem: MenuItem!
        
        if isFilterApplied {
            let menuCategoryName = self.filteredMenuCategories[indexPath.section]
            guard let menuItems = self.filteredMenuItems[menuCategoryName] else {return cell}
            menuItem = menuItems[indexPath.row]
        } else {
            let menuCategoryName = self.menuCategories[indexPath.section]
            guard let menuItems = self.menuItems[menuCategoryName] else {return cell}
            menuItem = menuItems[indexPath.row]
        }
        
        cell.menuItemNameLabel.text = menuItem.name
        cell.menuItemDescriptionLabel.text = menuItem.description
        cell.menuItemPriceLabel.text = NumberFormatter.localizedString(from: NSNumber(value: menuItem!.price), number: .decimal) + UserSettings.currencySymbol
        cell.menuItem = menuItem
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let indexPath = editActionsForRowAt
        var menuItem: MenuItem!
        guard self.isAddingOrChangingMenuItem == false else {return []}
        
        if self.isFilterApplied {
            let category = self.filteredMenuCategories[indexPath.section]
            let menuItems = self.filteredMenuItems[category]
            if let item = menuItems?[indexPath.row] {
                menuItem = item
            }
        } else {
            let category = self.menuCategories[indexPath.section]
            let menuItems = self.menuItems[category]
            if let item = menuItems?[indexPath.row] {
                menuItem = item
            }
        }
        
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let alert = UIAlertController(title: NSLocalizedString("alertConfirmDeletionOfItem", comment: "") , message: NSLocalizedString("alertConfirmDeletionOfItemMessage", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("alertDelete", comment: ""), style: .destructive, handler: { (UIAlertAction) in
                self.removeMenuItem(menuItem: menuItem)
            }))
            self.presentAlert(alert: alert, animated: true)
        }
        deleteButton.backgroundColor = .red
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            if self.tableView?.numberOfRows(inSection: 0) != 0 && self.tableView.numberOfSections > 0 {
                self.tableView?.scrollToRow(at: [0,0], at: UITableViewScrollPosition.top, animated: true)
            }
            self.tableView.isEditing = false
            self.addSubViewForChangingMenuItem(menuItem: menuItem)
        }
        editButton.backgroundColor = .lightGray
        
        return [deleteButton, editButton]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFilterApplied {
            return self.filteredMenuCategories.count
        }
        return self.menuCategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterApplied {
            let category = self.filteredMenuCategories[section]
            let items = self.filteredMenuItems[category]
            return items?.count ?? 0
        }
        
        let categoryName = menuCategories[section]
        return self.menuItems[categoryName]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFilterApplied {
            return self.filteredMenuCategories[section]
        }
        
        return menuCategories[section]
    }
    
    private func configureRefreshControl () {
        self.tableViewRefreshControl = UIRefreshControl()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = tableViewRefreshControl
        } else {
            tableView.addSubview(tableViewRefreshControl!)
        }
        tableViewRefreshControl?.addTarget(self, action: #selector(self.updateGUI), for: .valueChanged)
    }
    
}

// MARK: UISearchBar
extension MenuTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFilterApplied = true
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.filteredMenuItems.count == 0 {
            isFilterApplied = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFilterApplied = false
        self.tableView.reloadData()
        self.view.endEditing(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTextLower = searchText.lowercased()
        let searchForPrice = searchText.getFloatNumber() ?? 0
        self.filteredMenuCategories = []
        self.filteredMenuItems = [:]
        
        // Filter menu items by name, description or price
        for category in self.menuCategories {
            guard let items = self.menuItems[category] else {continue}
            for item in items {
                let name = item.name.lowercased()
                let description = item.description?.lowercased() ?? ""
                let price = item.price
                
                if name.contains(searchTextLower) || description.contains(searchTextLower) || price == searchForPrice {
                    let alreadyIn = self.filteredMenuCategories.contains(category)
                    if (!alreadyIn) {
                        self.filteredMenuCategories.append(category)
                    }
                    var filtered = self.filteredMenuItems[category] ?? []
                    filtered.append(item)
                    self.filteredMenuItems[category] = filtered
                }
            }
        }
        
        // Filter categories by name if no items were filtered
        if self.filteredMenuCategories.count == 0 {
            for category in self.menuCategories {
                let name = category.lowercased()
                if name.contains(searchTextLower) {
                    self.filteredMenuCategories.append(category)
                    self.filteredMenuItems[category] = self.menuItems[category]
                }
            }
        }
        
        self.tableView.reloadData()
    }
}

extension MenuTableViewController {
    // MARK: Adding item subview
    private func addSubViewForAddingMenuItem () {
        self.isAddingOrChangingMenuItem = true
        self.currentMenuItem = MenuItem(name: "", description: nil, price: 0, category: "")
        
        let viewWidth = self.view.myCustomAlertViewWidth()
        let viewHeight = 200
        addingItemView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        let centerX = self.view.center.x
        let centerY = self.view.center.y
        let center = CGPoint(x: centerX, y: centerY)
        addingItemView.center = center
        addingItemView.backgroundColor = ColorThemes.backgroundColor
        addingItemView.layer.cornerRadius = 10
        
        let textFieldWidth = viewWidth - 40
        let buttonWidth = textFieldWidth / 2
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: textFieldWidth, height: 25))
        titleLabel.text = NSLocalizedString("alertMenuItemAddingInputParameters", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.textColor = ColorThemes.textColorNormal
        
        let itemNameTextField = UITextField(frame: CGRect(x: 20, y: 40, width: textFieldWidth, height: 25))
        itemNameTextField.becomeFirstResponder()
        itemNameTextField.placeholder = NSLocalizedString("itemName", comment: "")
        itemNameTextField.keyboardType = .default
        itemNameTextField.autocorrectionType = .no
        itemNameTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemNameTextField.layer.cornerRadius = 3
        itemNameTextField.borderStyle = .roundedRect
        itemNameTextField.clearButtonMode = .whileEditing
        itemNameTextField.adjustsFontSizeToFitWidth = true
        itemNameTextField.addTarget(self, action: #selector(assignValueToItemName), for: .editingDidEnd)
        
        let itemDescriptionTextField = UITextField(frame: CGRect(x: 20, y: 70, width: textFieldWidth, height: 25))
        itemDescriptionTextField.placeholder = NSLocalizedString("itemDescription", comment: "")
        itemDescriptionTextField.keyboardType = .default
        itemDescriptionTextField.autocorrectionType = .no
        itemDescriptionTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemDescriptionTextField.layer.cornerRadius = 3
        itemDescriptionTextField.borderStyle = .roundedRect
        itemDescriptionTextField.clearButtonMode = .whileEditing
        itemDescriptionTextField.addTarget(self, action: #selector(assignValueToItemDescription), for: .editingDidEnd)
        
        let itemPriceTextField = UITextField(frame: CGRect(x: 20, y: 100, width: textFieldWidth, height: 25))
        itemPriceTextField.placeholder = NSLocalizedString("itemPrice", comment: "")
        itemPriceTextField.keyboardType = .decimalPad
        itemPriceTextField.autocorrectionType = .no
        itemPriceTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemPriceTextField.layer.cornerRadius = 3
        itemPriceTextField.borderStyle = .roundedRect
        itemPriceTextField.clearButtonMode = .whileEditing
        itemPriceTextField.addTarget(self, action: #selector(assignValueToItemPrice), for: .editingDidEnd)
        
        let itemCategorySearchTextField = SearchTextField(frame: CGRect(x: 20, y: 130, width: textFieldWidth, height: 25))
        itemCategorySearchTextField.placeholder = NSLocalizedString("category", comment: "")
        itemCategorySearchTextField.keyboardType = .default
        itemCategorySearchTextField.autocorrectionType = .no
        itemCategorySearchTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemCategorySearchTextField.filterStrings(self.menuCategories)
        itemCategorySearchTextField.borderStyle = .roundedRect
        itemCategorySearchTextField.clearButtonMode = .whileEditing
        itemCategorySearchTextField.theme.font = UIFont.systemFont(ofSize: 14)
        itemCategorySearchTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)]
        itemCategorySearchTextField.theme.bgColor = ColorThemes.uiTextFieldBackgroundColor
        itemCategorySearchTextField.alpha = 0.9
        itemCategorySearchTextField.addTarget(self, action: #selector(assignValueToItemCategory), for: .editingDidEnd)
        
        let cancelButton = UIButton(frame: CGRect(x: 20, y: 170, width: buttonWidth, height: 20))
        cancelButton.setTitle(NSLocalizedString("alertCancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(ColorThemes.alertViewButtonTextColor, for: .normal)
        cancelButton.setTitleColor(ColorThemes.textColorDisabled, for: .highlighted)
        cancelButton.addTarget(self, action: #selector(addMenuItemCancelButtonPressed), for: .touchUpInside)
        
        let doneButtonPosition = 20 + buttonWidth
        let doneButton = UIButton(frame: CGRect(x: doneButtonPosition, y: 170, width: buttonWidth, height: 20))
        doneButton.setTitle(NSLocalizedString("alertDone", comment: ""), for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(ColorThemes.alertViewButtonTextColor, for: .normal)
        doneButton.setTitleColor(ColorThemes.buttonTextColorNormal, for: .highlighted)
        doneButton.addTarget(self, action: #selector(addMenuItemDoneButtonPressed), for: .touchUpInside)
        
        addingItemView.addSubview(titleLabel)
        addingItemView.addSubview(itemNameTextField)
        addingItemView.addSubview(itemDescriptionTextField)
        addingItemView.addSubview(itemPriceTextField)
        addingItemView.addSubview(itemCategorySearchTextField)
        addingItemView.addSubview(cancelButton)
        addingItemView.addSubview(doneButton)
        
        Overlay.shared.showOverlay(view: self.view)
        self.tableView.isScrollEnabled = false
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.searchBar.isHidden = true
            self.view.addSubview(self.addingItemView)
            self.addGestureRecognizerForSubView()
        }, completion: nil)
        self.view.bringSubview(toFront: addingItemView)
    }
    
    @objc private func addMenuItemDoneButtonPressed (sender: UIButton) {
        let senderView = sender.superview
        senderView?.endEditing(true)
        guard let item = self.currentMenuItem else {return}
        
        if item.name == "" || item.price < 0 || item.category == "" {
            self.showAlertParamsNotFilledProperly()
            return
        }
        
        var items = Global.shared.menuItems[item.category] ?? []
        items.append(item)
        Global.shared.menuItems[item.category] = items
        DBGeneral.updateMenuAndSettings()
        
        self.updateGUI()
        self.searchBar.isHidden = false
        Overlay.shared.hideOverlayView()
        self.tableView.isScrollEnabled = true
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {senderView?.removeFromSuperview()}, completion: nil)
        self.isAddingOrChangingMenuItem = false
    }
    
    @objc private func addMenuItemCancelButtonPressed (sender: UIButton) {
        let senderView = sender.superview
        self.searchBar.isHidden = false
        Overlay.shared.hideOverlayView()
        self.tableView.isScrollEnabled = true
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {senderView?.removeFromSuperview()}, completion: nil)
        self.isAddingOrChangingMenuItem = false
    }
    
    // MARK: Changing item subview
    private func addSubViewForChangingMenuItem (menuItem: MenuItem) {
        self.isAddingOrChangingMenuItem = true
        self.currentMenuItem = MenuItem(name: menuItem.name, description: menuItem.description, price: menuItem.price, category: menuItem.category)
        self.currentMenuItemOriginal = menuItem
        
        let viewWidth = self.view.myCustomAlertViewWidth()
        let viewHeight = 200
        addingItemView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        let centerX = self.view.center.x
        let centerY = (self.navigationController?.navigationBar.bounds.height)! + CGFloat(viewHeight/2)
        let center = CGPoint(x: centerX, y: centerY)
        addingItemView.center = center
        addingItemView.backgroundColor = ColorThemes.backgroundColor
        addingItemView.layer.cornerRadius = 10
        
        let textFieldWidth = viewWidth - 40
        let buttonWidth = textFieldWidth / 2
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: textFieldWidth, height: 20))
        titleLabel.text = NSLocalizedString("alertMenuItemAddingInputParameters", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.textColor = ColorThemes.textColorNormal
        
        let itemNameTextField = UITextField(frame: CGRect(x: 20, y: 40, width: textFieldWidth, height: 25))
        itemNameTextField.becomeFirstResponder()
        itemNameTextField.placeholder = NSLocalizedString("itemName", comment: "")
        itemNameTextField.text = menuItem.name
        itemNameTextField.keyboardType = .default
        itemNameTextField.autocorrectionType = .no
        itemNameTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemNameTextField.layer.cornerRadius = 3
        itemNameTextField.borderStyle = .roundedRect
        itemNameTextField.clearButtonMode = .whileEditing
        itemNameTextField.addTarget(self, action: #selector(assignValueToItemName), for: .editingDidEnd)
        
        let itemDescriptionTextField = UITextField(frame: CGRect(x: 20, y: 70, width: textFieldWidth, height: 25))
        itemDescriptionTextField.placeholder = NSLocalizedString("itemDescription", comment: "")
        itemDescriptionTextField.text = menuItem.description ?? ""
        itemDescriptionTextField.keyboardType = .default
        itemDescriptionTextField.autocorrectionType = .no
        itemDescriptionTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemDescriptionTextField.layer.cornerRadius = 3
        itemDescriptionTextField.borderStyle = .roundedRect
        itemDescriptionTextField.clearButtonMode = .whileEditing
        itemDescriptionTextField.addTarget(self, action: #selector(assignValueToItemDescription), for: .editingDidEnd)
        
        let itemPriceTextField = UITextField(frame: CGRect(x: 20, y: 100, width: textFieldWidth, height: 25))
        itemPriceTextField.placeholder = NSLocalizedString("itemPrice", comment: "")
        itemPriceTextField.text = NumberFormatter.localizedString(from: NSNumber(value: menuItem.price), number: .decimal)
        itemPriceTextField.keyboardType = .decimalPad
        itemPriceTextField.autocorrectionType = .no
        itemPriceTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemPriceTextField.layer.cornerRadius = 3
        itemPriceTextField.borderStyle = .roundedRect
        itemPriceTextField.clearButtonMode = .whileEditing
        itemPriceTextField.addTarget(self, action: #selector(assignValueToItemPrice), for: .editingDidEnd)
        
        let itemCategorySearchTextField = SearchTextField(frame: CGRect(x: 20, y: 130, width: textFieldWidth, height: 25))
        itemCategorySearchTextField.placeholder = NSLocalizedString("category", comment: "")
        itemCategorySearchTextField.text = menuItem.category
        itemCategorySearchTextField.keyboardType = .default
        itemCategorySearchTextField.autocorrectionType = .no
        itemCategorySearchTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        itemCategorySearchTextField.filterStrings(self.menuCategories)
        itemCategorySearchTextField.borderStyle = .roundedRect
        itemCategorySearchTextField.clearButtonMode = .whileEditing
        itemCategorySearchTextField.theme.font = UIFont.systemFont(ofSize: 14)
        itemCategorySearchTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)]
        itemCategorySearchTextField.theme.bgColor = ColorThemes.uiTextFieldBackgroundColor
        itemCategorySearchTextField.alpha = 0.9
        itemCategorySearchTextField.addTarget(self, action: #selector(assignValueToItemCategory), for: .editingDidEnd)
        
        let cancelButton = UIButton(frame: CGRect(x: 20, y: 170, width: buttonWidth, height: 20))
        cancelButton.setTitle(NSLocalizedString("alertCancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(ColorThemes.alertViewButtonTextColor, for: .normal)
        cancelButton.setTitleColor(ColorThemes.textColorDisabled, for: .highlighted)
        cancelButton.addTarget(self, action: #selector(changeMenuItemCancelButtonPressed), for: .touchUpInside)
        
        let doneButtonPosition = 20 + buttonWidth
        let doneButton = UIButton(frame: CGRect(x: doneButtonPosition, y: 170, width: buttonWidth, height: 20))
        doneButton.setTitle(NSLocalizedString("alertDone", comment: ""), for: .normal)
        doneButton.titleLabel?.textAlignment = .center
        doneButton.setTitleColor(ColorThemes.alertViewButtonTextColor, for: .normal)
        doneButton.setTitleColor(ColorThemes.textColorDisabled, for: .highlighted)
        doneButton.addTarget(self, action: #selector(changeMenuItemDoneButtonPressed), for: .touchUpInside)
        
        addingItemView.addSubview(titleLabel)
        addingItemView.addSubview(itemNameTextField)
        addingItemView.addSubview(itemDescriptionTextField)
        addingItemView.addSubview(itemPriceTextField)
        addingItemView.addSubview(itemCategorySearchTextField)
        addingItemView.addSubview(cancelButton)
        addingItemView.addSubview(doneButton)
        
        Overlay.shared.showOverlay(view: self.view)
        self.tableView.isScrollEnabled = false
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.searchBar.isHidden = true
            self.view.addSubview(self.addingItemView)
            self.addGestureRecognizerForSubView()
        }, completion: nil)
        self.view.bringSubview(toFront: addingItemView)
    }
    
    @objc private func changeMenuItemDoneButtonPressed (sender: UIButton) {
        let senderView = sender.superview
        senderView?.endEditing(true)
        guard let changedItem = self.currentMenuItem else {return}
        guard let originalItem = self.currentMenuItemOriginal else {return}
        
        if changedItem.name == "" || changedItem.price < 0 || changedItem.category == "" {
            self.showAlertParamsNotFilledProperly()
            return
        }
        
        var items = Global.shared.menuItems[originalItem.category] ?? []
        
        // If category was changed - remove item from old category
        if originalItem.category == changedItem.category {
            for i in 0..<items.count {
                let item = items[i]
                if item === originalItem {
                    items[i] = changedItem
                    break
                }
            }
            Global.shared.menuItems[originalItem.category] = items
        } else {
            for i in 0..<items.count {
                let item = items[i]
                if item === originalItem {
                    items.remove(at: i)
                    break
                }
            }
            // If no items left, remove category
            if items.count == 0 {
                Global.shared.menuItems.removeValue(forKey: originalItem.category)
            } else {
                Global.shared.menuItems[originalItem.category] = items
            }
            
            var newItems = Global.shared.menuItems[changedItem.category] ?? []
            newItems.append(changedItem)
            Global.shared.menuItems[changedItem.category] = newItems
        }
        
        DBGeneral.updateMenuAndSettings()
        
        self.updateGUI()
        self.searchBar.isHidden = false
        Overlay.shared.hideOverlayView()
        self.tableView.isScrollEnabled = true
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {senderView?.removeFromSuperview()}, completion: nil)
        self.isAddingOrChangingMenuItem = false
    }
    
    @objc private func changeMenuItemCancelButtonPressed (sender: UIButton) {
        let senderView = sender.superview
        self.searchBar.isHidden = false
        Overlay.shared.hideOverlayView()
        self.tableView.isScrollEnabled = true
        UIView.transition(with: self.view, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {senderView?.removeFromSuperview()}, completion: nil)
        self.isAddingOrChangingMenuItem = false
    }
    
    // MARK: TextField handlers for subviews
    @objc private func assignValueToItemName (sender: UITextField) {
        if let name = sender.text {
            self.currentMenuItem?.name = name
        }
    }
    
    @objc private func assignValueToItemDescription (sender: UITextField) {
        if let description = sender.text {
            self.currentMenuItem?.description = description
        }
    }
    
    @objc private func assignValueToItemPrice (sender: UITextField) {
        if let number = sender.text?.getFloatNumber() {
            self.currentMenuItem?.price = number
        }
    }
    
    @objc private func assignValueToItemCategory (sender: UITextField) {
        if let category = sender.text {
            self.currentMenuItem?.category = category
        }
    }
}

// MARK: Removing menu item
extension MenuTableViewController {
    private func removeMenuItem(menuItem: MenuItem) {
        let category = menuItem.category
        var items = Global.shared.menuItems[category] ?? []
        
        for i in 0..<items.count {
            let item = items[i]
            if item === menuItem {
                items.remove(at: i)
                break
            }
        }
        
        if items.count == 0 {
            Global.shared.menuItems.removeValue(forKey: category)
        } else {
            Global.shared.menuItems[category] = items
        }
        
        DBGeneral.updateMenuAndSettings()
        self.updateGUI()
    }
}

// MARK: Alert window for wrong params
extension MenuTableViewController {
    private func showAlertParamsNotFilledProperly() {
        let alertNoCanDo = UIAlertController(title: NSLocalizedString("alertNoCanDo", comment: ""), message: NSLocalizedString("paramsNotFilledProperly", comment: ""), preferredStyle: .alert)
        alertNoCanDo.addAction(UIAlertAction(title: NSLocalizedString("alertDone", comment: ""), style: .cancel, handler: nil))
        self.presentAlert(alert: alertNoCanDo, animated: true)
    }
}

// MARK: Keyboard handle
extension MenuTableViewController {
    /// Function to scroll view when keyboard appears/disappears
    @objc func keyboardWillChangeFrame (notification: NSNotification) {
        let mainViewFrame = self.view.frame
        if let userInfo = notification.userInfo {
            if let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let centerX = mainViewFrame.midX
                var centerY = mainViewFrame.midY
                
                if endFrame.minY == mainViewFrame.maxY {
                    // Keyboard is hidden
                    centerY = mainViewFrame.midY
                } else {
                    // Keyboard is opened
                    if UIDevice.current.modelName == "iPhone 4s" {
                        centerY = mainViewFrame.midY - endFrame.minY/2
                    } else {
                        centerY = mainViewFrame.midY - endFrame.minY/3
                    }
                }
                let center = CGPoint(x: centerX, y: centerY)
                
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 1
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0.1),
                               options: animationCurve,
                               animations: { self.addingItemView.center = center},
                               completion: nil)
            }
        }
    }
}

// MARK: Gesture Recognizer
extension MenuTableViewController {
    func addGestureRecognizerForSubView() {
        if let gestureRecognizers = self.addingItemView.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if recognizer is UITapGestureRecognizer {
                    return
                }
            }
        }
        
        let singleTap = UITapGestureRecognizer(target: self.addingItemView, action: nil)
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        self.addingItemView.addGestureRecognizer(singleTap)
    }
}
