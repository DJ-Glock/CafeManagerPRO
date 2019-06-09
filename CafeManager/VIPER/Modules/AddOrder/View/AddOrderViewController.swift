//
//  AddOrderViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit

class AddOrderViewController: ParentViewController, AddOrderViewControllerInterface, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: AddOrderPresenterInterface!

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Custom Gesture recognizer to fix issue with SearchBar
        self.addGestureRecognizerWithDelegate()
        // To move view when keyboard appears/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    // TableView functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! AddOrderTableViewCell
        let rowData = presenter.getRowData(forSectionIndex: indexPath.section, andRowIndex: indexPath.row)
        
        cell.menuItemNameLabel.text = rowData.name
        cell.menuItemDescriptionLabel.text = rowData.description
        cell.menuItemPriceLabel.text = rowData.price

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.data.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRowsInSection(withNumber: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.getTitleForHeaderInSection(withNumber: section)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = presenter.getRowData(forSectionIndex: indexPath.section, andRowIndex: indexPath.row)
        let name = rowData.name
        let description = rowData.description
        guard name != nil && description != nil else {return}
        
        presenter.didChoose(itemName: name!, withDescription: description!)
    }
}

// UISearchBar delegate
extension AddOrderViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.getData()
        self.tableView.reloadData()
        self.view.endEditing(false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
        self.view.endEditing(false)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            presenter.getFilteredData(forSearchText: searchText)
        } else {
            presenter.getData()
        }
        self.tableView.reloadData()
    }
}

// Extension for GestureRecognizer
// This is a workaround for issue when touches were not received by cells when search is active
extension AddOrderViewController: UIGestureRecognizerDelegate {
    func addGestureRecognizerWithDelegate() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        self.view.addGestureRecognizer(singleTap)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.location(in: tableView)
            return (tableView.indexPathForRow(at: location) == nil)
        }
        return true
    }
}

// Function to scroll view when keyboard appears/disappears
extension AddOrderViewController {
    @objc func keyboardWillChangeFrame (notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 1
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomConstraint?.constant = 0.0
            } else {
                // Keyboard is opened
                var constraintValue = endFrame?.size.height ?? 0
                if UIDevice.current.modelName != "iPhone 4s" {
                    constraintValue = constraintValue - 35
                }
                self.bottomConstraint?.constant = constraintValue
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
