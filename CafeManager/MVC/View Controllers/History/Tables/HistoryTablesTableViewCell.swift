//
//  HistoryTablesTableViewCell.swift
//  CafeManager
//
//  Created by Denis Kurashko on 19.08.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit

class HistoryTablesTableViewCell: UITableViewCell {
    weak var cellDelegate: HistoryTablesTableViewCellDelegate?
    var table: TablesTable? = nil
    @IBOutlet weak var tableNameLabel: UILabel!
}
