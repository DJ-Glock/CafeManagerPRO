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
    func showMenuItemsToAddOrder(forGuest guest: GuestsTable, sender: AnyObject) {
        showView(sender: sender)
        state.currentGuest = guest
        presenter.configureView()
    }
    
    func showMenuItemsToAddOrder(forSession session: TableSessionTable, sender: AnyObject) {
        showView(sender: sender)
        state.currentSession = session
        presenter.configureView()
    }
    
    // Outgoing
    func didChooseMenuItem() {
        if let guest = state.currentGuest {
            delegate.didChoose(menuItem: state.selectedMenuItem, forGuest: guest)
        } else {
            if let session = state.currentSession {
                delegate.didChoose(menuItem: state.selectedMenuItem, forSession: session)
            }
        }
        view?.dismiss(animated: true, completion: nil)
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
        
        appDelegate.window?.rootViewController?.present(view, animated: true, completion: nil)
    }
}
