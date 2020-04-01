//
//  TestDayTwo.swift
//  Tests
//
//  Created by Harold Dyson on 14/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

@testable import AdventOfCode

class TestDayTwo: XCTestCase {

    var daytwo = DayTwoParser()

    func testOpcode() {
        XCTAssertThrowsError(try daytwo.parse(script: "3,0,0,0"))
    }

    func testExample1() {
        let expected = "2,0,0,0,99"
        do {
            let actual = try daytwo.parse(script: "1,0,0,0,99")
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail("Unexpected exception thrown")
        }
    }

    func testExample2() {
        let expected = "2,3,0,6,99"
        do {
            let actual = try daytwo.parse(script: "2,3,0,3,99")
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail("Unexpected exception thrown")
        }
    }

    func testExample3() {
        let expected = "2,4,4,5,99,9801"
        do {
            let actual = try daytwo.parse(script: "2,4,4,5,99,0")
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail("Unexpected exception thrown")
        }
    }

    func testExample4() {
        let expected = "30,1,1,4,2,5,6,0,99"
        do {
            let actual = try daytwo.parse(script: "1,1,1,4,99,5,6,0,99")
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail("Unexpected exception thrown")
        }
    }

}
