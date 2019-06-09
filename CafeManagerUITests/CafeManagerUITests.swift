//
//  CafeManagerUITests.swift
//  CafeManagerUITests
//
//  Created by Denis Kurashko on 03.05.17.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import XCTest

class CafeManagerUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["Tables"].tap()
        
        for _ in 1...10 {
            let tablesQuery2 = app.tables
            let tablesQuery = tablesQuery2
            tablesQuery.staticTexts["Test"].tap()
            
            let addknownguestbuttonButton = app.buttons["AddKnownGuestButton"]
            addknownguestbuttonButton.tap()
            tablesQuery2.cells.containing(.staticText, identifier:"Austin").buttons["Add"].tap()
            addknownguestbuttonButton.tap()
            tablesQuery2.cells.containing(.staticText, identifier:"Daven").buttons["Add"].tap()
            addknownguestbuttonButton.tap()
            tablesQuery2.cells.containing(.staticText, identifier:"Mike").buttons["Add"].tap()
            addknownguestbuttonButton.tap()
            tablesQuery2.cells.containing(.staticText, identifier:"Frank").buttons["Add"].tap()
            
            let plusbuttonButton = app.otherElements.containing(.navigationBar, identifier:"Test").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "PlusButton").element(boundBy: 1)
            plusbuttonButton.tap()
            tablesQuery2.cells.containing(.staticText, identifier:"Кальян").buttons["Order"].tap()
            
            let button = tablesQuery.buttons["+"]
            button.tap()
            button.tap()
            plusbuttonButton.tap()
            tablesQuery2.cells.containing(.staticText, identifier:"Test1").buttons["Order"].tap()
            sleep(300)
            app.navigationBars["Test"].buttons["Check out"].tap()
            app.alerts["Please confirm table closure"].buttons["Done"].tap()
        }
    }
}
