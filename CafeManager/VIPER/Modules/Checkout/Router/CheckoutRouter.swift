//
//  CheckoutRouter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CheckoutRouter: NSObject, CheckoutRouterInterface, CheckoutInterface {
    
    weak var presenter: CheckoutPresenterInterface!
    weak var delegate: CheckoutDelegate!
    weak var view : UIViewController!
    
    // Ingoing
    func checkoutWithParams(session: TableSession, originalTotalAmount: Float, sender: AnyObject) {
        // Present view
        view.modalPresentationStyle = .popover
        if sender is UIView {
            view.popoverPresentationController?.sourceView = sender as? UIView
        } else
            if sender is UIBarButtonItem {
                view.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            } else
                if sender is UIButton {
                    let button = sender as? UIButton
                    let imageView = button?.imageView
                    view.popoverPresentationController?.sourceView = imageView
        }
        appDelegate.window?.rootViewController?.present(view!, animated: true, completion: nil)
        presenter.configureViewWithParams(session: session, originalTotalAmount: originalTotalAmount)
    }
    
    // Outgoing
    func didPerformCheckout (totalAmount: Float, discount: Int16, tips: Float) {
        view?.dismiss(animated: true, completion: nil)
        delegate.didPerformCheckout(totalAmount: totalAmount, discount: discount, tips: tips)
    }
    
    func dismissCheckoutView() {
        view?.dismiss(animated: true, completion: nil)
    }
}
