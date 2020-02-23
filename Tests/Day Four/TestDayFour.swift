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

    var dayfour = DayFour(min:0, max:1)

    func testPart1Example1() {
        XCTAssertTrue(dayfour.check(input: 111111))
    }
    
    func testPart1Example2() {
        XCTAssertFalse(dayfour.check(input: 223450))
    }
    
    func testPart1Example3() {
        XCTAssertFalse(dayfour.check(input: 123789))
    }
    
    func test_for_double_example1(){
        XCTAssertTrue(dayfour.check_double(input: 111111))
    }

    func test_for_double_example2(){
        XCTAssertTrue(dayfour.check_double(input: 223450))
    }

    func test_for_double_example3(){
        XCTAssertFalse(dayfour.check_double(input: 123789))
    }

    func test_not_decreasing_example1(){
        XCTAssertTrue(dayfour.check_not_decreasing(input: 111111))
    }

    func test_not_decreasing_example2(){
        XCTAssertFalse(dayfour.check_not_decreasing(input: 223450))
    }

    func test_not_decreasing_example3(){
        XCTAssertTrue(dayfour.check_not_decreasing(input: 123789))
    }
}
