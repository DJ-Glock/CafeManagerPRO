//
//  MoveGuestsPresenterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol MoveGuestsPresenterInterface: class {
    /// Array contains names of tables
    var tableNames: [String] { get }
    
    /// Method configures view with closed tables to select
    func configureViewToSelectTableForSession()
    
    /// Method configures view with opened tables to select
    func configureViewToSelectTableForGuest()
    
    /// Method is called when table is chosen. It calls interactor to get required entity
    func didChooseTable(tableName: String)
    
    /// Method is called when table entity is received from db. It calls respective method in router to close view
    func didChooseTableForSession()
    
    /// Method is called when session entity is received from db. It calls respective method in router to close view
    func didChooseTableSessionForGuest()
}
