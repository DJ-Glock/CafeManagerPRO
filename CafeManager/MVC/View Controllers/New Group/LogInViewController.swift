//
//  LogInViewController.swift
//  CafeManager
//
//  Created by Denis Kurashko on 10/06/2019.
//  Copyright © 2019 Denis Kurashko. All rights reserved.
//

import Firebase
import FirebaseUI

class LogInViewController: UIViewController, FUIAuthDelegate {
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: self.performSegueAfterLoggedIn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.auth = appDelegate.auth
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIGoogleAuth()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Open login form or perform segue if user is already logged in
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
            // Already logged in
            self.performSegueAfterLoggedIn()
        }
    }
    
    // Implement the required protocol method for FIRAuthUIDelegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { self.performSegueAfterLoggedIn(); return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
            
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
    private func performSegueAfterLoggedIn () {
        performSegue(withIdentifier: "LogIn segue", sender: self)
    }
}

