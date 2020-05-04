//
//  DaySevenTests.swift
//  Tests
//
//  Created by Harold Dyson on 14/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try

import XCTest

class DaySevenPartOneTests: XCTestCase {

    var dayseven = Solver()

    func testPhaseExample1() {
        let testString = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

        let expected = [4, 3, 2, 1, 0]

        try! dayseven.solvePartOne(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testPhaseExample2() {
        let testString = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

        let expected = [0, 1, 2, 3, 4]

        try! dayseven.solvePartOne(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testPhaseExample3() {
        let testString = """
        3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
        """

        let expected = [1, 0, 4, 3, 2]

        try! dayseven.solvePartOne(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample1() {
        let testString = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

        let expected = 43210

        try! dayseven.solvePartOne(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample2() {
        let testString = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"

        let expected = 54321

        try! dayseven.solvePartOne(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample3() {
        let testString = """
        3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
        """

        let expected = 65210

        try! dayseven.solvePartOne(script: testString)
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

class DaySevenPartTwoTests: XCTestCase {

    func testSignalForKnownPhase1() {
        let testString = """
        3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
        """
        let dayseven = Solver([5, 6, 7, 8, 9])
        dayseven.potentialPhases = [[9, 8, 7, 6, 5]]
        let expected = 139629729

        try! dayseven.solvePartTwo(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testSignalForKnownPhase2() {
        let testString = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,"
            + "1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
        let dayseven = Solver([5, 6, 7, 8, 9])
        dayseven.potentialPhases = [[9, 7, 8, 5, 6]]
        let expected = 18216

        try! dayseven.solvePartTwo(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testMaxPhaseExample1() {
        let testString = """
        3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
        """
        let dayseven = Solver([5, 6, 7, 8, 9])

        let expected = [9, 8, 7, 6, 5]

        try! dayseven.solvePartTwo(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testMaxPhaseExample2() {
        let testString = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,"
            + "1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
        let dayseven = Solver([5, 6, 7, 8, 9])

        let expected = [9, 7, 8, 5, 6]

        try! dayseven.solvePartTwo(script: testString)
        let actual = dayseven.maximumPhase

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample1() {
        let testString = """
        3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
        """
        let dayseven = Solver([5, 6, 7, 8, 9])

        let expected = 139629729

        try! dayseven.solvePartTwo(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }

    func testMaxSignalExample2() {
        let testString = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,"
            + "1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
        let dayseven = Solver([5, 6, 7, 8, 9])

        let expected = 18216

        try! dayseven.solvePartTwo(script: testString)
        let actual = dayseven.getResult()

        XCTAssertEqual(actual, expected)
    }
}
