//
//  AddOrderAssembly.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class AddOrderAssembly: NSObject {
    static func assembleModule() -> AddOrderRouter {
        let router = AddOrderRouter()
        let interactor = AddOrderInteractor()
        let presenter = AddOrderPresenter()
        let view = UIStoryboard.init(name: "AddOrder", bundle: nil).instantiateViewController(withIdentifier: "AddOrderViewController") as? AddOrderViewController
        let state = AddOrderState()
        
        view?.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.presenter = presenter
        router.view = view
        router.state = state
        
        interactor.presenter = presenter
        interactor.state = state
        
        return router
    }
}
