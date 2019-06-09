//
//  CustomGuestPresenterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol customGuestPresenterInterface: class {
    var guestNames: [String] { get }
    
    func configureView()
    func didChooseGuestWith(name: String)
    func didPressCancelButton()
}
