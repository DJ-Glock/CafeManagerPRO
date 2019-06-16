//
//  AddOrderInteractor.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class AddOrderInteractor: NSObject, AddOrderInteractorInterface {
    weak var presenter: AddOrderPresenterInterface!
    weak var state: AddOrderState!
    
    func getMenuItem (withName name: String) {
        if let item = MenuItem.getActiveMenuItem(withName: name) {
            state.selectedMenuItem = item
        }
    }
    
    func getMenuItems (withNameContains text: String?) -> [String : [[String : String]]] {
        var menuItems: [MenuItem] = []
        var result = [String : [[String : String]]]()

        if let containsText = text {
            menuItems = MenuItem.getActiveMenuItems(withNameContains: containsText)
        } else {
            menuItems = MenuItem.getActiveMenuItems()
        }
        
        for item in menuItems {
            var dictionary = [String: String]()
            let category = item.category?.categoryName ?? ".Default"
        
            let name = item.itemName
            dictionary["name"] = name
            
            let description = item.itemDescription
            dictionary["description"] = description
            
            let price = item.itemPrice
            dictionary["price"] = String(describing: price)
            
            if let _ = result[category] {
                result[category]!.append(dictionary)
            } else {
                result[category] = [dictionary]
            }
        }
        
        return result
    }
}
