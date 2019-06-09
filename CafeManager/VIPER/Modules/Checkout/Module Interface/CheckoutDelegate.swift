//
//  CheckoutDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CheckoutDelegate: class {
    /// Method is getting called when checkout is complete. It returns recalculated amount, discount and tips for table session closure
    func didPerformCheckout (totalAmount: Float, discount: Int16, tips: Float)
}
