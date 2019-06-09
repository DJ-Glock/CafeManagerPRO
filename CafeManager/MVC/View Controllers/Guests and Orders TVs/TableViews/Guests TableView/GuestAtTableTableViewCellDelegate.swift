//
//  GuestAtTableTableViewCellDelegate
//  CafeManager
//
//  Created by Denis Kurashko on 26.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

//Protocol for tableView to support segues with sending data to new view
protocol GuestAtTableTableViewCellDelegate : class {
    func didPressCloseGuestButton(guest: GuestsTable)
    func didPressAddGuestOrderButton(guest: GuestsTable, sender: AnyObject)
}
