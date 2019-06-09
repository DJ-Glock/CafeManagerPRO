//
//  PeriodPickerPresenterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 11.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol PeriodPickerPresenterInterface {
    /// Method configures two date pickers with params
    /// - Parameter startDateLimit - limit for start date. It prohibits to select start date before this value
    /// - Parameter endDateLimit   - limit for end date. It prohibits to select end date after this value
    /// - Parameter currentStartDate - default value for start date picker
    /// - Parameter currentEndDate - default value for end date picker
    func configureDatePickers (startDateLimit: Date?, endDateLimit: Date?, currentStartDate: Date?, currentEndDate: Date?)
    
    /// Methos dismiss presenter view
    func dismissPeriodPicker()
    
    /// Method is called when period was chosen. It calls Router to close view and send data to delegate
    func didChoosePeriod()
}
