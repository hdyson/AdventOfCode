//
//  DaySixTests.swift
//  Tests
//
//  Created by Harold Dyson on 12/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class DaySixParserTests: XCTestCase {

    let daysix = DaySixParser()

    func testGetInput() {
        let testString = "foo)bar"

        let expected = testString

        daysix.parse(inputString: testString)
        let actual = daysix.input

        XCTAssertEqual(actual, expected)
    }

        func testCountOrbits() {
            let testString = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """

            let expected = 42

            daysix.parse(inputString: testString)
            let actual = daysix.countOrbits()

            XCTAssertEqual(actual, expected)
        }

        func testCountTransfers() {
            let testString = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN
    """

            let expected = 4

            daysix.parse(inputString: testString)
            let actual = daysix.countTransfers()

            XCTAssertEqual(actual, expected)
        }
}
