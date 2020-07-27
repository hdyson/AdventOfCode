//
//  DayEleven.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 26/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

struct DayElevenSolver {
    let data: String

    func solvePartOne() -> Int {
        // Requirements:
        // 1. Result is total number of panels painted
        //    Repeatedly painting same panel does not count
        //    Final panel where robot ends up does not count
        // 2. All panels initially black (0 => black, 1 => white)
        // 3. Use Intcode computer to parse input file
        //    input value of 0 if robot on black panel
        //    input value of 1 if robot on white panel
        //    Two outputs:
        //        1st output: colour to paint panel
        //        2nd output direction for robot to turn
        //            Left 90 degrees if output is 0
        //            Right 90 degrees if output is 1
        // 4. Robot initially pointing up
        // 5. Continue until computer stops
        let robot = Robot(data)
        do {
            try robot.run()
        } catch {
            print("Something went wrong")
        }
        return robot.painted.count
    }

    func solvePartTwo() {
        // Requirements:
        // 1. Start on white panel
        // 2. Will draw eight capital letters
        let robot = Robot(data)
        robot.panel.set(Point(x: 0, y: 0), 1)
        do {
            try robot.run()
        } catch {
            print("Something went wrong")
        }
        robot.panel.printCurrentState()
    }
}

enum RobotError: Error {
    case invalidDirection(direction: Int)
}

class Robot {
    // We really do mean "x" and "y" for the point locations, so disable linter for those names:
    // swiftlint:disable identifier_name
    var x: Int
    var y: Int
    // swiftlint:enable identifier_name
    var direction: Int  // 0 => up, 1 => right, 2 => down, 3 => left
    var panel = Panel()
    var computer = Computer()
    var script = ""
    var painted = Set<Point>()

    init(x xParameter: Int=0, y yParameter: Int=0, direction directionParameter: Int=0, _ script: String) {
        x = xParameter
        y = yParameter
        direction = directionParameter

        // Following replicates computer.parse() except without the initial execution.
        let cleanedScript = script.trimmingCharacters(in: .whitespacesAndNewlines)
        let elementString = cleanedScript.components(separatedBy: ",")
        computer.memory = ExtensibleArray(elementString.map {Int($0)!})
    }

    func run() throws {
        // Before moving, need to run comptuer to interpret colour at current position to determine direction to
        // move.
        var position = Point(x: x, y: y)
        computer.input = panel.get(position)
        repeat {
            // Before moving, need to run computer to interpret colour at current position to determine direction to
            // move.
            position = Point(x: x, y: y)
            computer.input = panel.get(position)
            try _ = computer.execute()
            let colour = computer.output.removeFirst()
            let directionChange = computer.output.removeFirst()
            // Paint panel at current position:
            panel.set(position, colour)
            painted.insert(position)
            // and update direction - note this is before the actual move:
            changeDirection(directionChange)
            try move()
        } while computer.finished == false
    }

    func changeDirection(_ clockwise: Int) {
        if clockwise == 1 {
            direction += 1
        } else {
            direction -= 1
        }
        if direction < 0 {
            direction = 3
        }
        if direction > 3 {
            direction = 0
        }
    }

    func move() throws {
        switch direction {
        case 0:
            y += 1
        case 1:
            x += 1
        case 2:
            y -= 1
        case 3:
            x -= 1
        default:
            throw RobotError.invalidDirection(direction: direction)
        }
    }
}

class Panel {

    // default is black points - hence only need to store the points that are white.
    var whitePoints = Set<Point>()

    func set(_ point: Point, _ value: Int) {
        if value == 0 {
            // painting this point black - i.e. remove it from whitePoints
            if whitePoints.contains(point) {
                whitePoints.remove(point)
            }
        } else {
            // painting this point white - can rely on set uniqueness so no need to check if point is already in
            // whitePoints
            whitePoints.insert(point)
        }
    }

    func get(_ point: Point) -> Int {
        var result = 0
        if whitePoints.contains(point) {
            result = 1
        }
        return result
    }

    func printCurrentState() {
        // start point is 0,0
        var xmin=0
        var xmax=0
        var ymin=0
        var ymax=0

        for point in whitePoints {
            if point.x < xmin {
                xmin = point.x
            } else if point.x > xmax {
                xmax = point.x
            }

            if point.y < ymin {
                ymin = point.y
            } else if point.y > ymax {
                ymax = point.y
            }
        }

        // Empirically, output is upside down so need to reverse y coordinate.
        for yPosition in (ymin...ymax).reversed() {
            for xPosition in xmin...xmax {
                if whitePoints.contains(Point(x: xPosition, y: yPosition)) {
                    print("#", terminator: "")
                } else {
                    print(" ", terminator: "")
                }
            }
            print("\n", terminator: "")
        }
    }
}

func dayeleven(contents: String) throws -> String {
    let solver = DayElevenSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(solver.solvePartTwo())"
}
