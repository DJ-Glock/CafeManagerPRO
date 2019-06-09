//
//  CustomGuestInterface.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

protocol CustomGuestInterface: class {
    /// Delegate should be set to onwer. Owner should conform to protocol CustomGuestDelegate
    var delegate: CustomGuestDelegate! {get set}
    
    /// Method ыhows view to allow user enter custom guest name or choose name from list of popular guests. It returns string with guest name for further processing
    func chooseCustomGuest(sender: AnyObject)
}
