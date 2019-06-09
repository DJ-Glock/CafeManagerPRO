//
//  HelpViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 26.08.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: ParentViewController, WKUIDelegate {
    
    private var webView: WKWebView!
    // The following variable can be set before performing segue
    /// This vairable can be set to span id tag. This will allow app to load webpage and scroll to required line. For example it can be equal to "#Table"
    var predefinedSection: String?
    
    // MARK: IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    // MARK: Functions
    // Menu
    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        
        let htmlFilePath: String?
        if Locale.current.languageCode == "ru" {
            htmlFilePath = Bundle.main.path(forResource: "HelpWebpage/ru_help", ofType: "html")
        } else {
            htmlFilePath = Bundle.main.path(forResource: "HelpWebpage/en_help", ofType: "html")
        }

        guard htmlFilePath != nil else {return}
        let html = try? String(contentsOfFile: htmlFilePath!, encoding: String.Encoding.utf8)
        let url = NSURL(fileURLWithPath: htmlFilePath!)
        
        if let finalHtml = html {
            webView.loadHTMLString(finalHtml, baseURL: url.deletingLastPathComponent)
        }
    }
}
