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

class DayTenPartOneTests: XCTestCase {

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
        let actual = DayTenSolver(data: data).solvePartOne()

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
        let actual = DayTenSolver(data: data).solvePartOne()

        XCTAssertEqual(actual, expected)
    }
}

class DayTenPartTwoTests: XCTestCase {

    func testFindDistance() {
        let expected = 5.0

        let origin = Asteroid(x: 1, y: 1)
        let destination = Asteroid(x: 4, y: 5)
        let actual = findDistance(origin, destination)

        XCTAssertEqual(actual, expected)
    }

    func testFind200thASteroidNoOcclusion() {
        // Testcase: line of 210 asteroids, with constant y coordinate and increasing x coordinate.
        // Ensures 200th element of the array should be the 200th when cycling clockwise.
        var asteroids = [Asteroid]()
        let maxAngle = 210
        for x in 0...maxAngle {
            asteroids.append(Asteroid(x: maxAngle - x, y: 0))
        }
        let expected = asteroids[10]  // Created asteroid array in descending order

        let origin = Asteroid(x: 0, y: 10)
        let actual = find200thAsteroid(origin: origin, asteroids: asteroids)

        XCTAssertEqual(actual, expected)
    }

    func testFind200thASteroidWithOcclusion() {
        // Testcase: in addition to previous test case, add some extra asteroids in line at 0 degrees.
        var asteroids = [Asteroid]()
        let maxAngle = 210
        for x in 0...maxAngle {
            asteroids.append(Asteroid(x: maxAngle - x, y: 0))
        }
        //19th asteroid will be bumped up to 200 when the following 9 are added and array is sorted.
        let expected = asteroids[19]
        for y in 1...9 {
            asteroids.append(Asteroid(x: 0, y: y))
        }

        let origin = Asteroid(x: 0, y: 10)
        let actual = find200thAsteroid(origin: origin, asteroids: asteroids)

        XCTAssertEqual(actual, expected)
    }
}
