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
    
    func didChooseTable(tableName: String) {
        if let _ = state.currentTableSession {
            state.targetTable = getTableForSession(tableName: tableName)
            presenter.didChooseTableForSession()
        }
        if let _ = state.currentGuest {
            state.targetTableSession = getTableSessionForGuest(tableName: tableName)
            presenter.didChooseTableSessionForGuest()
        }
    }
    
    func getTablesArrayForMovingSession() -> [String] {
        if let tables = TablesTable.getAllTables() {
            var tablesNames: [String] = []
            
            for table in tables {
                let session = TableSessionTable.getCurrentTableSession(table: table)
                if session == nil {
                    tablesNames.append(table.tableName!)
                }
            }
            return tablesNames
        }
        return []
    }
    
    func getTablesArrayForMovingGuest() -> [String] {
        if let tables = TablesTable.getAllTables() {
            var tablesNames: [String] = []
            
            for table in tables {
                if let _ = TableSessionTable.getCurrentTableSession(table: table) {
                    tablesNames.append(table.tableName!)
                }
            }
            return tablesNames
        }
        return []
    }
    
    // Private functions
    private func getTableForSession (tableName: String) -> TablesTable? {
        if let table = TablesTable.getTable(withName: tableName) {
            return table
        }
        return nil
    }
    
    private func getTableSessionForGuest (tableName: String) -> TableSessionTable? {
        if let table = TablesTable.getTable(withName: tableName) {
            if let session = TableSessionTable.getCurrentTableSession(table: table) {
                return session
            }
        }
        return nil
    }
}
