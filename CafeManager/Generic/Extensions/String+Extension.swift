//
//  String+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 30.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

extension String {
    /// Transforms string to Float if possible, if not - returns nil
    func getFloatNumber() -> Float? {
        let numberFormatter = NumberFormatter()
        if self.contains(",") {
            numberFormatter.decimalSeparator = ","
        } else {
            numberFormatter.decimalSeparator = "."
        }
        
        if let number = numberFormatter.number(from: self) {
            return Float (truncating: number)
        }
        
        return nil
    }
    
    /// Transforms string to Integer if possible, if not - returns nil
    func getIntNumber() -> Int? {
        let numberFormatter = NumberFormatter()
        if self.contains(",") {
            numberFormatter.decimalSeparator = ","
        } else {
            numberFormatter.decimalSeparator = "."
        }
        
        if let number = numberFormatter.number(from: self) {
            return Int(truncating: number)
        }
        
        return nil
    }
    
    /// Converts string to date with given date format
    func convertToDate(withFormat dateFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: self)
        return date
    }
    /// Converts string to date with short date style format
    func convertToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.date(from: self)
    }
}

