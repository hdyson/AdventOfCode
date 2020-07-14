//
//  DayTenTests.swift
//  Tests
//
//  Created by Harold Dyson on 13/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class DayTenTests: XCTestCase {

    func testParseInput() throws {
        let expected = [Asteroid(x: 1, y: 0), Asteroid(x: 1, y: 1)]
        let input = """
        .#
        .#
        """
        let actual = try! parseInput(input)

        XCTAssertEqual(actual, expected)
    }
}
