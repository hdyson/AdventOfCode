//
//  DayEightTests.swift
//  Tests
//
//  Created by Harold Dyson on 09/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try

import XCTest

class DayEightTests: XCTestCase {

     let data = "123456789012"
     let width = 3
     let height = 2

    func testFewestZeros() throws {
        let expected = 0
        let solver = try! DayEightSolver(data: data, width: width, height: height)
        let actual = solver.layerWithFewestZeroes

        XCTAssertEqual(expected, actual)
    }

    func testSolvePartOne() throws {
        let expected = 1
        let solver = try! DayEightSolver(data: data, width: width, height: height)
        let actual = solver.solve()

        XCTAssertEqual(expected, actual)
    }

    func testSolvePartTwo() {
        let expected = [[0, 1], [1, 0]]

        let solver = try! DayEightSolver(data: "0222112222120000", width: 2, height: 2)
        let actual = solver.palimpsest()

        XCTAssertEqual(expected, actual)
    }
}
