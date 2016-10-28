//
//  TestDB.swift
//  TSTest
//
//  Created by Abdul-Wasai Wasim on 10/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import Foundation

class TestDB {
    
    static let singleton = TestDB()
    
    var tests: [Test]?
    var forSavingTests : [[String: String]]?
    
}
