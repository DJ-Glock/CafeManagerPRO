//
//  OrdersStatisticsModel.swift
//  CafeManager
//
//  Created by Denis Kurashko on 26.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class OrdersStatisticsModel: NSObject {
    // Report parameters
    var startDate:                              Date = Date()
    var endDate:                                Date = Date()
    var detailedPeriodType:                     PeriodForStatistics = .day
    
    // Variables with plain data statistics
    var plainData: [String : [Date]] = [:]
    
    // Variables with general statistics
    var generalItemNames:                       [String] = []
    var generalItemCounts:                      [Int] = []
    
    // Structure for detailed item statistics
    struct DetailedItemStatistics {
        var itemName: String
        var dates: [Date]
        var datesInStringFormat: [String]
        var countOfOrders: [Date:Int]
    }
    var detailedItemsStatistics: [DetailedItemStatistics] = []
    
    // MARK: Function to get plain data from database
    func getMenuItemsStatistics() {
        self.getPlainDataFromDatabase()
        self.calculateGeneralNumbers()
        self.calculateDetailedNumbers()
    }
    
    private func getPlainDataFromDatabase() {
        self.plainData = MenuItem.getDetailedOrdersStatistics(from: self.startDate, to: self.endDate)
    }
    
    // Function to calculate general numbers
    private func calculateGeneralNumbers(){
        var generalItemNames: [String] = []
        var generalItemCounts: [Int] = []
        
        let plainDataDictionariesPerItem = self.plainData
        for itemDictionary in plainDataDictionariesPerItem {
            // Set item name for general statistics
            let itemName = itemDictionary.key
            generalItemNames.append(itemName)
            
            // Calculate total count for general statistics
            let itemDates = itemDictionary.value
            let itemsCount = itemDates.count
            generalItemCounts.append(itemsCount)
        }
        self.generalItemNames = generalItemNames
        self.generalItemCounts = generalItemCounts
    }
    
    // Function to calculate detailed numbers
    func calculateDetailedNumbers() {
        let plainDataDictionariesPerItem = self.plainData
        var detailedItemsStats: [DetailedItemStatistics] = []
        let detailedPeriodType = self.detailedPeriodType
        for itemDictionary in plainDataDictionariesPerItem {
            // Variables with itemCount and itemDatesString
            let itemName = itemDictionary.key
            var detailedItemStatistics = DetailedItemStatistics(itemName: itemName, dates: [], datesInStringFormat: [], countOfOrders: [:])
            var itemDates = itemDictionary.value
            itemDates = itemDates.sorted()
            
            for itemDate in itemDates {
                // Truncate plain date for cummulative chart
                var truncatedOpenTimeToDate: Date
                switch detailedPeriodType {
                case .day:  truncatedOpenTimeToDate = itemDate.truncatedToDay()
                case .month:truncatedOpenTimeToDate = itemDate.truncatedToMonth()
                default:    truncatedOpenTimeToDate = itemDate.truncatedToDay()
                }
                
                // Add truncated date if it has not already been added
                if !detailedItemStatistics.dates.contains(truncatedOpenTimeToDate) {
                    detailedItemStatistics.dates.append(truncatedOpenTimeToDate)
                }
                
                var value = detailedItemStatistics.countOfOrders[truncatedOpenTimeToDate] ?? 0
                value = value + 1
                detailedItemStatistics.countOfOrders[truncatedOpenTimeToDate] = value
            }
            detailedItemsStats.append(detailedItemStatistics)
        }
        self.detailedItemsStatistics = detailedItemsStats
    }
    
    // Function to get arrays with plain data for chart
    func getItemStatisticsForChart (with rowNumber: Int) -> (itemName: String, dates: [String], numbers: [Double]) {
        let detailedItemStats = self.detailedItemsStatistics[rowNumber]
        let itemName = detailedItemStats.itemName
        let itemDates = detailedItemStats.dates
        var itemDatesString: [String] = []
        let detailedPeriodType = self.detailedPeriodType
        
        for itemDate in itemDates {
            var truncatedOpenTime: String = ""
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = itemDate.getTimeStrWithDayPrecision()
            case .month:truncatedOpenTime = itemDate.getTimeStrWithMonthPrecision()
            default:    truncatedOpenTime = itemDate.getTimeStrWithDayPrecision()
            }
            
            itemDatesString.append(truncatedOpenTime)
        }
        
        var numbers: [Double] = []
        for date in itemDates {
            let number = detailedItemStats.countOfOrders[date] ?? 0
            let double = Double(number)
            numbers.append(double)
        }
        
        return (itemName, itemDatesString, numbers)
    }
    
    // Functions and variables for tableView
    var rowsCount: Int {
        return self.generalItemNames.count
    }
    
    func getRowData (rowNumber: Int) -> (itemName: String, itemValue: Int) {
        let itemName = generalItemNames[rowNumber]
        let itemValue = generalItemCounts[rowNumber]
        return (itemName, itemValue)
    }
    
    func getRowsData (rowNumbers: [Int]) -> (itemNames: [String], itemDates: [String], itemsCounts: [[Double]]) {
        var result: (itemNames: [String], itemDates: [String], itemsCounts: [[Double]]) = ([], [], [[]])
        
        let detailedItemsStatistics = self.detailedItemsStatistics
        var selectedDetailedItemsStatistics: [DetailedItemStatistics] = []
        var itemsNames: [String] = []
        var itemsDates: [Date] = []
        var itemDatesString: [String] = []
        var itemsCounts: [[Double]] = []
        
        // Get array with item statis, item names and cummulative array with dates in string format without duplicate
        for rowNumber in rowNumbers {
            let currentDetailedItemStatistics = detailedItemsStatistics[rowNumber]
            selectedDetailedItemsStatistics.append(currentDetailedItemStatistics)
            let currentItemName = currentDetailedItemStatistics.itemName
            itemsNames.append(currentItemName)
            let currentItemDates = currentDetailedItemStatistics.dates
            itemsDates = Array(Set(itemsDates + currentItemDates)).sorted()
        }
        
        for currentDetailedItemStatistics in selectedDetailedItemsStatistics {
            let currentItemDates = itemsDates
            var currentItemCounts: [Double] = []
            var originalItemCounts = currentDetailedItemStatistics.countOfOrders
            
            for currentItemDate in currentItemDates {
                let currentItemCountInt = originalItemCounts[currentItemDate] ?? 0
                let currentItemCount = Double(currentItemCountInt)
                currentItemCounts.append(currentItemCount)
            }
            itemsCounts.append(currentItemCounts)
        }
        
        for itemDate in itemsDates {
            var truncatedOpenTime: String = ""
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = itemDate.getTimeStrWithDayPrecision()
            case .month:truncatedOpenTime = itemDate.getTimeStrWithMonthPrecision()
            default:    truncatedOpenTime = itemDate.getTimeStrWithDayPrecision()
            }
            
            itemDatesString.append(truncatedOpenTime)
        }
        
        result.itemNames = itemsNames
        result.itemDates = itemDatesString
        result.itemsCounts = itemsCounts
        
        return result
    }
}
