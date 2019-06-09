//
//  HistoryTablesTableViewCellDelegate
//  CafeManager
//
//  Created by Denis Kurashko on 19.08.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

//Protocol for tableView to support segues with sending data to new view
protocol HistoryTablesTableViewCellDelegate : class {
    func didPressTablesCellButton(table: TablesTable)
}
