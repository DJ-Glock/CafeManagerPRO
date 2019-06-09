//
//  LineChartAddembly.swift
//  CafeManager
//
//  Created by Denis Kurashko on 22.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class LineChartAssembly: NSObject {
    static func assembleModule() -> LineChartRouter {
        let router = LineChartRouter()
        let interactor = LineChartInteractor()
        let presenter = LineChartPresenter()
        let view = UIStoryboard.init(name: "LineChart", bundle: nil).instantiateViewController(withIdentifier: "LineChartViewController") as! LineChartViewController
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.presenter = presenter
        router.view = view
        
        interactor.presenter = presenter
        
        return router
    }
}
