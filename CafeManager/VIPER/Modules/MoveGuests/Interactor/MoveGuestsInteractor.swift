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
        
        
//        if let tables = Table.getAllTables() {
//            var tablesNames: [String] = []
//
//            for table in tables {
//                let session = TableSession.getCurrentTableSession(table: table)
//                if session == nil {
//                    tablesNames.append(table.name)
//                }
//            }
//            return tablesNames
//        }
//        return []
        return []
    }
    
    func getTablesArrayForMovingGuest() -> [String] {
//        if let tables = Table.getAllTables() {
//            var tablesNames: [String] = []
//
//            for table in tables {
//                if let _ = TableSession.getCurrentTableSession(table: table) {
//                    tablesNames.append(table.name)
//                }
//            }
//            return tablesNames
//        }
//        return []
        return []
    }
    
    // Private functions
    private func getTableForSession (tableName: String) -> Table? {
//        if let table = Table.getTable(withName: tableName) {
//            return table
//        }
//        return nil
        return nil
    }
    
    private func getTableSessionForGuest (tableName: String) -> TableSession? {
//        if let table = Table.getTable(withName: tableName) {
//            if let session = TableSession.getCurrentTableSession(table: table) {
//                return session
//            }
//        }
//        return nil
        return nil
    }
}
