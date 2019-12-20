//
//  OrderInTableTableViewCellDelegate
//  CafeManager
//
//  Created by Denis Kurashko on 26.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

//Protocol for tableView to support segues with sending data to new view
protocol OrderInTableTableViewCellDelegate : class {
    func didPressIncreaseOrDecreaseOrderQuantityButton (order: Order, action: String)
}
