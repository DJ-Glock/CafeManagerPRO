//
//  PeriodPickerPresenter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 11.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//
import UIKit

class PeriodPickerPresenter: NSObject, PeriodPickerPresenterInterface {
    var router: PeriodPickerRouter?
    weak var view: PeriodPickerViewController!
    var startCustomDate: Date?
    var endCustomDate: Date?
    
    // Ingoing
    func configureDatePickers(startDateLimit: Date?, endDateLimit: Date?, currentStartDate: Date?, currentEndDate: Date?) {
        //Setting date pickers limits
        view.startDatePicker.minimumDate = startDateLimit
        view.endDatePicker.minimumDate = startDateLimit
        view.startDatePicker.maximumDate = endDateLimit
        view.endDatePicker.maximumDate = endDateLimit

        //Setting current dates
        view.startDatePicker.date = currentStartDate ?? Date()
        view.endDatePicker.date = currentEndDate ?? Date()
    }
    
    // Outgoing
    func dismissPeriodPicker() {
        router?.dismissPeriodPicker()
    }
    
    func didChoosePeriod() {
        router?.periodPickerDidChoosePeriod(startDate: startCustomDate ?? Date(), endDate: endCustomDate ?? Date())
    }
}
