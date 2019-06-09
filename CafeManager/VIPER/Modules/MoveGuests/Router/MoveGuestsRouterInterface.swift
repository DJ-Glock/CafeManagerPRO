//
//  MoveGuestsRouterInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol MoveGuestsRouterInterface: class {
    /// Method calls presenter to show view for moving guest
    func chooseTargetTableSession(forGuest guest: GuestsTable, sender: AnyObject)
    
    /// Method calls presenter to show view for moving session
    func chooseTargetTable(forSession session: TableSessionTable, sender: AnyObject)
    
    /// Method is getting called when table was chosen. It calls respective delegate method.
    func didChooseTableForSession()
    
    /// Method is getting called when session was chosen. It calls respective delegate method.
    func didChooseTableSessionForGuest()
}
