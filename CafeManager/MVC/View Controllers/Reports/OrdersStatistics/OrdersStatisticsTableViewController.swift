//
//  OrdersStatisticsTableViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 26.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit

class OrdersStatisticsTableViewController: UITableViewController {

    @IBOutlet weak var bulkSelectionBarButton: UIBarButtonItem!
    @IBAction func bulkSelectionBarButtonPressed(_ sender: UIBarButtonItem) {
        showEditing(sender: sender)
    }
    
    var startDate = Date()
    var endDate = Date()
    var periodType: PeriodForStatistics = .day
    var detailedPeriodType: PeriodForStatistics = .day
    
    private var model = OrdersStatisticsModel()
    private var selectedIndexPaths: Set<IndexPath> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateGUI()
    }
    
    private func updateGUI() {
        //Load all in background
        LoadingOverlay.shared.showOverlay(view: self.view)
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            [ weak self ] in
            guard self != nil else { return }
            self!.model.startDate = self!.startDate
            self!.model.endDate = self!.endDate
            self!.model.detailedPeriodType = self!.detailedPeriodType
            self!.model.getMenuItemsStatistics()
            
            //Back to MainQueue to update GUI
            DispatchQueue.main.async {
                // Update GUI
                self?.tableView.reloadData()
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        
    }
    
    private func showEditing(sender: AnyObject) {
        self.view.endEditing(false)
        
        // If we were selecting items, reload tableView and show chart if anything is selected
        if self.tableView.isEditing {
            // Nothing is selected
            if self.selectedIndexPaths.count == 0 {
                self.tableView.setEditing(!tableView.isEditing, animated: true)
                let bulkSelectionText = NSLocalizedString("Bulk selection", comment: "")
                let showChartText = NSLocalizedString("Show chart", comment: "")
                self.bulkSelectionBarButton.title = tableView.isEditing ? showChartText : bulkSelectionText
                self.tableView.reloadData()
                return
            } else {
                // Show popover to choose detailed period type (if not day/month), on completion - generate data and show chart
                self.choosePeriodTypeForChart(sender: sender) {
                    var selectedRowNumbers: [Int] = []
                    for selectedIndexPath in self.selectedIndexPaths {
                        let rowNumber = selectedIndexPath.row
                        selectedRowNumbers.append(rowNumber)
                    }
                    
                    let data = self.model.getRowsData(rowNumbers: selectedRowNumbers)
                    self.selectedIndexPaths = []
                    self.tableView.endUpdates()
                    self.showEditing(sender: sender)
                    
                    let itemNames = data.itemNames
                    let itemsDates = data.itemDates
                    let itemsValues = data.itemsCounts
                    
                    let lineChart = LineChartAssembly.assembleModule()
                    lineChart.showChart(forDataPoints: itemsDates, withValues: itemsValues, andLabels: itemNames)
                }
            }
            
        } else {
            // If we were not selecting, enable tableView editing with updating table view (for formatting)
            self.tableView.setEditing(!tableView.isEditing, animated: true)
            let bulkSelectionText = NSLocalizedString("Bulk selection", comment: "")
            let showChartText = NSLocalizedString("Show chart", comment: "")
            self.bulkSelectionBarButton.title = tableView.isEditing ? showChartText : bulkSelectionText
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    // UI Activiry View to choose detailed period type
    private func choosePeriodTypeForChart (sender: AnyObject, completion: (() -> Swift.Void)? = nil ) {
        // Function to regenerate detailed data and closure to display the chart
        func regenerateDetailedDataAndShowChart() {
            self.model.calculateDetailedNumbers() 
            if let closure = completion {
                closure()
            }
        }
        
        // If selected period type is day or month - show detailed statistics for day only, bypass the selection
        if self.periodType == .day || self.periodType == .month {
            self.model.detailedPeriodType = .day
            regenerateDetailedDataAndShowChart()
            return
        }
        
        
        let actionSheet = UIAlertController.init(title: NSLocalizedString("Please choose grouping for chart", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("By day", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.model.detailedPeriodType = .day
            regenerateDetailedDataAndShowChart()
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("By month", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.model.detailedPeriodType = .month
            regenerateDetailedDataAndShowChart()
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: {(action) in
            
        }))
        
        if sender is UIView {
            actionSheet.popoverPresentationController?.sourceView = sender as? UIView
        } else
        if sender is UIBarButtonItem {
            actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        }
        
        
        self.presentAlert(alert: actionSheet, animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrdersStatisticsTableViewCell
        let rowData = model.getRowData(rowNumber: rowNumber)
        cell.itemNameLabel.text = rowData.itemName
        cell.itemValueLabel.text = String(rowData.itemValue)
        return cell
    }
    
    // MARK: TableView editing and single selection when not editing
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.isEditing {
            self.selectedIndexPaths.insert(indexPath)
        } else {
            // Show popover to choose detailed period type (if not day/month), on completion - generate data and show chart
            let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryView = UIView()
            let accessoryView = cell.accessoryView!
            
            self.choosePeriodTypeForChart(sender: accessoryView) {
                let rowNumber = indexPath.row
                let dataForChart = self.model.getItemStatisticsForChart(with: rowNumber)
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: dataForChart.dates, withValues: [dataForChart.numbers], andLabels: [dataForChart.itemName])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.tableView.isEditing {
            self.selectedIndexPaths.remove(indexPath)
        }
    }
    
}
