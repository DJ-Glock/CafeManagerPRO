//
//  CheckoutPresenter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CheckoutPresenter: NSObject, CheckoutPresenterInterface {
    // Module properties
    var router: CheckoutRouterInterface!
    var interactor: CheckoutInteractorInterface!
    weak var view: CheckoutViewControllerInterface!
    
    // Public properties
    var originalTotalAmount: Float = 0
    var currentSession: TableSession!
    
    var totalAmount: Float = 0 {
        didSet {
            currentSession.totalAmount = totalAmount
            let discount = interactor?.calculateDiscount(totalAmount: totalAmount, originalTotalAmount: originalTotalAmount) ?? 0
            let tips = interactor?.calculateTipsAmount(totalAmount: totalAmount, originalTotalAmount: originalTotalAmount) ?? 0
            view?.discountTextField?.text = String(describing: discount)
            view?.tipsAmountTextField?.text = String(describing: tips)
            self.currentSession.discount = discount
            self.currentSession.totalTips = tips
        }
    }
    var discount: Int16 = 0 {
        didSet {
            currentSession.discount = discount
            let amount = interactor?.calculateTotalAmount(originalTotalAmount: originalTotalAmount, discount: discount) ?? 0
            let tips = interactor?.calculateTipsAmount(totalAmount: totalAmount, originalTotalAmount: originalTotalAmount) ?? 0
            view?.totalAmountTextField?.text = String(describing: amount)
            view?.tipsAmountTextField?.text = String(describing: tips)
            self.currentSession.totalAmount = amount
            self.currentSession.totalTips = tips
        }
    }
    var tips: Float = 0 {
        didSet {
            if tips != oldValue {
                currentSession.totalTips = tips
            }
        }
    }

    
    // Public methods
    func configureViewWithParams(session: TableSession, originalTotalAmount: Float) {
        self.currentSession = session
        self.originalTotalAmount = originalTotalAmount
        self.totalAmount = session.totalAmount
        self.discount = session.discount
        
        // Configure GUI
        self.configureGUI()
    }
    
    func cancelButtonPressed() {
        router?.dismissCheckoutView()
    }
    
    func saveTableSession() {
        router?.didPerformCheckout(totalAmount: currentSession.totalAmount, discount: currentSession.discount, tips: currentSession.totalTips)
    }
    
    func getFloatValueFromTextField (textField: UITextField) -> Float {
        guard textField.text != "" else {CommonAlert.shared.show(title: NSLocalizedString("alertNoCanDo", comment: ""), text: NSLocalizedString("paramsNotFilledProperly", comment: "")); return 0}
        guard textField.text != nil else {CommonAlert.shared.show(title: NSLocalizedString("alertNoCanDo", comment: ""), text: NSLocalizedString("paramsNotFilledProperly", comment: "")); return 0}
        
        return textField.text!.getFloatNumber() ?? 0.0
    }
    
    // Private methods
    private func configureGUI() {
        view?.totalAmountTextField.text = String(originalTotalAmount)
        view?.tipsAmountTextField.text = String(describing: tips)
        view?.discountTextField.text = "0"
    }
}
