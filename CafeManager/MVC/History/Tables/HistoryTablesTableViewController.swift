//
//  HistoryTablesTableTableViewController
//  CafeManager
//
//  Created by Denis Kurashko on 19.08.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData

class HistoryTablesTableViewController: UITableViewController {
    //MARK: variables
    //private var fetchedResultsController: NSFetchedResultsController<TablesTable>?
    private var currentTable: Table?
    private var tableNameTextField: UITextField!
    
    //MARK: system functions for view
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateGUI()
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: side menu
    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: functions for table update
    private func updateGUI () {
//        let request : NSFetchRequest<TablesTable> = TablesTable.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "tableName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
//        fetchedResultsController = NSFetchedResultsController<TablesTable>(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! HistoryTablesTableViewCell
//        if let tablesTable = fetchedResultsController?.object(at: indexPath) {
//            cell.tableNameLabel.text = tablesTable.tableName
//            cell.cellDelegate = self
//            cell.table = tablesTable
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        currentTable = fetchedResultsController?.object(at: indexPath)
        performSegue(withIdentifier: "showTableSessions", sender: cell)
    }
    
    //MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableSessions" {
            if let tableSessionsTVC = segue.destination as? TableSessionsTableViewController {
                tableSessionsTVC.title = self.currentTable!.name
                tableSessionsTVC.currentTable = self.currentTable!
            }
        }
    }
}

// MARK: Delegates
extension HistoryTablesTableViewController: HistoryTablesTableViewCellDelegate {
    func didPressTablesCellButton(table: Table) {
        currentTable = table
    }
}

// Common extension for fetchedResultsController
extension HistoryTablesTableViewController {
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
