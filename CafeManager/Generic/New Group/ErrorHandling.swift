//
//  ErrorHandling.swift
//  CafeManager
//
//  Created by Denis Kurashko on 29.01.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

enum iCafeManagerError : Error {
    case RuntimeError(String)
    case ParsingError(String)
    case CoreDataException(String)
    case ExportError(String)
}
