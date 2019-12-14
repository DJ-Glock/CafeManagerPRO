//
//  AddOrderInteractorInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol AddOrderInteractorInterface {
    /// Method gets MenuTable object for given name and saves it into "state.selectedMenuItem"
    func getMenuItem (withName: String)
    
    /// Method returns array of menu items, item names of that contain given text
    func getMenuItems (withText text: String?) -> [String : [[String : String]]]
}
