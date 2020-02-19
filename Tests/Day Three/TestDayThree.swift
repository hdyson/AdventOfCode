//
//  TestDayThree.swift
//  Tests
//
//  Created by Harold Dyson on 16/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

import XCTest

@testable import AdventOfCode

class TestDayThree: XCTestCase {

    var daythree = DayThree()

    func testExample1() {
        let expected = 6
        let actual = daythree.solve(script: "R8,U5,L5,D3\nU7,R6,D4,L4")
        XCTAssertEqual(actual, expected)
    }

    func testExample2() {
        let expected = 159
        let actual = daythree.solve(script: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
        XCTAssertEqual(actual, expected)
    }

    func testExample3() {
        let expected = 135
        let actual = daythree.solve(script: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
        XCTAssertEqual(actual, expected)
    }
    
    func testParseInputFirstLine() {
        let point = Point(x: 1, y: 0)
        let expected = Set<Point>([point, ])
        try! daythree.parse(input:"R1\nD1")
        let actual = daythree.line[0]
        XCTAssertEqual(actual, expected)
    }

    func testParseInputSecondLine() {
        let point = Point(x: 0, y: -1)
        let expected = Set<Point>([point, ])
        try! daythree.parse(input:"R1\nD1")
        let actual = daythree.line[1]
        XCTAssertEqual(actual, expected)
    }

}
