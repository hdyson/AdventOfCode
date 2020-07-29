//
//  DayTwelveTests.swift
//  Tests
//
//  Created by Harold Dyson on 28/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class TestConstructMoon: XCTestCase {

    var moons=[Moon]()

    override func setUpWithError() throws {
        let input = """
            <x=0, y=6, z=1>
            <x=4, y=4, z=19>
            <x=-11, y=1, z=8>
            <x=2, y=19, z=15>
            """
        moons = constructMoons(input: input)
    }

    func testNumberOfMoons() throws {
        let expected = 4

        let actual = moons.count

        XCTAssertEqual(actual, expected)
    }

    func testSecondMoonX() {
        let expected = 4

        let actual = moons[1].position.x

        XCTAssertEqual(actual, expected)
    }

    func testSecondMoonY() {
        let expected = 4

        let actual = moons[1].position.y

        XCTAssertEqual(actual, expected)
    }

    func testSecondMoonZ() {
        let expected = 19

        let actual = moons[1].position.z

        XCTAssertEqual(actual, expected)
    }
}
