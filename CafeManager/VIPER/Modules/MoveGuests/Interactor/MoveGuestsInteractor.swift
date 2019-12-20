//
//  MoveGuestsInteractor.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class MoveGuestsInteractor: NSObject, MoveGuestsInteractorInterface {
    
    weak var state: MoveGuestsState!
    weak var presenter: MoveGuestsPresenterInterface!
    
    func didChooseTable(indexPath: IndexPath) {
        if let _ = state.currentGuest {
            state.targetTableSession = state.tableSessions[indexPath.row]
            presenter.didChooseTableSessionForGuest()
        } else if let _ = state.currentTableSession {
            state.targetTable = state.tablesWithoutSession[indexPath.row]
            presenter.didChooseTableForSession()
        }
        
    }
    
    func getTablesArrayForMovingSession() -> [String] {
        var tableNames = [String]()
        self.state.tablesWithoutSession = []
        
        for table in Global.shared.tables {
            let session = table.tableSession
            if session == nil {
                self.state.tablesWithoutSession.append(table)
                tableNames.append(table.name)
            }
        }
        
        return tableNames
    }
    
    func getTablesArrayForMovingGuest() -> [String] {
        var tableNames = [String]()
        self.state.tablesWithoutSession = []
        
        for table in Global.shared.tables {
            if table !== self.state.currentTableSession.table, let session = table.tableSession {
                self.state.tableSessions.append(session)
                tableNames.append(table.name)
            }
        }
        
        return tableNames
    }
}
