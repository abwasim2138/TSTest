//
//  TSTestTests.swift
//  TSTestTests
//
//  Created by Abdul-Wasai Wasim on 10/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import XCTest

@testable import TSTest
class TSTestTests: XCTestCase {
    var vc: UIViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  
    
}
