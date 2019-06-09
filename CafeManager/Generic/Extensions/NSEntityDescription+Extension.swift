//
//  NSEntityDescription+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 13/08/2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation
import CoreData

extension NSEntityDescription {
    public convenience init<A: NSManagedObject>(cls: A.Type, name: String) {
        self.init()
        let a = NSStringFromClass(cls) as String
        self.managedObjectClassName = a
        self.name = name
    }
}

extension NSManagedObject {
    public static var entity: NSEntityDescription {
        if #available(iOS 10.0, *) {
            return entity()
        } else {
            return NSEntityDescription(cls: self.self, name: self.entity.name!)
        }
    }
}

