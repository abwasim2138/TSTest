//
//  TSTestUITests.swift
//  TSTestUITests
//
//  Created by Abdul-Wasai Wasim on 10/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import XCTest

class TSTestUITests: XCTestCase {
    
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
 
        continueAfterFailure = false
   
        app.launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResults (yes: Int?, no: Int?, percent: String) {
        app.buttons["TAKE TEST"].tap()
        if yes != nil {
            for _ in 0...yes! {
                app.buttons["YES"].tap()
            }
        }
        if no != nil {
            for _ in 0...no! {
                app.buttons["NO"].tap()
            }
        }
        sleep(1)
        XCTAssert(app.tables.children(matching: .cell).element(boundBy: 0).staticTexts[percent].exists)
    }
    
    func testFor100Percent () {
        testResults(yes: 3, no: nil, percent: "100%")
    }
    func testFor75Percent () {
        testResults(yes: 2, no: 0, percent: "75%")
    }
    func testFor50Percent () {
        testResults(yes: 1, no: 1, percent: "50%")
    }
    func testFor25Percent () {
        testResults(yes: 0, no: 2, percent: "25%")
    }
    func testFor0Percent () {
        testResults(yes: nil, no: 3, percent: "0%")
    }
    
    func deleteTableViewCell () {
        app.tables.cells.element(boundBy: 0).swipeLeft()
        app.tables.cells.element(boundBy: 0).buttons["Delete"].tap()
    }
    
  
    
}
