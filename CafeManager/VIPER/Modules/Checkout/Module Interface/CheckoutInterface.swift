//
//  CheckoutInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CheckoutInterface: class {
    /// Delegate should be set to onwer. Owner should conform to protocol CheckoutDelegate
    var delegate: CheckoutDelegate! {get set}
    
    /// Method opens view where user will be able to perform final checkout. Once done - newly calculated values will be returned to delegate for further processing
    func checkoutWithParams (session: TableSessionStruct, originalTotalAmount: Float, sender: AnyObject)
}
