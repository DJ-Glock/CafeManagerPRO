//
//  MoveGuestsPresenter.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class MoveGuestsPresenter: NSObject, MoveGuestsPresenterInterface {
    
    var router: MoveGuestsRouterInterface!
    var interactor: MoveGuestsInteractorInterface!
    weak var view: MoveGuestsViewControllerInterface!
    weak var state: MoveGuestsState!
    
    var tableNames: [String] = []
    
    // Incoming
    func configureViewToSelectTableForSession() {
        tableNames = interactor.getTablesArrayForMovingSession()
        view.tableView.reloadData()
    }
    
    func configureViewToSelectTableForGuest() {
        tableNames = interactor.getTablesArrayForMovingGuest()
        view.tableView.reloadData()
    }
    
    
    // Outgoing
    func didChooseTable(tableName: String) {
        interactor.didChooseTable(tableName: tableName)
    }
    
    func didChooseTableForSession() {
        router.didChooseTableForSession()
    }
    
    func didChooseTableSessionForGuest() {
        router.didChooseTableSessionForGuest()
    }
    
}
