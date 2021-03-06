//
//  LineChartViewControllerInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//
import Charts

protocol LineChartViewControllerInterface: class {
    var chartView: LineChartView! { get set }
}
