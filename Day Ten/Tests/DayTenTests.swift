//
//  DayTenTests.swift
//  Tests
//
//  Created by Harold Dyson on 13/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try
// swiftlint:disable identifier_name
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

    func testFindAngle_0() {
        let expected = 0.0

        let origin = Asteroid(x: 1, y: 1)
        let destination = Asteroid(x: 1, y: 0)
        let actual = findAngle(origin, destination)

        XCTAssertEqual(actual, expected)
    }

    func testFindAngle_90() {
        let expected = 90.0

        let origin = Asteroid(x: 1, y: 1)
        let destination = Asteroid(x: 2, y: 1)
        let actual = findAngle(origin, destination)

        XCTAssertEqual(actual, expected)
    }

    func testFindAngle_180() {
        let expected = 180.0

        let origin = Asteroid(x: 1, y: 1)
        let destination = Asteroid(x: 1, y: 2)
        let actual = findAngle(origin, destination)

        XCTAssertEqual(actual, expected)
    }

    func testFindAngle_270() {
        let expected = 270.0

        let origin = Asteroid(x: 1, y: 1)
        let destination = Asteroid(x: 0, y: 1)
        let actual = findAngle(origin, destination)

        XCTAssertEqual(actual, expected)
    }

    func testVisibleAsteroidCount_case1() {
        let expected = 1

        let mock_position = Asteroid(x: 0, y: 0)
        let mock_map = [Asteroid(x: 0, y: 0), Asteroid(x: 3, y: 1), Asteroid(x: 6, y: 2)]
        let actual = visibleAsteroidCount(origin: mock_position, asteroids: mock_map)

        XCTAssertEqual(actual, expected)
    }

    func testVisibleAsteroidCount_case2() {
        let expected = 2

        let mock_position = Asteroid(x: 3, y: 1)
        let mock_map = [Asteroid(x: 0, y: 0), Asteroid(x: 3, y: 1), Asteroid(x: 6, y: 2)]
        let actual = visibleAsteroidCount(origin: mock_position, asteroids: mock_map)

        XCTAssertEqual(actual, expected)
    }

    func testVisibleAsteroidCount_case3() {
        let expected = 1

        let mock_position = Asteroid(x: 6, y: 2)
        let mock_map = [Asteroid(x: 0, y: 0), Asteroid(x: 3, y: 1), Asteroid(x: 6, y: 2)]
        let actual = visibleAsteroidCount(origin: mock_position, asteroids: mock_map)

        XCTAssertEqual(actual, expected)
    }

    func testFirstExample() {
        let expected = 33

        let data = """
        ......#.#.
        #..#.#....
        ..#######.
        .#.#.###..
        .#..#.....
        ..#....#.#
        #..#....#.
        .##.#..###
        ##...#..#.
        .#....####
        """
        let actual = DayTenSolver(data: data).solve()

        XCTAssertEqual(actual, expected)
    }

    func testFinalExample() {
        let expected = 210

        let data = """
        .#..##.###...#######
        ##.############..##.
        .#.######.########.#
        .###.#######.####.#.
        #####.##.#.##.###.##
        ..#####..#.#########
        ####################
        #.####....###.#.#.##
        ##.#################
        #####.##.###..####..
        ..######..##.#######
        ####.##.####...##..#
        .#####..#.######.###
        ##...#.##########...
        #.##########.#######
        .####.#.###.###.#.##
        ....##.##.###..#####
        .#.#.###########.###
        #.#.#.#####.####.###
        ###.##.####.##.#..##
        """
        let actual = DayTenSolver(data: data).solve()

        XCTAssertEqual(actual, expected)
    }
}
