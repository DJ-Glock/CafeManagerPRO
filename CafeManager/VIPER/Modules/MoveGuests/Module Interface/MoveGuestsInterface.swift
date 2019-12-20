//
//  MoveGuestsInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol MoveGuestsInterface: class {
    /// Delegate should be set to onwer. Owner should conform to protocol MoveGuestsDelegate
    var delegate: MoveGuestsDelegate! {get set}
    
    /// Method shows view with available table sessions for guest to move. Once selected, module will return selected session entity and guest entity
    func chooseTargetTableSession (forGuest: Guest, sender: AnyObject)
    
    /// Method shows view with available tables for session to move. Once selected, module will return selected session entity and table entity
    func chooseTargetTable (forSession: TableSession, sender: AnyObject)
}
