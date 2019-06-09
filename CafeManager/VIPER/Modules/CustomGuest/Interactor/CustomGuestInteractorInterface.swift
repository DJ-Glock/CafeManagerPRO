//
//  CustomGuestInteractorInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CustomGuestInteractorInterface: class {
    var presenter: CustomGuestPresenter! { get set}
    /// Method returns list of known guests to fill the table
    func getGetListOfKnownGuests() -> [String]
}
