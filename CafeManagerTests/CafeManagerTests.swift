//
//  CafeManagerTests.swift
//  CafeManagerTests
//
//  Created by Denis Kurashko on 03.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import XCTest
@testable import CafeManager

class CafeManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        TableSessionTable.getAverageTableSessionTime(from: Date(), to: Date())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
