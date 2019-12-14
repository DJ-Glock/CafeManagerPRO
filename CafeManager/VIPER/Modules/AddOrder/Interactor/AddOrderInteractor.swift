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
    
    func getMenuItem(forIndexPath indexPath: IndexPath) {
        let category = state.categories[indexPath.section]
        if let menuItems = state.menuItems[category] {
            state.selectedMenuItem = menuItems[indexPath.row]
        }
    }
    
    func getMenuItems (withText text: String?) -> [String : [[String : String]]] {
        let menu = Menu.shared
        let menuItems = menu.menuItems
        let categories = menu.menuItems.keys.sorted()
        var finalCategories: [String] = []
        var finalMenuItems: [String:[MenuItem]] = [:]
        
        if text != nil {
            let searchTextLower = text!.lowercased()
            let searchForPrice = text!.getFloatNumber() ?? 0
            
            // Filter menu items by name, description or price
            for category in categories {
                guard let items = menuItems[category] else {continue}
                for item in items {
                    let name = item.name.lowercased()
                    let description = item.description?.lowercased() ?? ""
                    let price = item.price
                    
                    if name.contains(searchTextLower) || description.contains(searchTextLower) || price == searchForPrice {
                        let alreadyIn = finalCategories.contains(category)
                        if (!alreadyIn) {
                            finalCategories.append(category)
                        }
                        var filtered = finalMenuItems[category] ?? []
                        filtered.append(item)
                        finalMenuItems[category] = filtered
                    }
                }
            }
            
            // Filter categories by name if no items were filtered
            if finalCategories.count == 0 {
                for category in categories {
                    let name = category.lowercased()
                    if name.contains(searchTextLower) {
                        finalCategories.append(category)
                        finalMenuItems[category] = menuItems[category]
                    }
                }
            }
        } else {
            finalCategories = categories
            finalMenuItems = menuItems
        }
        
        state.menuItems = finalMenuItems
        
        // Get plain data
        var result = [String : [[String : String]]]()
        for category in categories {
            let items = finalMenuItems[category] ?? []
            for item in items {
                var dictionary = [String: String]()
                let category = item.category

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
        }

        return result
    }
}
