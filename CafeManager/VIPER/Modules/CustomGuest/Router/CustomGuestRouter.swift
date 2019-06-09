//
//  CustomGuestRouter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CustomGuestRouter: NSObject, CustomGuestInterface, CustomGuestRouterInterface {

    weak var presenter: customGuestPresenterInterface!
    weak var delegate: CustomGuestDelegate!
    weak var view: UIViewController!
    
    func chooseCustomGuest(sender: AnyObject) {
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
        
        presenter.configureView()
    }
    
    func didChooseCustomGuest(name: String) {
        delegate.didChooseCustomGuest(name: name)
        view?.dismiss(animated: true, completion: nil)
    }
    
    func dismissView() {
        view?.dismiss(animated: true, completion: nil)
    }
}
