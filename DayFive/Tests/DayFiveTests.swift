//
//  TestDayFive.swift
//  Tests
//
//  Created by Harold Dyson on 28/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try

import XCTest

@testable import AdventOfCode

class TestDayFivePartOne: XCTestCase {

    var dayfive = DayFiveParser()

    func test_example_1() {
        let expected = 999

        dayfive.input = 999
        dayfive.phaseUsed = true  // required for changes to intcode computer in day 7
        try! _ = dayfive.parse(script: "3,0,4,0,99")
        let actual = dayfive.output[0]

        XCTAssertEqual(actual, expected)
    }

    func test_example_2() {
        let expected = "1002,4,3,4,99"

        dayfive.input = 1
        let actual = try! dayfive.parse(script: "1002,4,3,4,33")

        XCTAssertEqual(actual, expected)
    }
}

class TestDayFivePartTwo: XCTestCase {

    var dayfive = DayFiveParser()

    func test_example_1() {
        let expected = 1

        dayfive.input = 999
        dayfive.phaseUsed = true  // required for changes to intcode computer in day 7
        try! _ = dayfive.parse(script: "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")
        let actual = dayfive.output[0]

        XCTAssertEqual(actual, expected)
    }

    func test_example_2() {
        let expected = 1

        dayfive.input = 999
        dayfive.phaseUsed = true  // required for changes to intcode computer in day 7
        try! _ = dayfive.parse(script: "3,3,1105,-1,9,1101,0,0,12,4,12,99,1")
        let actual = dayfive.output[0]

        XCTAssertEqual(actual, expected)
    }

    func test_example_3_case_1() {
        let expected = 999

        dayfive.input = 0
        dayfive.phaseUsed = true  // required for changes to intcode computer in day 7
        try! _ = dayfive.parse(script: """
3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,\
1101,1000,1,20,4,20,1105,1,46,98,99
"""
        )
        let actual = dayfive.output[0]

        XCTAssertEqual(actual, expected)
    }

    func test_example_3_case_2() {
        let expected = 1000

        dayfive.input = 8
        dayfive.phaseUsed = true  // required for changes to intcode computer in day 7
        try! _ = dayfive.parse(script: """
3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,\
1101,1000,1,20,4,20,1105,1,46,98,99
"""
        )
        let actual = dayfive.output[0]

        XCTAssertEqual(actual, expected)
    }

    func test_example_3_case_3() {
        let expected = 1001

        dayfive.input = 9
        dayfive.phaseUsed = true  // required for changes to intcode computer in day 7
        try! _ = dayfive.parse(script: """
3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,\
1101,1000,1,20,4,20,1105,1,46,98,99
"""
        )
        let actual = dayfive.output[0]

        XCTAssertEqual(actual, expected)
    }

}

class DayFiveParserMock: DayFiveParser {
    func setInstruction(instruction: Int) {
        elements = ExtensibleArray([instruction])
        instructionPointer = 0
    }
}

class TestGetOpCode: XCTestCase {

    var dayfive = DayFiveParserMock()

    func testGetOpcode1() {
        let expected = 1

        dayfive.setInstruction(instruction: 1)
        let actual = dayfive.getOpcode()

        XCTAssertEqual(actual, expected)
    }

    func testGetOpcode201() {
        let expected = 1

        dayfive.setInstruction(instruction: 201)
        let actual = dayfive.getOpcode()

        XCTAssertEqual(actual, expected)
    }

    func testGetOpcode1002() {
        let expected = 2

        dayfive.setInstruction(instruction: 1002)
        let actual = dayfive.getOpcode()

        XCTAssertEqual(actual, expected)
    }
}

class TestGetModes: XCTestCase {

    var dayfive = DayFiveParserMock()

    func testGetModesMissing() {
        let expected = [0, 0, 0]

        dayfive.setInstruction(instruction: 1)
        let actual = dayfive.getModes()

        XCTAssertEqual(actual, expected)
    }

    func testGetModes1002() {
        let expected = [0, 1, 0]

        dayfive.setInstruction(instruction: 1002)
        let actual = dayfive.getModes()

        XCTAssertEqual(actual, expected)
    }
}

// Check we haven't broken day two functionality in day five changes
class TestDayTwoStillWorks: XCTestCase {

    var daytwo = DayFiveParser()

    func testOpcode() {
        XCTAssertThrowsError(try daytwo.parse(script: "15,0,0,0"))
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
