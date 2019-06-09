//
//  LineChartViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: ParentViewController, LineChartViewControllerInterface {

    var presenter: LineChartPresenterInterface!

    @IBOutlet weak var chartView: LineChartView!
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        presenter.didPressDoneButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
