//
//  CustomGuestAssembly.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CustomGuestAssembly {
    static func assembleModule() -> CustomGuestRouter {
        let router = CustomGuestRouter()
        let interactor = CustomGuestInteractor()
        let presenter = CustomGuestPresenter()
        let viewController = UIStoryboard.init(name: "CustomGuest", bundle: nil).instantiateViewController(withIdentifier: "CustomGuestViewController") as! CustomGuestViewController
        
        viewController.presenter = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        router.presenter = presenter
        router.view = viewController
        
        interactor.presenter = presenter
        
        return router
    }
}
