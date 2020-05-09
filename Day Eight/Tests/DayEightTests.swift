//
//  DayEightTests.swift
//  Tests
//
//  Created by Harold Dyson on 09/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class DayEightTests: XCTestCase {

     let data = "123456789012"
     let width = 3
     let height = 2

    func testFewestZeros() throws {
        let expected = 0
        let solver = DayEightSolver(data: data, width: width, height: height)
        let actual = solver.layerWithFewestZeroes

        XCTAssertEqual(expected, actual)
    }

    func testSolvePartOne() throws {
        let expected = 1
        let solver = DayEightSolver(data: data, width: width, height: height)
        let actual = solver.solve()

        XCTAssertEqual(expected, actual)

    }

}
