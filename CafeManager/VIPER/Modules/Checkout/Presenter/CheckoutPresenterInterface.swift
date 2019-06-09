//
//  CheckoutPresenterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CheckoutPresenterInterface: class {
    /// Method present view with given parameters
    func configureViewWithParams(session: TableSession, originalTotalAmount: Float)
    
    /// Method is getting called when cancel button pressed
    func cancelButtonPressed()
    
    /// Method is getting called when checkout was performed
    func saveTableSession()
    
    /// Method returns Float value from given textField
    func getFloatValueFromTextField (textField: UITextField) -> Float
}
