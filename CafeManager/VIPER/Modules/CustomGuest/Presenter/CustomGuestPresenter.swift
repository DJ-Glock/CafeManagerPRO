//
//  CustomGuestPresenter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CustomGuestPresenter: NSObject, customGuestPresenterInterface{
    
    var router: CustomGuestRouterInterface!
    var interactor: CustomGuestInteractorInterface!
    weak var view: CustomGuestViewControllerInterface!
    
    var guestNames: [String] = []
    
    // Incoming
    func configureView() {
        guestNames = interactor.getGetListOfKnownGuests()
        view.popularGuestsTableView.reloadData()
    }
    
    // Outgoing
    func didChooseGuestWith(name: String) {
        router.didChooseCustomGuest(name: name)
    }
    
    func didPressCancelButton() {
        router.dismissView()
    }
    
}
