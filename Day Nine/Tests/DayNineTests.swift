//
//  DayNineTests.swift
//  Tests
//
//  Created by Harold Dyson on 30/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try

import XCTest

class DayNineTests: XCTestCase {

    var daynine = DayNineParser()

    func testExample1() {
        let testString = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

        let expected = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]

        _ = try! daynine.parseAndExecute(script: testString)
        let actual = daynine.output

        XCTAssertEqual(actual, expected)
    }

    func testExample2() {
        let testString = "1102,34915192,34915192,7,4,7,99,0"

        let expected = 16

        _ = try! daynine.parseAndExecute(script: testString)
        let actual = daynine.output[0].digits.count

        XCTAssertEqual(actual, expected)
    }

    func testExample3() {
        let testString = "104,1125899906842624,99"

        let expected = 1125899906842624

        _ = try! daynine.parseAndExecute(script: testString)
        let actual = daynine.output[0]

        XCTAssertEqual(actual, expected)
    }
}
