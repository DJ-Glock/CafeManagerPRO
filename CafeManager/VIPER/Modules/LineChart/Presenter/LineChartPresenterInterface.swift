//
//  LineChartInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol LineChartPresenterInterface: class {
    func showChart (forDataPoints dataPoints: [String], withValues values: [[Double]], andLabels labels: [String])
    func didPressDoneButton()
}
