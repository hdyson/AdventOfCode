//
//  TestExtensibleArray.swift
//  Tests
//
//  Created by Harold Dyson on 30/06/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class TestExtensibleArray: XCTestCase {

    var array = ExtensibleArray([0, 1, 2])

    func testInitialValues() {
        let expected = [0, 1, 2]

        let actual = array.backingStore[0]

        XCTAssertEqual(actual, expected)
    }

    func testNoExtraArrays() {
        let expected = 1

        let actual = array.backingStore.count

        XCTAssertEqual(actual, expected)
    }

    func testGetUninitialisedValue() throws {
        let expected = 0

        let actual = array[1000]

        XCTAssertEqual(actual, expected)
    }


}
