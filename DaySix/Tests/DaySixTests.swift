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
        let test_string = "foo)bar"

        let expected = test_string
        
        daysix.parse(test_string)
        let actual = daysix.input
        
        XCTAssertEqual(actual, expected)
    }
    
    func testCreatesOrbits() {
        XCTFail("Test pending")
    }

}

class OrbitTests: XCTestCase {

    let orbit = Orbit(planet: "foo", satellite: "bar")

    func testInitSetsSatellite() {
        let expected = "bar"
        
        let actual = orbit.satellite
        
        XCTAssertEqual(actual, expected)
    }
}
