//
//  AddOrderTableViewControllerInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol AddOrderViewControllerInterface: class {
    var presenter: AddOrderPresenterInterface! { get set }
    
    var tableView: UITableView! { get set }
}
