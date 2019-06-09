//
//  CheckoutInteractor.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CheckoutInteractor: NSObject, CheckoutInteractorInterface {
    
    func calculateDiscount(totalAmount: Float, originalTotalAmount: Float) -> Int16 {
        if totalAmount > originalTotalAmount || totalAmount == 0 && originalTotalAmount == 0 {
            return 0
        } else if totalAmount == 0 && originalTotalAmount != 0 {
            return 100
        } else {
            let a = modf(originalTotalAmount - totalAmount/originalTotalAmount)
            let discount = Int16(roundf(100*a.1))
            return discount
        }
    }
    
    func calculateTotalAmount(originalTotalAmount: Float, discount: Int16) -> Float {
        let amount = originalTotalAmount - originalTotalAmount/100*Float(discount)
        return amount
    }
    
    func calculateTipsAmount(totalAmount: Float, originalTotalAmount: Float) -> Float {
        let amount = totalAmount - originalTotalAmount
        if amount > 0 {
            return amount
        } else {
            return 0
        }
    }
    
}
