//
//  CheckoutAssembly.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CheckoutAssembly: NSObject {
    static func assembleModule() -> CheckoutRouter {
        let wireframe = CheckoutRouter()
        let interactor = CheckoutInteractor()
        let presenter = CheckoutPresenter()
        let viewController = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        
        viewController.presenter = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = wireframe
        
        wireframe.presenter = presenter
        wireframe.view = viewController
        
        return wireframe
    }
}
