//
//  DayTen.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 13/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try
import Foundation

enum DayTenError: Error {
    case invalidInput(input: Character)
}

struct Asteroid: Equatable {
    // swiftlint:disable identifier_name
    let x: Int
    let y: Int
    // swiftlint:enable identifier_name

    static func == (left: Asteroid, right: Asteroid) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }

    static func - (left: Asteroid, right: Asteroid) -> (Int, Int) {
        let xdiff = left.x - right.x
        // y defined as positive down in puzzle
        let ydiff = right.y - left.y
        return (xdiff, ydiff)
    }
}

class DayTenSolver {

    var asteroids: [Asteroid]

    init(data: String) {
        asteroids = try! parseInput(data)
    }

    func solve() -> Int {
        var maximumAsteroidCount = 0
        for asteroid in asteroids {
            let asteroidCount = visibleAsteroidCount(origin: asteroid, asteroids: asteroids)
            if asteroidCount > maximumAsteroidCount {
                maximumAsteroidCount = asteroidCount
            }
        }
        return maximumAsteroidCount
    }

}

func parseInput(_ input: String) throws -> [Asteroid] {

    var result = [Asteroid]()
    var row = 0
    var column = 0

    for character in input {
        switch character {
        case ".":
            column += 1
        case "#":
            result.append(Asteroid(x: column, y: row))
            column += 1
        case "\n":
            column = 0
            row += 1
        default:
            throw DayTenError.invalidInput(input: character)
        }
    }

    return result
}

func findAngle(_ origin: Asteroid, _ destination: Asteroid) -> Double {
    let (xdiff, ydiff) = destination - origin
    var result = atan2(Double(xdiff), Double(ydiff)) * 180.0 / Double.pi
    // Shift from -180 -> +180 to 0 -> 360
    if result < 0.0 {
        result += 360.0
    }
    return result
}

func visibleAsteroidCount(origin: Asteroid, asteroids: [Asteroid]) -> Int {
    // Counts asteroids visible from origin
    var result = Set<Double>()
    for asteroid in asteroids {
        if origin == asteroid {
            continue
        }
        result.insert(findAngle(origin, asteroid))
    }
    return result.count
}

func dayten(contents: String) throws -> String {
    let solver = DayTenSolver(data: contents)
    return "Part 1: \(solver.solve())"
}
