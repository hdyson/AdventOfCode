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
        let moons = constructMoons(input: data)
        for _ in 0..<1000 {
            for moon in moons {
                moon.applyGravity(moons: moons)
            }
            for moon in moons {
                moon.applyVelocity()
            }
        }
        var energy = 0
        for moon in moons {
            energy += moon.calculateEnergy()
        }
        return energy
    }

    func solvePartTwo() -> Int {
        return 0
    }
}

struct Vector {
    //swiftlint:disable identifier_name
    var x: Int
    var y: Int
    var z: Int
    //swiftlint:enable identifier_name

    static func - (lhs: Vector, rhs: Vector) -> Vector {
        var result = Vector(x: 0, y: 0, z: 0)
        if lhs.x > rhs.x {
            result.x = -1
        } else if lhs.x < rhs.x {
            result.x = 1
        }
        if lhs.y > rhs.y {
            result.y = -1
        } else if lhs.y < rhs.y {
            result.y = 1
        }
        if lhs.z > rhs.z {
            result.z = -1
        } else if lhs.z < rhs.z {
            result.z = 1
        }
        return result
    }

    static func + (lhs: Vector, rhs: Vector) -> Vector {
        var result = Vector(x: 0, y: 0, z: 0)
        result.x = lhs.x + rhs.x
        result.y = lhs.y + rhs.y
        result.z = lhs.z + rhs.z
        return result
    }
}

class Moon {
    var position: Vector
    // Initial velocity is always 0
    var velocity = Vector(x: 0, y: 0, z: 0)

    init(position positionParameter: Vector) {
        position = positionParameter
    }

    // swiftlint:disable shorthand_operator
    func applyGravity(moons: [Moon]) {
        for moon in moons {
            let difference = position - moon.position
            velocity = velocity + difference
        }
    }

    func applyVelocity() {
        position = position + velocity
    }
    // swiftlint:enable shorthand_operator

    func calculateEnergy() -> Int {
        let potentialEnergy = abs(position.x) + abs(position.y) + abs(position.z)
        let kineticEnergy = abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
        return potentialEnergy * kineticEnergy
    }
}

func constructMoons(input: String) -> [Moon] {
    var moons = [Moon]()
    for line in input.components(separatedBy: "\n") {
        let components = line.components(separatedBy: ", ")
        // Ignore blank line at end of file:
        if components.count > 1 {
            // Don't know width of number we're after, but do know widths of boilerplate surrounding values of
            // interest.  So rather than pick out values, delete boilerplate.
            // swiftlint:disable identifier_name
            var x = components[0]
            x.removeFirst(3)
            var y = components[1]
            y.removeFirst(2)
            var z = components[2]
            // swiftlint:enable identifier_name
            z.removeFirst(2)
            z.removeLast(1)
            moons.append(Moon(position: Vector(x: Int(x)!, y: Int(y)!, z: Int(z)!)))
        }
    }
    return moons
}

func daytwelve(contents: String) throws -> String {
    let solver = DayTwelveSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(solver.solvePartTwo())"
}
