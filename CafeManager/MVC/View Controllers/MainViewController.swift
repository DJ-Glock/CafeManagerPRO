//
//  MainViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 04.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import StoreKit

class MainViewController: ParentViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var iCafeManager: UILabel!
    @IBOutlet weak var tablesButton: UIButton!
    @IBOutlet weak var tablesTextButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuTextButton: UIButton!
    @IBOutlet weak var reportsButton: UIButton!
    @IBOutlet weak var reportsTextButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var historyTextButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsTextButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var helpTextButton: UIButton!

    
    private func configureColorTheme() {
        // View and Label
        self.view.tintColor = ColorThemes.tintColor
        self.iCafeManager.textColor = ColorThemes.tintColor

        // Change buttons images
        self.tablesButton = ChangeGUITheme.setColorThemeFor(button: tablesButton)
        self.menuButton = ChangeGUITheme.setColorThemeFor(button: menuButton)
        self.reportsButton = ChangeGUITheme.setColorThemeFor(button: reportsButton)
        self.historyButton = ChangeGUITheme.setColorThemeFor(button: historyButton)
        self.helpButton = ChangeGUITheme.setColorThemeFor(button: helpButton)
        self.settingsButton = ChangeGUITheme.setColorThemeFor(button: settingsButton)
        self.tablesTextButton.setTitleColor(ColorThemes.tintColor, for: .normal)
        self.menuTextButton.setTitleColor(ColorThemes.tintColor, for: .normal)
        self.reportsTextButton.setTitleColor(ColorThemes.tintColor, for: .normal)
        self.historyTextButton.setTitleColor(ColorThemes.tintColor, for: .normal)
        self.settingsTextButton.setTitleColor(ColorThemes.tintColor, for: .normal)
        self.helpTextButton.setTitleColor(ColorThemes.tintColor, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColorTheme()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.textColor = UIColor.lightGray
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                versionLabel.text = version + "(\(build))"
            } else {
                versionLabel.text = version
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
}
