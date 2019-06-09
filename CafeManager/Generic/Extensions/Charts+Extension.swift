//
//  BarChartView+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 25.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//
import Charts

extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        var labels: [String] = []
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
    }
    
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}

extension LineChartView {
    private class LineChartFormatter: NSObject, IAxisValueFormatter {
        var labels: [String] = []
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
    }
    
    
    func setLineChartData(xValues: [String], yValues: [[Double]], labels: [String]) {
        var chartDataSets: [LineChartDataSet] = []
        
        for i in 0..<yValues.count {
            var dataEntries: [ChartDataEntry] = []
            for j in 0..<yValues[i].count {
                let dataEntry = ChartDataEntry(x: Double(j), y: yValues[i][j])
                dataEntries.append(dataEntry)
            }
            let dataSet = LineChartDataSet(values: dataEntries, label: labels[i])
            chartDataSets.append(dataSet)
        }
        
        let chartData = LineChartData(dataSets: chartDataSets)
        
        let chartFormatter = LineChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        self.xAxis.drawLabelsEnabled = true
        
        self.xAxis.granularityEnabled = true
        // Set granularity equals to 2 to prevent crash when array contains only one xAxis label
        if xValues.count == 1 {
            self.xAxis.granularity = 2.0
        } else {
            self.xAxis.granularity = 1.0
        }
        
        self.xAxis.drawLimitLinesBehindDataEnabled = true
        self.chartDescription = nil
        self.data = chartData
    }
}
