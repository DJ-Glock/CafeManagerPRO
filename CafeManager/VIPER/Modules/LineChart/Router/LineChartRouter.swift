//
//  LineChartRouter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class LineChartRouter: NSObject, LineChartInterface, LineChartRouterInterface {

    weak var presenter: LineChartPresenterInterface!
    weak var view: UIViewController!
    
    func showChart (forDataPoints dataPoints: [String], withValues values: [[Double]], andLabels labels: [String]) {
        if let topViewController = UIApplication.topViewController(){
            view.popoverPresentationController?.sourceView = topViewController.view
            topViewController.present(view, animated: true, completion: nil)
            presenter.showChart(forDataPoints: dataPoints, withValues: values, andLabels: labels)
        }
    }
    
    func didPressDoneButton() {
        view.dismiss(animated: true, completion: nil)
    }
}
