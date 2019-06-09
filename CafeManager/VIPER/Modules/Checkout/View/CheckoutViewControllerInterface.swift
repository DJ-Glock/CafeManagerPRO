//
//  CheckoutViewControllerInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 21.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CheckoutViewControllerInterface: class {
    var totalAmountTextField: UITextField! { get set }
    var discountTextField: UITextField!    { get set }
    var tipsAmountTextField: UITextField!  { get set }
}
