//
//  CheckoutWireframeDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CheckoutRouterInterface: class {
    /// Method calls presenter to show view with parameters for checkout
    func checkoutWithParams(session: TableSession, originalTotalAmount: Float, sender: AnyObject)
    
    /// Method just dismiss opened view without any further actions
    func dismissCheckoutView()
    
    /// Method is getting called when checkout was performed. It calls respective module delegate for further processing
    func didPerformCheckout (totalAmount: Float, discount: Int16, tips: Float)
}
