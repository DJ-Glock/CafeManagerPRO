//
//  LineChartPresenter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//
import Charts

class LineChartPresenter: NSObject, LineChartPresenterInterface {
    
    weak var view: LineChartViewControllerInterface!
    var interactor: LineChartInteractorInterface!
    var router: LineChartRouterInterface!
    
    func showChart (forDataPoints dataPoints: [String], withValues values: [[Double]], andLabels labels: [String]) {
        let lineChart = view.chartView!
        
        // General charts settings
        lineChart.noDataText = "No data"
        lineChart.noDataTextColor = ColorThemes.textColorNormal
        lineChart.xAxis.labelTextColor = ColorThemes.textColorNormal
        lineChart.leftAxis.labelTextColor = ColorThemes.textColorNormal
        lineChart.rightAxis.labelTextColor = ColorThemes.textColorNormal
        lineChart.legend.textColor = ColorThemes.textColorNormal
        lineChart.tintColor = ColorThemes.tintColor
        if let font = NSUIFont(name: "HelveticaNeue", size: 14.0) {
            lineChart.noDataFont = font
            lineChart.legend.font = font
        }
        
        guard values.count > 0 && dataPoints.count > 0 else { return }
        
        lineChart.setLineChartData(xValues: dataPoints, yValues: values, labels: labels)
        
        if let dataSets = lineChart.lineData?.dataSets {
            var colors: [NSUIColor] = []
            colors = ChartColorTemplates.colorful()
            colors = colors + ChartColorTemplates.joyful()
            colors = colors + ChartColorTemplates.liberty()
            colors = colors + ChartColorTemplates.material()
            colors = colors + ChartColorTemplates.pastel()
            colors = colors + ChartColorTemplates.vordiplom()
            
            for i in 0 ..< dataSets.count {
                let dataSet = dataSets[i]
                dataSet.valueTextColor = colors[i]
                dataSet.setColor(colors[i])
                if let font = NSUIFont(name: "HelveticaNeue", size: 14.0) {
                    dataSet.valueFont = font
                }
                lineChart.legend.entries[i].formColor = colors[i]
            }

        }
    }
    
    func didPressDoneButton() {
        router.didPressDoneButton()
    }
}
