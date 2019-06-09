//
//  ReportsDataModel.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class ReportsDataModel {
    
    // Report parameters
    var startDate:                              Date = Date()
    var endDate:                                Date = Date()
    var detailedPeriodType:                     PeriodForStatistics = .day
    
    // Variables with plain data
    var plainGuestSessionOpenDates:             [Date] = []
    var plainGuestSessionDurations:             [Double] = []
    var plainTableSessionOpenDates:             [Date] = []
    var plainTableSessionDurations:             [Double] = []
    var plainTableSessionAmounts:               [Double] = []
    
    // Arrays for statistics calculation and charts
    var detailedGuestOpenDatesString:           [String] = []
    var detailedGuestsAverageDurations:         [Double] = []
    var detailedGuestsAverageCountPerTable:     [Double] = []
    var detailedGuestsCount:                    [Double] = []

    var detailedTableSessionOpenDatesString:    [String] = []
    var detailedTableSessionAverageDurations:   [Double] = []
    var detailedTableSessionCount:              [Double] = []
    
    var detailedAmountAverage:                  [Double] = []
    var detailedAmountMinimum:                  [Double] = []
    var detailedAmountMaximum:                  [Double] = []
    var detailedProfit:                         [Double] = []
    
    // General numbers for statistics
    var generalTableSessionAverageDuration:     Double = 0.0
    var generalGuestSessionAverageDuration:     Double = 0.0
    var generalGuestsAveragePerTable:           Double  = 0
    var generalAmountAverage:                   Double = 0.0
    var generalAmountMinimum:                   Double = 0.0
    var generalAmountMaximum:                   Double = 0.0
    var generalProfit:                          Double = 0.0
    var generalGuestsCount:                     Double = 0
    var generalTableSessionsCount:              Double = 0
    
    // MARK: General function to get all numbers
    func generateDataForReport() {
        self.getPlainDataFromDatabaseForPeriod()
        self.calculateGeneralNumbersForPeriod()
        self.calculateDetailedDataForGraphs()
    }
    
    /// Function to recalculate numbers for another detailedPeriodType
    func regenerateDetailedDataForGraphs() {
        self.calculateDetailedDataForGraphs()
    }
    
    // MARK: Functions to get plain data from database
    private func getPlainDataFromDatabaseForPeriod () {
        let guestSessions = GuestsTable.getGuestSessionsTimings(from: self.startDate, to: self.endDate)
        self.plainGuestSessionDurations = guestSessions.durationsInSeconds
        self.plainGuestSessionOpenDates = guestSessions.dates
        
        let tableSessions = TableSessionTable.getTableSessionsTimingsAndAmounts(from: self.startDate, to: self.endDate)
        self.plainTableSessionDurations = tableSessions.durationsInSeconds
        self.plainTableSessionOpenDates = tableSessions.dates
        self.plainTableSessionAmounts = tableSessions.amounts
    }
    
    // MARK: Functions to calculate general numbers
    private func calculateGeneralNumbersForPeriod() {
        self.calculateTableSessionAverageDuration()
        self.calculateGuestSessionAverageDuration()
        self.calculateGuestsAveragePerTable()
        self.calculateAmountAverage()
        self.calculateAmountMaximum()
        self.calculateAmountMinimum()
        self.calculateProfit()
        self.calculateGuestsCount()
        self.calculateTotalSessionsCount()
    }
    
    private func calculateTableSessionAverageDuration() {
        let sessionsCount = self.plainTableSessionDurations.count
        if sessionsCount == 0 {
            self.generalTableSessionAverageDuration = 0
            return
        }
        
        var totalDuration: Double = 0
        for duration in self.plainTableSessionDurations {
            totalDuration += duration
        }
        
        var averageDuration = totalDuration / Double(sessionsCount)
        averageDuration = averageDuration / 60
        averageDuration = averageDuration.rounded(toPlaces: 0)
        self.generalTableSessionAverageDuration = averageDuration
    }
    
    private func calculateGuestSessionAverageDuration() {
        let sessionsCount = self.plainGuestSessionDurations.count
        if sessionsCount == 0 {
            self.generalGuestSessionAverageDuration = 0
            return
        }
        
        var totalDuration: Double = 0
        for duration in self.plainGuestSessionDurations {
            totalDuration += duration
        }
        
        var averageDuration = totalDuration / Double(sessionsCount)
        averageDuration = averageDuration / 60
        averageDuration = averageDuration.rounded(toPlaces: 0)
        self.generalGuestSessionAverageDuration = averageDuration
    }
    
    private func calculateGuestsAveragePerTable() {
        let sessionsCount = self.plainTableSessionDurations.count
        if sessionsCount == 0 {
            self.generalGuestsAveragePerTable = 0
            return
        }
        
        let totalGuests = self.plainGuestSessionDurations.count
        var  average = round(Double(totalGuests) / Double(sessionsCount))
        average = average.rounded(toPlaces: 2)
        self.generalGuestsAveragePerTable = average
    }
    
    private func calculateAmountAverage() {
        let sessionsCount = self.plainTableSessionAmounts.count
        if sessionsCount == 0 {
            self.generalAmountAverage = 0
            return
        }
        
        var totalAmount: Double = 0.0
        for sessionAmount in self.plainTableSessionAmounts {
            totalAmount += sessionAmount
        }
        
        var averageAmountPerPeriod = totalAmount / Double(sessionsCount)
        averageAmountPerPeriod = averageAmountPerPeriod.rounded(toPlaces: 2)
        self.generalAmountAverage = averageAmountPerPeriod
    }
    
    private func calculateAmountMinimum() {
        var minimumAmount = self.plainTableSessionAmounts.min() ?? 0
        minimumAmount = minimumAmount.rounded(toPlaces: 2)
        self.generalAmountMinimum = minimumAmount
    }
    
    private func calculateAmountMaximum() {
        var maximumAmount = self.plainTableSessionAmounts.max() ?? 0
        maximumAmount = maximumAmount.rounded(toPlaces: 2)
        self.generalAmountMaximum = maximumAmount
    }
    
    private func calculateProfit() {
        let sessionAmounts = self.plainTableSessionAmounts
        let sessionsCount = sessionAmounts.count
        if sessionsCount == 0 {
            self.generalProfit = 0
            return
        }
        
        var totalProfit: Double = 0.0
        for sessionAmount in sessionAmounts {
            totalProfit += Double(sessionAmount)
        }
        totalProfit = totalProfit.rounded(toPlaces: 2)
        self.generalProfit = totalProfit
    }
    
    private func calculateGuestsCount() {
        let totalGuests = Double(self.plainGuestSessionDurations.count)
        self.generalGuestsCount = totalGuests
    }
    
    private func calculateTotalSessionsCount() {
        let totalSessions = Double(self.plainTableSessionDurations.count)
        self.generalTableSessionsCount = totalSessions
    }
    
    // MARK: Functions to calculate data for graphs
    private func calculateDetailedDataForGraphs() {
        self.calculateDetailedGuestsAverageDurations()
        self.calculateDetailedTableSessionAverageDurations()
        self.calculateDetailedTableSessionCount()
        self.calculateDetailedGuestsCount()
        self.calculateDetailedGuestsAverageCountPerTable()
        self.calculateDetailedAmountAverage()
        self.calculateDetailedAmountMinimum()
        self.calculateDetailedAmountMaximum()
        self.calculateDetailedProfit()
    }
    
    private func calculateDetailedTableSessionAverageDurations() {
        var result: [Date:Double] = [:]
        
        let durationsPerPeriod = self.plainTableSessionDurations
        let openDatesPerPeriod = self.plainTableSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        
        var allPeriodTypesDurations: [Date:Double] = [:]
        var allPeriodTypesCounts: [Date:Int] = [:]
        
        for i in 0 ..< openDatesPerPeriod.count {
            let currentOpenDate = openDatesPerPeriod[i]
            let currentDuration = durationsPerPeriod[i]
            
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let durationInMinutes = currentDuration / 60
            let currentValue = allPeriodTypesDurations[truncatedOpenTime] ?? 0
            allPeriodTypesDurations[truncatedOpenTime]  = currentValue + durationInMinutes
            
            let currentCount = allPeriodTypesCounts[truncatedOpenTime] ?? 0
            allPeriodTypesCounts[truncatedOpenTime] = currentCount + 1
        }
        
        for currentDuration in allPeriodTypesDurations {
            let duration = currentDuration.value
            let date = currentDuration.key
            let count = allPeriodTypesCounts[date] ?? 1
            var averageDuration = duration / Double(count)
            averageDuration = averageDuration.rounded(toPlaces: 2)
            
            result [date] = averageDuration
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedTableSessionOpenDatesString = formattedResult.keys
        self.detailedTableSessionAverageDurations = formattedResult.values
    }
    
    private func calculateDetailedGuestsAverageDurations() {
        var result: [Date:Double] = [:]
        
        let durationsPerPeriod = self.plainGuestSessionDurations
        let openDatesPerPeriod = self.plainGuestSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        
        var allPeriodTypesDurations: [Date:Double] = [:]
        var allPeriodTypesCounts: [Date:Int] = [:]
        
        for i in 0 ..< openDatesPerPeriod.count {
            let currentOpenDate = openDatesPerPeriod[i]
            let currentDuration = durationsPerPeriod[i]
            
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let durationInMinutes = currentDuration / 60
            let currentValue = allPeriodTypesDurations[truncatedOpenTime] ?? 0
            allPeriodTypesDurations[truncatedOpenTime]  = currentValue + durationInMinutes
            
            let currentCount = allPeriodTypesCounts[truncatedOpenTime] ?? 0
            allPeriodTypesCounts[truncatedOpenTime] = currentCount + 1
        }
        
        for currentDuration in allPeriodTypesDurations {
            let duration = currentDuration.value
            let date = currentDuration.key
            let count = allPeriodTypesCounts[date] ?? 1
            var averageDuration = duration / Double(count)
            averageDuration = averageDuration.rounded(toPlaces: 2)
            result [date] = averageDuration
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedGuestOpenDatesString = formattedResult.keys
        self.detailedGuestsAverageDurations = formattedResult.values
    }
    
    private func calculateDetailedTableSessionCount() {
        var result : [Date:Double] = [:]
        let tableSessionOpenDates = self.plainTableSessionOpenDates
        guard tableSessionOpenDates.count != 0 else {return}
        
        for currentOpenDate in tableSessionOpenDates {
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let currentValue = result[truncatedOpenTime] ?? 0.0
            result[truncatedOpenTime] = currentValue + 1
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedTableSessionCount = formattedResult.values
    }
    
    private func calculateDetailedGuestsCount() {
        var result : [Date:Double] = [:]
        let guestSessionOpenDates = self.plainGuestSessionOpenDates
        guard guestSessionOpenDates.count != 0 else {return}
        
        for currentOpenDate in guestSessionOpenDates {
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let currentValue = result[truncatedOpenTime] ?? 0.0
            result[truncatedOpenTime] = currentValue + 1
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedGuestsCount = formattedResult.values
    }
    
    private func calculateDetailedGuestsAverageCountPerTable() {
        var result: [Date:Double] = [:]
        
        let guestOpenDates = self.plainGuestSessionOpenDates
        let sessionOpenDates = self.plainTableSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        
        var guestsCounts : [Date:Double] = [:]
        
        for currentOpenDate in guestOpenDates {
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let currentValue = guestsCounts[truncatedOpenTime] ?? 0.0
            guestsCounts[truncatedOpenTime] = currentValue + 1
        }
        
        var sessionsCounts: [Date:Double] = [:]
        for currentOpenDate in sessionOpenDates {
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let currentValue = sessionsCounts[truncatedOpenTime] ?? 0
            sessionsCounts[truncatedOpenTime] = currentValue + 1
        }
        
        for sessionCount in sessionsCounts {
            let currentDate = sessionCount.key
            let currentSessionCount = sessionCount.value
            let guestsCount = guestsCounts[currentDate]!
            var averageGuestsCount = guestsCount / currentSessionCount
            averageGuestsCount = averageGuestsCount.rounded(toPlaces: 2)
            result[currentDate] = averageGuestsCount
            
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedGuestsAverageCountPerTable = formattedResult.values
    }
    
    private func calculateDetailedAmountAverage() {
        var result: [Date:Double] = [:]
        
        let amountsPerPeriod = self.plainTableSessionAmounts
        let openDatesPerPeriod = self.plainTableSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        
        var allPeriodTypesAmounts: [Date:Double] = [:]
        var allPeriodTypesCounts: [Date:Int] = [:]
        
        for i in 0 ..< openDatesPerPeriod.count {
            let currentOpenDate = openDatesPerPeriod[i]
            let currentAmount = amountsPerPeriod[i]
            
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            let value = allPeriodTypesAmounts[truncatedOpenTime] ?? 0
            allPeriodTypesAmounts[truncatedOpenTime]  = value + currentAmount
            
            let currentCount = allPeriodTypesCounts[truncatedOpenTime] ?? 0
            allPeriodTypesCounts[truncatedOpenTime] = currentCount + 1
        }
        
        for currentAmount in allPeriodTypesAmounts {
            let amount = currentAmount.value
            let date = currentAmount.key
            let count = allPeriodTypesCounts[date] ?? 1
            var averageAmount = amount / Double(count)
            averageAmount = averageAmount.rounded(toPlaces: 2)
            result [date] = averageAmount
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedAmountAverage = formattedResult.values
    }
    
    private func calculateDetailedAmountMinimum() {
        let sessionAmounts = self.plainTableSessionAmounts
        let sessionOpenDates = self.plainTableSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        
        var result: [Date:Double] = [:]
        
        for i in 0 ..< sessionOpenDates.count {
            let currentOpenDate = sessionOpenDates[i]
            let currentAmount = sessionAmounts[i].rounded(toPlaces: 2)
            
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            if let value = result[truncatedOpenTime] {
                if currentAmount < value {
                    result[truncatedOpenTime] = currentAmount
                }
            } else {
                result[truncatedOpenTime] = currentAmount
            }
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedAmountMinimum = formattedResult.values
    }
    
    private func calculateDetailedAmountMaximum() {
        let sessionAmounts = self.plainTableSessionAmounts
        let sessionOpenDates = self.plainTableSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        
        var result: [Date:Double] = [:]
        
        for i in 0 ..< sessionOpenDates.count {
            let currentOpenDate = sessionOpenDates[i]
            let currentAmount = sessionAmounts[i].rounded(toPlaces: 2)
            
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            if let value = result[truncatedOpenTime] {
                if currentAmount > value {
                    result[truncatedOpenTime] = currentAmount
                }
            } else {
                result[truncatedOpenTime] = currentAmount
            }
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedAmountMaximum = formattedResult.values
    }
    
    private func calculateDetailedProfit() {
        let sessionAmounts = self.plainTableSessionAmounts
        let sessionOpenDates = self.plainTableSessionOpenDates
        let detailedPeriodType = self.detailedPeriodType
        guard sessionOpenDates.count != 0 else {return}
        
        var result : [Date:Double] = [:]
        for i in 0 ..< sessionOpenDates.count {
            let currentOpenDate = sessionOpenDates[i]
            let currentAmount = sessionAmounts[i]
            
            var truncatedOpenTime: Date
            switch detailedPeriodType {
            case .day:  truncatedOpenTime = currentOpenDate.truncatedToDay()
            case .month:truncatedOpenTime = currentOpenDate.truncatedToMonth()
            default:    truncatedOpenTime = currentOpenDate.truncatedToDay()
            }
            
            var currentValue = result[truncatedOpenTime] ?? 0
            currentValue = currentValue.rounded(toPlaces: 2)
            result[truncatedOpenTime] = currentValue + Double(currentAmount)
        }
        
        let formattedResult = self.sortAndCovertToString(for: result)
        self.detailedProfit = formattedResult.values
    }
    
    
    // Function to sort and format data for charts
    private func sortAndCovertToString<T>(for inputDictionary: [Date:T]) -> (keys: [String], values: [T]) {
        let periodType = self.detailedPeriodType
        var dates = Array(inputDictionary.keys)
        var keys: [String] = []
        var values: [T] = []
        
        dates = dates.sorted()
        for date in dates {
            var truncatedOpenTime: String = ""
            switch periodType {
            case .day:  truncatedOpenTime = date.getTimeStrWithDayPrecision()
            case .month:truncatedOpenTime = date.getTimeStrWithMonthPrecision()
            default:    truncatedOpenTime = date.getTimeStrWithDayPrecision()
            }
            
            keys.append(truncatedOpenTime)
            let value = inputDictionary[date]!
            values.append(value)
        }
        
        
        return (keys, values)
    }
    
    private func calculateFormattedValues<T>(for inputDictionary: [String : T]) -> (keys: [String], values: [T]) {
        let periodType = self.detailedPeriodType
        
        var datesInStringFormat = Array(inputDictionary.keys)
        var dates: [Date] = []
        
        // Convert to date to sort dates properly and convert back to string for displaying
        if periodType == .month {
            for string in datesInStringFormat {
                if let date = string.convertToDate(withFormat: "LLL yy") {
                    dates.append(date)
                }
            }
            
            dates.sort()
            datesInStringFormat = []
            
            for date in dates {
                let string = date.convertToString(withFormat: "LLL yy")
                datesInStringFormat.append(string)
            }
        }
        
        if periodType == .day {
            for string in datesInStringFormat {
                if let date = string.convertToDate() {
                    dates.append(date)
                }
            }
            
            dates.sort()
            datesInStringFormat = []
            
            for date in dates {
                let string = date.getTimeStrWithDayPrecision()
                datesInStringFormat.append(string)
            }
        }
        
        var arrayOfValues = [T]()
        for string in datesInStringFormat {
            arrayOfValues.append(inputDictionary[string]!)
        }
        return (keys: datesInStringFormat, values: arrayOfValues)
    }
    
    // Function to generate CSV file
    func generateCSVFile() -> String {
        
        var csvFile = ""
        // Adding Byte Order Mark for Excel
        let BOM = "\u{FEFF}"
        
        let header = "\(NSLocalizedString("Date;Value", comment: ""))\n"
        csvFile.append(BOM)
        csvFile.append(header)
        
        //Add basic stats:
        var generalStats = [String]()
        
        generalStats.append(NSLocalizedString("Average time of table sessions\n", comment: ""))
        for i in 0..<detailedTableSessionOpenDatesString.count {
            let key = detailedTableSessionOpenDatesString[i]
            let value = detailedTableSessionAverageDurations[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Average time of guest sessions\n", comment: ""))
        for i in 0..<detailedGuestOpenDatesString.count {
            let key = detailedGuestOpenDatesString[i]
            let value = detailedGuestsAverageDurations[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Average number of guests per table\n", comment: ""))
        for i in 0..<detailedGuestOpenDatesString.count {
            let key = detailedGuestOpenDatesString[i]
            let value = detailedGuestsAverageCountPerTable[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Average amount\n", comment: ""))
        for i in 0..<detailedTableSessionOpenDatesString.count {
            let key = detailedTableSessionOpenDatesString[i]
            let value = detailedAmountAverage[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Minimum amount\n", comment: ""))
        for i in 0..<detailedTableSessionOpenDatesString.count {
            let key = detailedTableSessionOpenDatesString[i]
            let value = detailedAmountMinimum[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Maximum amount\n", comment: ""))
        for i in 0..<detailedTableSessionOpenDatesString.count {
            let key = detailedTableSessionOpenDatesString[i]
            let value = detailedAmountMaximum[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Total profit\n", comment: ""))
        for i in 0..<detailedTableSessionOpenDatesString.count {
            let key = detailedTableSessionOpenDatesString[i]
            let value = detailedProfit[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Guests count\n", comment: ""))
        for i in 0..<detailedGuestOpenDatesString.count {
            let key = detailedGuestOpenDatesString[i]
            let value = detailedGuestsCount[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        generalStats.append(NSLocalizedString("Table sessions count\n", comment: ""))
        for i in 0..<detailedTableSessionOpenDatesString.count {
            let key = detailedTableSessionOpenDatesString[i]
            let value = detailedTableSessionCount[i]
            let string = "\(key);\(value)\n"
            generalStats.append(string)
        }
        
        for line in generalStats {
            csvFile.append(line)
        }
        
        return csvFile
    }
    
}
