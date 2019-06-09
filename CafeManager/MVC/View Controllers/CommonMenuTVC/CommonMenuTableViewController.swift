//
//  CommonMenuTableViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData

class CommonMenuTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: variables
    private var fetchedResultsController: NSFetchedResultsController<CommonMenuItemsTable>?
    private var isSearchActive : Bool = false
    private var filtered:[CommonMenuItemsTable] = []
    private var selectedIndexPaths: Set<IndexPath> = []
    private var invalidSelectedIndexPaths: Set<IndexPath> = []
    private var pricesForSelectedMenuItems: [IndexPath:Float] = [:]
    // Public var to select lanuage of menu
    var selectedLanguage = GenericStuff.MenuLanguage.english
    
    private func updateGUI () {
        //Load all in background
        LoadingOverlay.shared.showOverlay(view: self.view)
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            [ weak self ] in
            guard self != nil else { return }
            //Get data
            let request = NSFetchRequest<CommonMenuItemsTable>(entityName: "CommonMenuItemsTable")
            let predicate = NSPredicate(format: "itemLanguage = %@", self!.selectedLanguage.rawValue as CVarArg)
            request.predicate = predicate
            let theFirstSortDescriptor = NSSortDescriptor(key: "itemCategory", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            let theSecondSortDescriptor = NSSortDescriptor(key: "itemName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            request.sortDescriptors = [theFirstSortDescriptor, theSecondSortDescriptor]
            self!.fetchedResultsController = NSFetchedResultsController<CommonMenuItemsTable>(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: "itemCategory", cacheName: nil)
            self!.fetchedResultsController?.delegate = self
            
            try? self!.fetchedResultsController?.performFetch()
            
            //Back to MainQueue to update GUI
            DispatchQueue.main.async {
                // Update GUI
                self?.tableView.reloadData()
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureRecognizer()
        self.searchBar.delegate = self
        let rightButton = UIBarButtonItem(title: NSLocalizedString("Choose", comment: ""), style: .plain, target: self, action: #selector(showEditing))
        self.navigationItem.rightBarButtonItem = rightButton
        updateGUI()
    }
    
    @objc private func showEditing() {
        self.view.endEditing(false)
        
        // If we were selecting items, reload tableView and add items if everything is valid.
        if self.tableView.isEditing {
            if self.selectedIndexPaths.count == 0 {
                self.tableView.setEditing(!tableView.isEditing, animated: true)
                self.navigationItem.rightBarButtonItem?.title = tableView.isEditing ? NSLocalizedString("Add selected", comment: "") : NSLocalizedString("Choose", comment: "")
                self.invalidSelectedIndexPaths = []
                self.tableView.reloadData()
                return
            }
            
            self.invalidSelectedIndexPaths = []
            var menuItems: [Menu] = []
            
            // If search is active, use filtered data
            if self.isSearchActive {
                for index in selectedIndexPaths {
                    if let price = pricesForSelectedMenuItems[index] {
                        let commonMenuItem = self.filtered[index.row]
                        let menuItem = Menu(itemName: commonMenuItem.itemName!, itemDescription: commonMenuItem.itemDescription, itemPrice: price, itemCategory: commonMenuItem.itemCategory)
                        menuItems.append(menuItem)
                    } else {
                        self.invalidSelectedIndexPaths.insert(index)
                    }
                }
            } else {
                for index in selectedIndexPaths {
                    if let price = pricesForSelectedMenuItems[index] {
                        if let commonMenuItem = fetchedResultsController?.object(at: index) {
                            let menuItem = Menu(itemName: commonMenuItem.itemName!, itemDescription: commonMenuItem.itemDescription, itemPrice: price, itemCategory: commonMenuItem.itemCategory)
                            menuItems.append(menuItem)
                        }
                    } else {
                        self.invalidSelectedIndexPaths.insert(index)
                    }
                }
            }
            
            // Check if all prices are set
            if self.invalidSelectedIndexPaths.count > 0 {
                tableView.scrollToRow(at: self.invalidSelectedIndexPaths.min()!, at: .top, animated: true)
            } else {
                // Add selected menu items to database and close this view
                tableView.reloadData()
                for item in menuItems {
                    MenuTable.addMenuItem(item: item)
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            // If we were not selecting, enable tableView editing with updating table view (for formatting)
            self.tableView.setEditing(!tableView.isEditing, animated: true)
            self.navigationItem.rightBarButtonItem?.title = tableView.isEditing ? NSLocalizedString("Add selected", comment: "") : NSLocalizedString("Choose", comment: "")
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

extension CommonMenuTableViewController {
    // MARK: Table view configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! CommonMenuTableViewCell
        var menuItem: CommonMenuItemsTable?
        
        // If search is active, use another data source
        if isSearchActive {
            menuItem = filtered[indexPath.row]
        } else {
            menuItem = fetchedResultsController?.object(at: indexPath)
        }
        
        cell.currentIndexPath = indexPath
        cell.delegate = self
        cell.itemNameLabel.text = menuItem?.itemName
        cell.itemDescriptionLabel.text = menuItem?.itemDescription
        
        if let price = self.pricesForSelectedMenuItems[indexPath] {
            cell.itemPriceTextField.text = String(describing: price)
        } else {
            cell.itemPriceTextField.text = ""
        }
        
        return cell
    }
    
    // MARK: TableView editing    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CommonMenuTableViewCell
        cell.itemPriceTextField.backgroundColor = ColorThemes.uiTextFieldBackgroundColor
        
        if tableView.isEditing {
            self.selectedIndexPaths.insert(indexPath)
        }        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            self.selectedIndexPaths.remove(indexPath)
        }
    }
    
    // MARK: Table view numbers, titles, sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchActive {
            return 1
        }
        
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return filtered.count
        }
        
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearchActive {
            return nil
        }
        
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        }
        return nil
    }
}

// Delegate for cell
extension CommonMenuTableViewController: CommonMenuTableViewCellDelegate {
    func itemPriceTextFieldChangeDidEnd(indexPath: IndexPath, price: Float?) {
        if let currentPrice = price {
            self.pricesForSelectedMenuItems[indexPath] = currentPrice
        }
    }
}

// UISearchBar delegate
extension CommonMenuTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = true
        self.selectedIndexPaths = []
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.filtered.count == 0 {
            isSearchActive = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.filtered.count == 0 {
            isSearchActive = false
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtered = []
        if let objects = self.fetchedResultsController?.fetchedObjects {
            for object in objects {
                let tmp: String = object.itemName!
                if tmp.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil {
                    self.filtered.append(object)
                }
            }
            if self.filtered.count == 0 {
                self.isSearchActive = false
            } else {
                self.isSearchActive = true
            }
        }
        self.tableView.reloadData()
    }
}
