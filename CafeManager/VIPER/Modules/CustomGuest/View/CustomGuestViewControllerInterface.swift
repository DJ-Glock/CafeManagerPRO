//
//  CustomGuestViewControllerInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CustomGuestViewControllerInterface: class {
    var presenter: customGuestPresenterInterface! {get set}
    var popularGuestsTableView: UITableView! { get }
}
