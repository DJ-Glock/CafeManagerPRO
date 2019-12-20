//
//  MoveGuestsDelegate.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol MoveGuestsDelegate: class {
    /// Method is getting called when target table session was chosen. It returns guest and session entities for futher processing
    func didChoose (targetTableSession: TableSession, forGuest: Guest)
    
    /// Method is getting called when target table was chosen. It returns table and session entities for futher processing
    func didChoose (targetTable: Table, forSession: TableSession)
}
