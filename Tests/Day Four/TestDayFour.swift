//
//  TestDayFour.swift
//  Tests
//
//  Created by Harold Dyson on 23/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

@testable import AdventOfCode

class TestDayFour: XCTestCase {

    var dayfourpart1 = DayFourPart1(min: 0, max: 1)
    var dayfourpart2 = DayFourPart2(min: 0, max: 1)

    func testPart1Example1() {
        XCTAssertTrue(dayfourpart1.check(input: 111111))
    }

    func testPart1Example2() {
        XCTAssertFalse(dayfourpart1.check(input: 223450))
    }

    func testPart1Example3() {
        XCTAssertFalse(dayfourpart1.check(input: 123789))
    }

    func test_for_double_example1() {
        XCTAssertTrue(dayfourpart1.check_double(input: 111111))
    }

    func test_for_double_example2() {
        XCTAssertTrue(dayfourpart1.check_double(input: 223450))
    }

    func test_for_double_example3() {
        XCTAssertFalse(dayfourpart1.check_double(input: 123789))
    }

    func test_not_decreasing_example1() {
        XCTAssertTrue(dayfourpart1.check_not_decreasing(input: 111111))
    }

    func test_not_decreasing_example2() {
        XCTAssertFalse(dayfourpart1.check_not_decreasing(input: 223450))
    }

    func test_not_decreasing_example3() {
        XCTAssertTrue(dayfourpart1.check_not_decreasing(input: 123789))
    }

    func test_double_not_triple_example1() {
        XCTAssertTrue(dayfourpart2.check_double(input: 112233))
    }

    func test_double_not_triple_example2() {
        XCTAssertFalse(dayfourpart2.check_double(input: 123444))
    }

    func test_double_not_triple_example3() {
        XCTAssertTrue(dayfourpart2.check_double(input: 111122))
    }
}
