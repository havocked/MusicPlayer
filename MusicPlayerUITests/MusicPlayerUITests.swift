//
//  MusicPlayerUITests.swift
//  MusicPlayerUITests
//
//  Created by Nataniel Martin on 20/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest

class MusicPlayerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchEnvironment["-ShouldMockResponse"] = "YES"
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
    }
    
}
