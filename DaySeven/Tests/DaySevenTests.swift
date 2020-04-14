//
//  DaySevenTests.swift
//  Tests
//
//  Created by Harold Dyson on 14/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class DaySevenTests: XCTestCase {

    var dayseven = DaySevenParser()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testExample1() {
        let testString = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

        let expected = 43210

        dayseven.input = 0
        _ = try! dayseven.parse(script: testString)
        let actual = dayseven.getResult()[0]

        XCTAssertEqual(actual, expected)
    }

    func testExample2() {
        let testString = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

        let expected = 54321

        dayseven.input = 0
        _ = try! dayseven.parse(script: testString)
        let actual = dayseven.getResult()[0]

        XCTAssertEqual(actual, expected)
    }

    func testExample3() {
        let testString = """
        3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
        """

        let expected = 65210

        dayseven.input = 0
        _ = try! dayseven.parse(script: testString)
        let actual = dayseven.getResult()[0]

        XCTAssertEqual(actual, expected)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
