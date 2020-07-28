//
//  DayTwelve.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 28/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

struct DayTwelveSolver {
    let data: String

    func solvePartOne() -> Int {
        // Requirements:
        // 1. Construct Moons such that each moon has three positions and three velocities
        // 2. For each moon, update velocities based on other moon positions
        // 3. For each moon, update velocities based on new moon positions
        // 4. Repeat for 1000 iterations
        // 5. Calculate energy in system
        return 0
    }

    func solvePartTwo() -> Int {
        return 0
    }
}

struct Position {
    var x: Int
    var y: Int
    var z: Int
}

struct Velocity {
    var x: Int
    var y: Int
    var z: Int
}

struct Moon {
    var position: Position
    // Initial velocity is always 0
    var velocity = Velocity(x: 0, y: 0, z: 0)
}

func constructMoons(input: String) -> [Moon] {
    var moons = [Moon]()
    for line in input.components(separatedBy: "\n") {
        let components = line.components(separatedBy: ", ")
        // Don't know width of number we're after, but do know widths of boilerplate surrounding values of
        // interest.  So rather than pick out values, delete boilerplate.
        var x = components[0]
        x.removeFirst(3)
        var y = components[1]
        y.removeFirst(2)
        var z = components[2]
        z.removeFirst(2)
        z.removeLast(1)
        moons.append(Moon(position: Position(x: Int(x)!, y: Int(y)!, z: Int(z)!)))
    }
    return moons
}

func daytwelve(contents: String) throws -> String {
    let solver = DayTwelveSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(solver.solvePartTwo())"
}
