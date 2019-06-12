//
//  TableSessionsTableViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.08.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import CoreData

class TableSessionsTableViewController: FetchedResultsTableViewController {
    
    //MARK: Variables
    var currentTable: TablesTable? = nil
    private var currentTableSession: TableSessionTable?
//    private var fetchedResultsController: NSFetchedResultsController<TableSessionTable>?
    private var overlayView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    //MARK: functions for table update
    private func updateGUI() {
        //Load all in background
        LoadingOverlay.shared.showOverlay(view: self.view)
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            [ weak self] in
            guard self != nil else { return }
            //Get data
//            var predicates: [NSPredicate] = []
//            let originalPredicate = NSPredicate(format: "closeTime <> %@", NSNull() as CVarArg)
//            //let referencePredicate = appDelegate.smStore?.predicate(for: "table", referencing: self!.currentTable!)
//            predicates.append(originalPredicate)
//            if referencePredicate != nil {
//                predicates.append(referencePredicate!)
//            }
//            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
//
//            let request : NSFetchRequest<TableSessionTable> = TableSessionTable.fetchRequest()
//            request.predicate = predicate
//            request.sortDescriptors = [NSSortDescriptor(key: "openTime", ascending: false, selector: #selector(NSDate.compare(_:)))]
//            self!.fetchedResultsController = NSFetchedResultsController<TableSessionTable>(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: "openTimeTruncatedToDay", cacheName: nil)
//            self!.fetchedResultsController?.delegate = self
//            try? self!.fetchedResultsController?.performFetch()
            
            //Back to MainQueue to update tableView
            DispatchQueue.main.async {
                // Update GUI
                self?.tableView.reloadData()
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableSessionCell", for: indexPath) as! TableSessionsTableViewCell
        
//        if let session = fetchedResultsController?.object(at: indexPath) {
//            var totalAmount:Float {
//                if session.totalAmount != -1 {
//                    return session.totalAmount
//                } else {
//                    return TableSessionTable.calculateTotalAmount(currentTableSession: session)
//                }
//            }
//            var discount: Int16 {
//                if session.totalAmount != -1 {
//                    return session.discount
//                } else {
//                    return 0
//                }
//            }
//            var tips: Float {
//                let tips = session.totalTips
//                return tips
//            }
//            cell.startTimeLabel.text = NSLocalizedString("tableOpenTime", comment: "") + session.openTime!.convertToString()
//            cell.endTimeLabel.text = NSLocalizedString("tableCloseTime", comment: "") + session.closeTime!.convertToString()
//            cell.totalAmountLabel.text = NSLocalizedString("tableTotalAmount", comment: "") + " \(String(describing: totalAmount))" + UserSettings.currencySymbol
//
//            if tips > 0 {
//                cell.totalGuestsLabel.text = NSLocalizedString("tips", comment: "") + "\(tips)" + UserSettings.currencySymbol + " " + NSLocalizedString("tableTotalGuests", comment: "") + (String(describing: GuestsTable.getAllGuestsForTableSorted(tableSession: session).count))
//            } else {
//                cell.totalGuestsLabel.text = NSLocalizedString("discount", comment: "") + "\(discount)" + "%" + " " + NSLocalizedString("tableTotalGuests", comment: "") + (String(describing: GuestsTable.getAllGuestsForTableSorted(tableSession: session).count))
//            }
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
//        currentTableSession = fetchedResultsController?.object(at: indexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        performSegue(withIdentifier: "showTableHistory", sender: cell)
    }
    
    //MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableHistory" {
            if let tableTVC = segue.destination as? HistoryTableUIViewController {
                tableTVC.title = self.currentTable!.tableName
                tableTVC.tableName = self.currentTable!.tableName
                tableTVC.currentTable = self.currentTable!
                tableTVC.currentTableSession = self.currentTableSession
            }
        }
    }
    
    //MARK: system functions for view
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateGUI()
    }
}

// Common extension for fetchedResultsController
extension TableSessionsTableViewController {
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
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
        return 0
    }
}

