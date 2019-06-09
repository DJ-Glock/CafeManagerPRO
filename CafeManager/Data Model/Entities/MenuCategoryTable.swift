//
//  MenuCategoryTable.swift
//  CafeManager
//
//  Created by Denis Kurashko on 20.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation
import CoreData

class MenuCategoryTable: NSManagedObject {
    static let menuCategoryFetchRequest: NSFetchRequest<MenuCategoryTable> = MenuCategoryTable.fetchRequest()
    
    class func getAllCategories() -> [String] {
        menuCategoryFetchRequest.predicate = nil
        menuCategoryFetchRequest.fetchLimit = 0
        var categories: [String] = []
        if let fetchedCategories = try? viewContext.fetch(menuCategoryFetchRequest) {
            for fetchedCategory in fetchedCategories {
                if let categoryName = fetchedCategory.categoryName {
                    categories.append(categoryName)
                }
            }
        }
        return categories
    }
    
    class func getOrCreateCategory(category: String?) -> MenuCategoryTable? {
        // If category is nil, set Default value.
        let itemCategory = category ?? ".Default"
        
        // Search if category already exists, if not, create it.
        let predicate = NSPredicate(format: "categoryName = %@", itemCategory as CVarArg)
        menuCategoryFetchRequest.predicate = predicate
        menuCategoryFetchRequest.fetchLimit = 1
        let fetchedCategory = try? viewContext.fetch(menuCategoryFetchRequest)
        if fetchedCategory != nil && fetchedCategory!.count == 0 {
            if #available(iOS 10.0, *) {
                let newCategory = MenuCategoryTable(context: viewContext)
                newCategory.categoryName = itemCategory
                do {
                    try viewContext.save()
                    return newCategory
                } catch {
                    print(error)
                }
            } else {
                let newCategory = MenuCategoryTable(entity: NSEntityDescription.entity(forEntityName: "MenuCategoryTable", in: viewContext)!, insertInto: viewContext)
                newCategory.categoryName = itemCategory
                do {
                    try viewContext.save()
                    return newCategory
                } catch {
                    print(error)
                }
            }
        } else {
            return fetchedCategory?.first
        }
        return nil
    }
}

extension MenuCategoryTable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuCategoryTable> {
        return NSFetchRequest<MenuCategoryTable>(entityName: "MenuCategoryTable")
    }
    
    @NSManaged public var categoryName: String?
    @NSManaged public var menuItem: MenuTable?
}

 //MARK: Generated accessors for MenuCategoryTable
extension MenuCategoryTable {

    @objc(addMenuItemObject:)
    @NSManaged public func addToMenuItem(_ value: MenuTable)

    @objc(removeMenuItemObject:)
    @NSManaged public func removeFromMenuItem(_ value: MenuTable)

    @objc(addMenuItem:)
    @NSManaged public func addToMenuItem(_ values: NSSet)

    @objc(removeMenuItem:)
    @NSManaged public func removeFromMenuItem(_ values: NSSet)
}

