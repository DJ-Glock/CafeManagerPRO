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
//        if let item = MenuItem.getActiveMenuItem(withName: name) {
//            state.selectedMenuItem = item
//        }
    }
    
    func getMenuItems (withNameContains text: String?) -> [String : [[String : String]]] {
        let menu = Menu.shared
        var menuItems: [MenuItem] = []
        var result = [String : [[String : String]]]()

        if let containsText = text {
            for (category, categoryItems) in menu.menuItems {
                let items = categoryItems.filter({$0.name.contains(containsText)})
                for item in items {
                    menuItems.append(item)
                }
            }
        } else {
            for (category, categoryItems) in menu.menuItems {
                for item in categoryItems {
                    menuItems.append(item)
                }
            }
        }
        
        menuItems = menuItems.sorted(by: { $0.name < $1.name })

        for item in menuItems {
            var dictionary = [String: String]()
            let category = item.category ?? ".Default"

            let name = item.name
            dictionary["name"] = name

            let description = item.description
            dictionary["description"] = description

            let price = item.price
            dictionary["price"] = String(describing: price)

            if let _ = result[category] {
                result[category]!.append(dictionary)
            } else {
                result[category] = [dictionary]
            }
        }

        return result
        return [:]
    }
}
