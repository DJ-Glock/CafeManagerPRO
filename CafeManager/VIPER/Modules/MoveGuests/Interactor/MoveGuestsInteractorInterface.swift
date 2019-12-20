//
//  MoveGuestsInteractorInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol MoveGuestsInteractorInterface: class {
    /// Method returns array of tables that have NO opened sessions
    func getTablesArrayForMovingSession() -> [String]
    
    /// Method returns array of tables that have opened sessions only
    func getTablesArrayForMovingGuest() -> [String]
    
    /// Method is getting called when table/session entity was received from database. It calls respective method in presenter to dismiss view
    func didChooseTable(indexPath: IndexPath)
}
