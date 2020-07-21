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

class Asteroid: Equatable, Comparable {
    // swiftlint:disable identifier_name
    let x: Int
    let y: Int
    // swiftlint:enable identifier_name
    var angle = 0.0
    var distance = 0.0

    init(x xPosition: Int, y yPosition: Int) {
        x = xPosition
        y = yPosition
    }

    static func == (left: Asteroid, right: Asteroid) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }

    static func - (left: Asteroid, right: Asteroid) -> (Int, Int) {
        let xdiff = left.x - right.x
        // y defined as positive down in puzzle
        let ydiff = right.y - left.y
        return (xdiff, ydiff)
    }

    static func < (left: Asteroid, right: Asteroid) -> Bool {
        var result = false
        if left.angle < right.angle {
            result = true
        } else if left.angle == right.angle {
            if left.distance < right.distance {
                result = true
            }
        }
        return result
    }
}

class DayTenSolver {

    var asteroids: [Asteroid]
    var maximumAsteroidCount = 0

    init(data: String) {
        asteroids = try! parseInput(data)
    }

    func solvePartOne() -> Int {
        _ = findAsteroidWithBestVisibility()
        return maximumAsteroidCount
    }

    func solvePartTwo(count: Int = 200) -> Int {
        maximumAsteroidCount = 0
        let origin = findAsteroidWithBestVisibility()
        var originIndex = -1  // Will create runtime error if origin isn't found in asteroids
        for (index, asteroid) in asteroids.enumerated() {
            asteroid.angle = findAngle(origin, asteroid)
            asteroid.distance = findDistance(origin, asteroid)
            if asteroid == origin {
                originIndex = index
            }
        }
        asteroids.remove(at: originIndex)
        asteroids.sort()

        let asteroid = findNthAsteroid(origin: origin, asteroids: asteroids, n: count)

        // Hardcoded values from puzzle text
        let result =  100 * asteroid.x + asteroid.y

        return result
    }

    func findAsteroidWithBestVisibility() -> Asteroid {
        var asteroidWithHighestCount: Asteroid?
        for asteroid in asteroids {
            let asteroidCount = visibleAsteroidCount(origin: asteroid, asteroids: asteroids)
            if asteroidCount > maximumAsteroidCount {
                asteroidWithHighestCount = asteroid
                maximumAsteroidCount = asteroidCount
            }
        }
        return asteroidWithHighestCount!
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

func findDistance(_ origin: Asteroid, _ destination: Asteroid) -> Double {
    let (xdiff, ydiff) = destination - origin
    let result = sqrt(Double(xdiff * xdiff + ydiff * ydiff))

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

// swiftlint:disable identifier_name
func findNthAsteroid(origin: Asteroid, asteroids asteroidsParameter: [Asteroid], n: Int=200) -> Asteroid {
    // swiftlint:enable identifier_name
    var asteroids = asteroidsParameter
    var resultIndex: Int
    var result: Asteroid?

    // Sort isn't sufficient - if there's two asteroids on same angle, we vapourise the first then
    // move to the next angle.
    var angles = Set<Double>()
    for asteroid in asteroids {
        angles.insert(asteroid.angle)
    }
    let searchAngles = angles.sorted()
    var count = 0
    scan: repeat {
        for searchAngle in searchAngles {
            resultIndex = asteroids.firstIndex(where: {$0.angle == searchAngle})!
            result = asteroids.remove(at: resultIndex)
            count += 1
            if count >= n {
                break scan
            }
        }
    } while true
    return result!
}

func dayten(contents: String) throws -> String {
    let solver = DayTenSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(solver.solvePartTwo())"
}
