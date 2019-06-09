//
//  PeriodPickerInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol PeriodPickerInterface {
    /// Delegate should be set to owner. Owner should conform to protocol PeriodPickerDelegate
    var delegate: PeriodPickerDelegate! {get set}
    
    /// Method shows view with date pickers with or without given parameters (optional)
    /// - Parameter startDateLimit - limit for start date. It prohibits to select start date before this value
    /// - Parameter endDateLimit   - limit for end date. It prohibits to select end date after this value
    /// - Parameter currentStartDate - default value for start date picker
    /// - Parameter currentEndDate - default value for end date picker
    func choosePeriodWithParams(startDateLimit: Date?,
                                endDateLimit: Date?,
                                currentStartDate: Date?,
                                currentEndDate: Date?,
                                sender: AnyObject)
}
