//
//  PeriodPickerViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 11.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit

class PeriodPickerViewController: ParentViewController {    
    //MARK: variables
    var periodPickerPresenter: PeriodPickerPresenter?
    
    //MARK: IBOutlets
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        periodPickerPresenter?.dismissPeriodPicker()
    }
    @IBAction func startDatePickerValueChanged(_ sender: UIDatePicker) {
        periodPickerPresenter?.startCustomDate = sender.date
    }
    @IBAction func endDatePickerValueChanged(_ sender: UIDatePicker) {
        periodPickerPresenter?.endCustomDate = sender.date
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        periodPickerPresenter?.didChoosePeriod()
    }
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        changeColorTheme()
    }
    
    private func changeColorTheme() {
        cancelButton.tintColor = ColorThemes.buttonTextColorDestructive
        self.startDatePicker.setValue(ColorThemes.textColorNormal, forKey: "textColor")
        self.endDatePicker.setValue(ColorThemes.textColorNormal, forKey: "textColor")
    }
}
