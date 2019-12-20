//
//  ReportsViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 08.06.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import Charts

class ReportsViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var menuButton:                              UIBarButtonItem!
    @IBOutlet weak var periodLabel:                             UILabel!
    @IBOutlet weak var generalTableSessionAverageDurationLabel: UILabel!
    @IBOutlet weak var generalGuestSessionAverageDurationLabel: UILabel!
    @IBOutlet weak var generalGuestsAveragePerTableLabel:       UILabel!
    @IBOutlet weak var generalAmountAverageLabel:               UILabel!
    @IBOutlet weak var generalAmountMinimumLabel:               UILabel!
    @IBOutlet weak var generalAmountMaximumLabel:               UILabel!
    @IBOutlet weak var generalProfitLabel:                      UILabel!
    @IBOutlet weak var generalGuestsCountLabel:                 UILabel!
    @IBOutlet weak var generalTableSessionsCountLabel:          UILabel!
    
    //MARK: IBActions
    @IBAction func additionalMenuButtonPressed(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController.init(title: NSLocalizedString("Please choose an option", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Day", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.getStats(period: .day)
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Month", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.getStats(period: .month)
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Year", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.getStats(period: .year)
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Custom", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            let periodPicker = PeriodPickerAssembly.assembleModule()
            periodPicker.delegate = self
            periodPicker.choosePeriodWithParams(startDateLimit: nil, endDateLimit: nil, currentStartDate: nil, currentEndDate: nil, sender: sender)
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Export", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            
            self.choosePeriodTypeForChart(sender: sender) {
                self.exportToCSV()
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("alertCancel", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
        }))

        actionSheet.popoverPresentationController?.barButtonItem = sender
        self.presentAlert(alert: actionSheet, animated: true)
    }
    
    // UI Activiry View to choose detailed period type
    private func choosePeriodTypeForChart (sender: AnyObject, completion: (() -> Swift.Void)? = nil ) {
        // Function to regenerate detailed data and closure to display the chart
        func regenerateDetailedDataAndShowChart() {
            self.model.regenerateDetailedDataForGraphs()
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
        }
        if sender is UIBarButtonItem {
            actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        }
        
        self.presentAlert(alert: actionSheet, animated: true)
    }

    //Variables and constants
    private var startCustomDate = Date()
    private var endCustomDate = Date()
    private var startDate = Date()
    private var endDate = Date()
    private let currentDayDateComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    private let currentMonthDateComponents: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
    private let currentYearDateComponents: DateComponents = Calendar.current.dateComponents([.year], from: Date())
    private var periodType: PeriodForStatistics = .day
    private var model = ReportsDataModel()

    
    //MARK: lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        configureViewDidLoad()
    }
    
    private func configureViewDidLoad() {
        tableView.delegate = self
        self.addGestureRecognizer()
        getStats(period: .day)
    }
    
    // MARK: Functions
    // Menu
    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    private func updateLabels() {
        self.periodLabel.text = self.startDate.convertToString() + "-" + self.endDate.convertToString()
        self.generalTableSessionAverageDurationLabel.text = String(self.model.generalTableSessionAverageDuration) + " min"
        self.generalGuestSessionAverageDurationLabel.text = String(self.model.generalGuestSessionAverageDuration) + " min"
        self.generalGuestsAveragePerTableLabel.text = String(self.model.generalGuestsAveragePerTable)
        self.generalAmountAverageLabel.text = String(self.model.generalAmountAverage) + UserSettings.currencySymbol
        self.generalAmountMinimumLabel.text = String(self.model.generalAmountMinimum) + UserSettings.currencySymbol
        self.generalAmountMaximumLabel.text = String(self.model.generalAmountMaximum) + UserSettings.currencySymbol
        self.generalProfitLabel.text = String(self.model.generalProfit) + UserSettings.currencySymbol
        self.generalGuestsCountLabel.text = String(self.model.generalGuestsCount)
        self.generalTableSessionsCountLabel.text = String(self.model.generalTableSessionsCount)
    }
    
    // TableView functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryView = UIView()
        let accessoryView = cell.accessoryView!
        
        if indexPath.row == 1 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedTableSessionOpenDatesString
                let values = self.model.detailedTableSessionAverageDurations
                LoadingOverlay.shared.hideOverlayView()
                let label = NSLocalizedString("Average time of table sessions", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 2 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedGuestOpenDatesString
                let values = self.model.detailedGuestsAverageDurations
                let label = NSLocalizedString("Average time of guest sessions", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 3 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedGuestOpenDatesString
                let values = self.model.detailedGuestsAverageCountPerTable
                let label = NSLocalizedString("Average number of guests per table", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 4 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedTableSessionOpenDatesString
                let values = self.model.detailedAmountAverage
                let label = NSLocalizedString("Average amount", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 5 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedTableSessionOpenDatesString
                let values = self.model.detailedAmountMinimum
                let label = NSLocalizedString("Minimum amount", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 6 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedTableSessionOpenDatesString
                let values = self.model.detailedAmountMaximum
                let label = NSLocalizedString("Maximum amount", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 7 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedTableSessionOpenDatesString
                let values = self.model.detailedProfit
                let label = NSLocalizedString("Total profit", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 8 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedGuestOpenDatesString
                let values = self.model.detailedGuestsCount
                let label = NSLocalizedString("Guests count", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 9 {
            choosePeriodTypeForChart(sender: accessoryView) {
                let keys = self.model.detailedTableSessionOpenDatesString
                let values = self.model.detailedTableSessionCount
                let label = NSLocalizedString("Table sessions count", comment: "")
                let lineChart = LineChartAssembly.assembleModule()
                lineChart.showChart(forDataPoints: keys, withValues: [values], andLabels: [label])
            }
        }
        
        if indexPath.row == 10 {
            self.performSegue(withIdentifier: "showDetailedOrdersStatistics", sender: self)
        }
    }
    
    //MARK: function to get stats
    private func getStats (period: PeriodForStatistics) {
        self.periodType = period
        
        switch period {
        case .day: startDate = Calendar.current.date(from: currentDayDateComponents)!; endDate = Date()
        case .month: startDate = Calendar.current.date(from: currentMonthDateComponents)!; endDate = Date()
        case .year: startDate = Calendar.current.date(from: currentYearDateComponents)!; endDate = Date()
        case .custom: startDate = startCustomDate; endDate = endCustomDate
        }
        
        //Load all in background
        LoadingOverlay.shared.showOverlay(view: self.view)
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            [ weak self ] in
            guard let self = self else { return }
            self.model.startDate = self.startDate
            self.model.endDate = self.endDate
            self.model.generateDataForReport()
            
            //Back to MainQueue to update GUI and chart
            DispatchQueue.main.async {
                // Update GUI
                self.updateLabels()
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailedOrdersStatistics" {
            let targetTVC = segue.destination as! OrdersStatisticsTableViewController
            targetTVC.startDate = self.startDate
            targetTVC.endDate = self.endDate
            targetTVC.periodType = self.periodType
        }
    }
}

extension ReportsViewController {
    //MARK: export stats to CSV file
    // To be rewritten
    private func exportToCSV() {
        let originalFileName = "iCafeManager_Stats_\(startDate.convertToString())-\(endDate.convertToString()).csv"
        // Replace slashes to dots to avoid issues with saving file path.
        let fileName = originalFileName.replacingOccurrences(of: "/", with: ".")
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        let csvFile = model.generateCSVFile()
        
        do {
            try csvFile.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        vc.excludedActivityTypes = [
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo,
            UIActivityType.postToTwitter,
            UIActivityType.postToFacebook,
            UIActivityType.openInIBooks,
            UIActivityType.message
        ]
        self.presentActivityVC(vc: vc, animated: true)
    }
}

extension ReportsViewController: PeriodPickerDelegate {
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date) {
        startCustomDate = startDate
        endCustomDate = endDate
        getStats(period: .custom)
    }
}
