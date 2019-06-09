//
//  PeriodPickerWireframeInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 11.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol PeriodPickerRouterInterface {
    /// Method just dismiss view
    func dismissPeriodPicker()
    
    /// Method is called when start and end dates were selected. It calls respetive module delegate method
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date)
}
