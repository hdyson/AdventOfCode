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

    func testCreatesAstronomicalObjects() {
        XCTFail("Test pending")
    }

}

class AstronomicalObjectTests: XCTestCase {

    let astronomicalObject = AstronomicalObject(
        planet: AstronomicalObject(planet: nil, satellite: "foo"),
        satellite: "bar"
    )

    func testInitSetsName() {
        let expected = "bar"

        let actual = astronomicalObject.name

        XCTAssertEqual(actual, expected)
    }

    func testInitSetsOrbits() {
        let expected = AstronomicalObject(planet: nil, satellite: "foo")

        let actual = astronomicalObject.orbits

        XCTAssertEqual(actual, expected)
    }

    func testCountOrbits() {
        let expected = 2

        let actual = astronomicalObject.countOrbits()

        XCTAssertEqual(actual, expected)
    }
}
