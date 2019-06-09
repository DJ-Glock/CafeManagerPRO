//
//  CustomGuestRouterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CustomGuestRouterInterface {
    /// Method is getting called when guest was chosen
    func didChooseCustomGuest(name: String)
    func dismissView()
}
