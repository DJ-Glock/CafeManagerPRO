//
//  CheckoutModule.swift
//  CafeManagerTests
//
//  Created by Denis Kurashko on 13.03.2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import XCTest
@testable import CafeManager

class CheckoutModule: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCheckoutInteractor() {
        let checkoutInteractor = CheckoutInteractor()
        
        let test = checkoutInteractor.calculateTotalAmount(originalTotalAmount: 900, discount: 44)
        print(test)
    }
    
}
