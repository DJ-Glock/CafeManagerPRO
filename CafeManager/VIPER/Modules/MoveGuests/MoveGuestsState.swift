//
//  MoveGuestsState.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

class MoveGuestsState: NSObject {
    var currentGuest: Guest!
    var currentTableSession: TableSession!
    var targetTable: Table!
    var targetTableSession: TableSession!
    var tablesWithoutSession: [Table] = []
    var tableSessions: [TableSession] = []
}
