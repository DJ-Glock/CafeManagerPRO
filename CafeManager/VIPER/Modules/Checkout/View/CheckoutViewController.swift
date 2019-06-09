//
//  CheckoutViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 12.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import UIKit
import NotificationCenter

class CheckoutViewController: ParentViewController, CheckoutViewControllerInterface {
    var presenter: CheckoutPresenter?
    
    // IBOutlets
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeOrSaveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipsAmountTextField: UITextField!
    
    // IBActions
    @IBAction func saveOrCloseSessionButtonPressed(_ sender: UIButton) {
        self.view.endEditing(false)
        presenter?.saveTableSession()
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func totalAmountTextFieldEditingDidEnd(_ sender: UITextField) {
        presenter?.totalAmount = presenter!.getFloatValueFromTextField(textField: sender)
    }
    @IBAction func discountTextFieldEditingDidEnd(_ sender: UITextField) {
        presenter?.discount = Int16(presenter!.getFloatValueFromTextField(textField: sender))
    }
    
    // Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addGestureRecognizer()
        //self.totalAmountTextField.becomeFirstResponder()
        // To move view when keyboard appears/hides
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    private func configureGUI() {
        cancelButton.tintColor = ColorThemes.buttonTextColorDestructive
        titleLabel.text = NSLocalizedString("CheckoutPopoverViewTitle", comment: "")
        closeOrSaveButton.setTitle(NSLocalizedString("CheckoutButtonTitle", comment: ""), for: .normal)
        tipsAmountTextField.isUserInteractionEnabled = false
    }
}

extension CheckoutViewController {
    // Function to scroll view when keyboard appears/disappears
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
