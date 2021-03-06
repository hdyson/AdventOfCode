//
//  DayElevenTests.swift
//  Tests
//
//  Created by Harold Dyson on 26/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import XCTest

class DayElevenPartOneTests: XCTestCase {

}

class RobotTests: XCTestCase {

    let robot = Robot(x: 0, y: 0, direction: 0, "1,1")

    func testChangeDirectionUpToRight() {
        let expected = 1
        robot.changeDirection(1)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionRightToDown() {
        let expected = 2
        robot.direction = 1
        robot.changeDirection(1)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionDownToLeft() {
        let expected = 3
        robot.direction = 2
        robot.changeDirection(1)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionLeftToUp() {
        let expected = 0
        robot.direction = 3
        robot.changeDirection(1)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionUpToLeft() {
        let expected = 3
        robot.changeDirection(0)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionRightToUp() {
        let expected = 0
        robot.direction = 1
        robot.changeDirection(0)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionDownToRight() {
        let expected = 1
        robot.direction = 2
        robot.changeDirection(0)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    func testChangeDirectionLeftToDown() {
        let expected = 2
        robot.direction = 3
        robot.changeDirection(0)
        let actual = robot.direction

        XCTAssertEqual(actual, expected)
    }

    // No tuple equality in swift, so need tests for x and y separately:
    func testMoveUpX() throws {
        let expected = 0

        try robot.move()
        let actual = robot.x

        XCTAssertEqual(actual, expected)
    }

    func testMoveRightX() throws {
        let expected = 1

        robot.direction = 1
        try robot.move()
        let actual = robot.x

        XCTAssertEqual(actual, expected)
    }

    func testMoveDownX() throws {
        let expected = 0

        robot.direction = 2
        try robot.move()
        let actual = robot.x

        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftX() throws {
        let expected = -1

        robot.direction = 3
        try robot.move()
        let actual = robot.x

        XCTAssertEqual(actual, expected)
    }

    func testMoveUpY() throws {
        let expected = 1

        try robot.move()
        let actual = robot.y

        XCTAssertEqual(actual, expected)
    }

    func testMoveRightY() throws {
        let expected = 0

        robot.direction = 1
        try robot.move()
        let actual = robot.y

        XCTAssertEqual(actual, expected)
    }

    func testMoveDownY() throws {
        let expected = -1

        robot.direction = 2
        try robot.move()
        let actual = robot.y

        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftY() throws {
        let expected = 0

        robot.direction = 3
        try robot.move()
        let actual = robot.y

        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftTwiceX() throws {
        let expected = -2

        robot.direction = 3
        try robot.move()
        try robot.move()
        let actual = robot.x

        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftTwiceY() throws {
        let expected = 0

        robot.direction = 3
        try robot.move()
        try robot.move()
        let actual = robot.y

        XCTAssertEqual(actual, expected)
    }

    func testMoveRightTwiceX() throws {
        let expected = 2

        robot.direction = 1
        try robot.move()
        try robot.move()
        let actual = robot.x

        XCTAssertEqual(actual, expected)
    }

    func testMoveRightTwiceY() throws {
        let expected = 0

        robot.direction = 1
        try robot.move()
        try robot.move()
        let actual = robot.y

        XCTAssertEqual(actual, expected)
    }
}

class PanelTests: XCTestCase {

    let panel = Panel()

    func testUninitialisedValue() {
        let expected = 0

        let actual = panel.get(Point(x: 1, y: 1))

        XCTAssertEqual(actual, expected)
    }

    func testInitialisedValue() {
        let expected = 1

        panel.set(Point(x: 0, y: 0), 1)
        let actual = panel.get(Point(x: 0, y: 0))

        XCTAssertEqual(actual, expected)
    }
}
