//
//  CustomGuestDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CustomGuestDelegate: class {
    /// Method is getting called when custom guest name is chosen
    func didChooseCustomGuest(name: String)
}
