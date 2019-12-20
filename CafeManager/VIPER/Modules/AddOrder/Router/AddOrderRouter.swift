//
//  AddOrderRouter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class AddOrderRouter: NSObject, AddOrderInterface, AddOrderRouterInterface {
    
    weak var presenter: AddOrderPresenterInterface!
    weak var delegate: AddOrderDelegate!
    weak var view: UIViewController!
    var state: AddOrderState!
    
    // Incoming
    func showMenuItemsToAddOrder(forGuest guest: Guest, sender: AnyObject) {
        showView(sender: sender)
        state.currentGuest = guest
        presenter.configureView()
    }
    
    func showMenuItemsToAddOrder(forSession session: TableSession, sender: AnyObject) {
        showView(sender: sender)
        state.currentSession = session
        presenter.configureView()
    }
    
    // Outgoing
    func didChooseMenuItem() {
        view?.dismiss(animated: true, completion: nil)
        if let guest = state.currentGuest {
            delegate.didChoose(menuItem: state.selectedMenuItem, forGuest: guest)
        } else {
            if let session = state.currentSession {
                delegate.didChoose(menuItem: state.selectedMenuItem, forSession: session)
            }
        }
    }
    
    private func showView(sender: AnyObject) {
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
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(view, animated: true, completion: nil)
            presenter.configureView()
        }
    }
}
