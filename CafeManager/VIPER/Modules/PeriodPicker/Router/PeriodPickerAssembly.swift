//
//  PeriodPickerAssembly.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class PeriodPickerAssembly: NSObject {
    static func assembleModule() -> PeriodPickerRouter {
        let router = PeriodPickerRouter()
        let presenter = PeriodPickerPresenter()
        let viewController = UIStoryboard.init(name: "PeriodPicker", bundle: nil).instantiateViewController(withIdentifier: "PeriodPickerViewController") as! PeriodPickerViewController
        
        viewController.periodPickerPresenter = presenter
        
        presenter.view = viewController
        presenter.router = router
        
        router.presenter = presenter
        router.view = viewController
        
        return router
    }
}
