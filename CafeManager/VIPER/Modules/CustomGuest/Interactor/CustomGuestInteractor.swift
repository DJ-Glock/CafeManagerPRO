//
//  CustomGuestInteractor.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class CustomGuestInteractor: NSObject, CustomGuestInteractorInterface {
    
    weak var presenter: CustomGuestPresenter!
    
    func getGetListOfKnownGuests() -> [String] {
        var guestNames: [String] = []
        guestNames = GuestsTable.getPopularGuestNames()
        return guestNames
    }
}
