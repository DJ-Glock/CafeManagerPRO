//
//  CheckoutInteractorInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CheckoutInteractorInterface: class {
    /// Method calculates discount for given amount and original amount
    func calculateDiscount(totalAmount: Float, originalTotalAmount: Float) -> Int16
    
    /// Method calculates amount for given discount and original amount
    func calculateTotalAmount(originalTotalAmount: Float, discount: Int16) -> Float
    
    /// Method calculates tips for given original amount and recalculated amount
    func calculateTipsAmount(totalAmount: Float, originalTotalAmount: Float) -> Float
}
