//
//  DaySixTests.swift
//  Tests
//
//  Created by Harold Dyson on 12/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class DaySixTests: XCTestCase {

    var daysix = DaySixParser()
    
    func testGetInput() {
        let test_string = "foo)bar"

        let expected = test_string
        
        daysix.parse(test_string)
        let actual = daysix.input
        
        XCTAssertEqual(actual, expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
