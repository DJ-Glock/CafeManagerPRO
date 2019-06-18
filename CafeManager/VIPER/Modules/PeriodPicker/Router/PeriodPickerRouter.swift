//
//  PeriodPickerWireframe.swift
//  CafeManager
//
//  Created by Denis Kurashko on 11.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class PeriodPickerRouter: NSObject, PeriodPickerRouterInterface, PeriodPickerInterface {
    
    weak var presenter: PeriodPickerPresenter!
    weak var delegate: PeriodPickerDelegate!
    weak var view : UIViewController!
    
    // Ingoing
    func choosePeriodWithParams(startDateLimit: Date?, endDateLimit: Date?, currentStartDate: Date?, currentEndDate: Date?, sender: AnyObject) {
        view.modalPresentationStyle = .popover
        if sender is UIView {
            view.popoverPresentationController?.sourceView = sender as? UIView
        } else
            if sender is UIBarButtonItem {
                view.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            } else
                if sender is UIButton {
                    let button = sender as? UIButton
                    let imageView = button?.imageView
                    view.popoverPresentationController?.sourceView = imageView
        }
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(view, animated: true, completion: nil)
            presenter.configureDatePickers(startDateLimit: startDateLimit, endDateLimit: endDateLimit, currentStartDate: currentStartDate, currentEndDate: currentEndDate)
        } 
    }
    
    // Outgoing
    func dismissPeriodPicker() {
        view.dismiss(animated: true, completion: nil)
    }
    
    func periodPickerDidChoosePeriod(startDate: Date, endDate: Date) {
        delegate.periodPickerDidChoosePeriod(startDate: startDate, endDate: endDate)
        view.dismiss(animated: true, completion: nil)
    }
}
