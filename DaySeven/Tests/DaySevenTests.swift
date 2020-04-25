//
//  DaySevenTests.swift
//  Tests
//
//  Created by Harold Dyson on 14/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try

import XCTest

class DaySevenTests: XCTestCase {

    var dayseven = Solver()

    func testPhaseExample1() {
        let testString = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

        let expected = [4, 3, 2, 1, 0]

        try! dayseven.solve(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testPhaseExample2() {
        let testString = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

        let expected = [0, 1, 2, 3, 4]

        try! dayseven.solve(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testPhaseExample3() {
        let testString = """
        3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
        """

        let expected = [1, 0, 4, 3, 2]

        try! dayseven.solve(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample1() {
        let testString = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

        let expected = 43210

        try! dayseven.solve(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample2() {
        let testString = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

        let expected = 54321

        try! dayseven.solve(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample3() {
        let testString = """
        3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
        """

        let expected = 65210

        try! dayseven.solve(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testPermutations() {
        let expected = [[0, 1, 2], [1, 0, 2], [2, 0, 1], [0, 2, 1], [1, 2, 0], [2, 1, 0]]

        var testArray = [0, 1, 2]
        dayseven.permute(testArray.count, &testArray)
        let actual = dayseven.potentialPhases

        XCTAssertEqual(actual, expected)
    }

}
