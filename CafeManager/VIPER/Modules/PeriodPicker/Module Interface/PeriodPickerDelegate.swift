//
//  PeriodPickerDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 11.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol PeriodPickerDelegate: class {
    /// Method returns start and end dates that were chosen by user
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date)
}
