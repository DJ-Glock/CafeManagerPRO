//
//  MoveGuestsWireframe.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class MoveGuestsRouter: NSObject, MoveGuestsInterface, MoveGuestsRouterInterface {
    
    weak var presenter: MoveGuestsPresenterInterface!
    weak var delegate: MoveGuestsDelegate!
    weak var view: UIViewController!
    var state: MoveGuestsState!
    
    
    // Incoming
    func chooseTargetTableSession(forGuest guest: Guest, sender: AnyObject) {
        showView(sender: sender)
        
        state.currentGuest = guest
        presenter.configureViewToSelectTableForGuest()
    }
    
    func chooseTargetTable(forSession session: TableSession, sender: AnyObject) {
        showView(sender: sender)
        
        state.currentTableSession = session
        presenter.configureViewToSelectTableForSession()
    }
    
    // Outgoing
    func didChooseTableForSession() {
        delegate.didChoose(targetTable: state.targetTable, forSession: state.currentTableSession)
        view?.dismiss(animated: true, completion: nil)
    }
    
    func didChooseTableSessionForGuest() {
        delegate.didChoose(targetTableSession: state.targetTableSession, forGuest: state.currentGuest)
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
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(view, animated: true, completion: nil)
        }        
    }
}
