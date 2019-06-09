//
//  Date+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

extension Date {
    /// Function to convert Date to String with the following format:
    /// dateStyle - short, timeStyle - short, locale - corrent.
    func convertToString () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self as Date)
    }
    
    func truncatedToDay() -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let truncatedToDay = Calendar.current.date(from: dateComponents) ?? Date()
        return truncatedToDay
    }
    
    func truncatedToMonth() -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        let truncatedToMonth = Calendar.current.date(from: dateComponents) ?? Date()
        return truncatedToMonth
    }
    
    func truncatedToYear() -> Date {
        let dateComponents = Calendar.current.dateComponents([.year], from: self)
        let truncatedToYear = Calendar.current.date(from: dateComponents) ?? Date()
        return truncatedToYear
    }
}
