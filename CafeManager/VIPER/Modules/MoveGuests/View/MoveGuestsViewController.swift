//
//  MoveGuestsViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 17.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit

class MoveGuestsViewController: ParentViewController, MoveGuestsViewControllerInterface, UITableViewDataSource, UITableViewDelegate {
    
    var presenter: MoveGuestsPresenterInterface!

    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    //IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.tintColor = ColorThemes.buttonTextColorDestructive
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Functions for tableViews
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MoveGuestsTableViewCell
        cell.tableNameLabel.text = presenter?.tableNames[indexPath.row]
        return cell
    }
    
    // Function for tapping on row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didChooseTable(indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableNames.count
    }
}
