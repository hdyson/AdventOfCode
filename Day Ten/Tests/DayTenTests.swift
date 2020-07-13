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
        let expected: [[Character]] = [[".", "#"], [".", "."]]

        let input = """
        .#
        ..
        """
        let actual = try! parseInput(input)

        XCTAssertEqual(actual, expected)
    }


}
