//
//  NSDate+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

extension NSDate {
    /// Function to convert NSDate to String with the following format:
    /// dateStyle - short, timeStyle - short, locale - corrent.
    func convertToString () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self as Date)
    }
    
    /// Functions to return date in short string format for sections (Truncated to day and month)
    func getTimeStrWithDayPrecision() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: self as Date)
    }
    
    func getTimeStrWithMonthPrecision() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = "LLL yy"
        return formatter.string(from: self as Date)
    }
}

extension Date {
    func convertToString(withFormat dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self as Date)
        return date
    }
    
    /// Functions to return date in short string format for sections (Truncated to day and month)
    func getTimeStrWithDayPrecision() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: self as Date)
    }
    
    func getTimeStrWithMonthPrecision() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = "LLL yy"
        return formatter.string(from: self as Date)
    }
}

