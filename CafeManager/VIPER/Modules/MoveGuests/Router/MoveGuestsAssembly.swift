//
//  MoveGuestsAssembly.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class MoveGuestsAssembly: NSObject {
    static func assembleModule() -> MoveGuestsRouter {
        let router = MoveGuestsRouter()
        let interactor = MoveGuestsInteractor()
        let presenter = MoveGuestsPresenter()
        let viewController = UIStoryboard.init(name: "MoveGuests", bundle: nil).instantiateViewController(withIdentifier: "MoveGuestsViewController") as! MoveGuestsViewController
        let state = MoveGuestsState()
        
        viewController.presenter = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.state = state
        
        router.presenter = presenter
        router.view = viewController
        router.state = state
        
        interactor.state = state
        interactor.presenter = presenter
                
        return router
    }
}
