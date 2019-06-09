//
//  CustomGuestViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit

class CustomGuestViewController: ParentViewController, CustomGuestViewControllerInterface, UITableViewDataSource, UITableViewDelegate {
    
    var presenter: customGuestPresenterInterface!
    
    // MARK: IBOutlets
    @IBOutlet weak var guestNameTextField: UITextField!
    @IBOutlet weak var popularGuestsTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: IBActions
    @IBAction func addGuestButtonPressed(_ sender: UIButton) {
        if let guestName = self.guestNameTextField.text {
            presenter.didChooseGuestWith(name: guestName)
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        presenter.didPressCancelButton()
    }
    
    // MARK: lifecycle functions for view
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.tintColor = ColorThemes.buttonTextColorDestructive
        popularGuestsTableView.delegate = self
        popularGuestsTableView.dataSource = self
        
        // To dismiss keyboard
        self.addGestureRecognizer()
    }
    
    // MARK: Functions for tableViews
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularGuestName", for: indexPath) as! CustomGuestTableViewCell
        cell.guestNameLabel.text = presenter.guestNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = presenter.guestNames[indexPath.row]
        presenter.didChooseGuestWith(name: name)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.guestNames.count
    }
}
