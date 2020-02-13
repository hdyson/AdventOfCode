//
//  TestDayOne.swift
//  TestDayOne
//
//  Created by Harold Dyson on 12/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

@testable import AdventOfCode


class TestDayOne: XCTestCase {

    var rocket = Rocket(masses: "")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPart1Example1() {
        let expected = 2
        let actual = rocket.calculate_module_fuel(mass: 12)
        XCTAssertTrue(actual == expected)
    }

    func testPart1Example2() {
        let expected = 2
        let actual = rocket.calculate_module_fuel(mass: 14)
        XCTAssertTrue(actual == expected)
    }

    func testPart1Example3() {
        let expected = 654
        let actual = rocket.calculate_module_fuel(mass: 1969)
        XCTAssertTrue(actual == expected)
    }

    func testPart1Example4() {
        let expected = 33583
        let actual = rocket.calculate_module_fuel(mass: 100756)
        XCTAssertTrue(actual == expected)
    }

    func testPart2Example1() {
        let expected = 2
        let actual = calculate_gross_module_fuel(mass: 14)
        XCTAssertTrue(actual == expected)
    }

    func testPart2Example2() {
        let expected = 966
        let actual = calculate_gross_module_fuel(mass: 1969)
        XCTAssertTrue(actual == expected)
    }

    func testPart2Example1() {
        let expected = 50346
        let actual = calculate_gross_module_fuel(mass: 100756)
        XCTAssertTrue(actual == expected)
    }
}

