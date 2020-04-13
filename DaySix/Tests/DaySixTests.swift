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
        let testString = "foo)bar"

        let orbited = AstronomicalObject(planet: nil, satellite: "foo")
        let satellite = AstronomicalObject(planet: orbited, satellite: "bar")
        let expected = Set([orbited, satellite])

        daysix.parse(inputString: testString)
        let actual = daysix.astronomicalObjects

        XCTAssertEqual(actual, expected)
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

    func testCountSingleOrbit() {
        let expected = 1

        let actual = astronomicalObject.countOrbits()

        XCTAssertEqual(actual, expected)
    }

    func testCountMultipleOrbits() {
        let expected = 3

        let secondObject = AstronomicalObject(planet: astronomicalObject, satellite: "baz")
        let thirdObject = AstronomicalObject(planet: secondObject, satellite: "end")
        let actual = thirdObject.countOrbits()

        XCTAssertEqual(actual, expected)

    }
}
