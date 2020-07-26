//
//  DayThree.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 16/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

enum InstructionError: Error {
    case invalidDirection(direction: Character)
}

class DayThree {
    var line = [Set<Point>(), Set<Point>()]
    var currentPoint: Point

    init() {
        self.currentPoint = Point()
    }

    func parse (input: String) throws {
        for (index, inputLine) in input.components(separatedBy: "\n").enumerated() {
            if index > 2 {
                print("Too many input lines")
                exit(EXIT_FAILURE)
            }
            currentPoint = Point()
            // split line on , to get each instruction
            let instructions = inputLine.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
            var stepCount = 1
            for var instruction in instructions {
                if instruction == "" {
                    continue
                }
                let direction = instruction[instruction.startIndex]
                instruction.remove(at: instruction.startIndex)
                let magnitude = Int(instruction)!
                for _ in 0 ... magnitude - 1 {
                    switch direction {
                    case "U":
                        currentPoint = Point(x: currentPoint.x, y: currentPoint.y + 1, index: stepCount)
                    case "D":
                        currentPoint = Point(x: currentPoint.x, y: currentPoint.y - 1, index: stepCount)
                    case "R":
                        currentPoint = Point(x: currentPoint.x + 1, y: currentPoint.y, index: stepCount)
                    case "L":
                        currentPoint = Point(x: currentPoint.x - 1, y: currentPoint.y, index: stepCount)
                    default:
                        throw InstructionError.invalidDirection(direction: direction)
                    }
                    line[index].insert(currentPoint)
                    stepCount += 1
                }
            }
        }
    }

    func manhattan_distance (input: Point) -> Int {
        return abs(input.y) + abs(input.x)
    }

    func minimum_distance(script: String) throws -> Int {
        try parse(input: script)
        let crossings = line[0].intersection(line[1])
        let distances = crossings.map({manhattan_distance(input: $0)})
        return distances.min()!
    }

    func step_distance(input: Point) -> Int {
        return input.index
    }

    func get_crossings_with_summed_indices() -> [Point] {
        var result = [Point]()
        let noncrossings = line[0].symmetricDifference(line[1])

        for point1 in line[0].subtracting(noncrossings) {
            for point2 in line[1].subtracting(noncrossings) where point1 == point2 {
                result.append(Point(x: point1.x, y: point1.y, index: point1.index + point2.index))
            }
        }
        return result
    }

    func minimum_steps(script: String) throws -> Int {
        try parse(input: script)
        let crossings = get_crossings_with_summed_indices()
        let distances = crossings.map({step_distance(input: $0)})
        return distances.min()!
    }

}

func daythree(contents: String) throws -> String {
    let solver = DayThree()
    let part1 = "part 1: " + String(try solver.minimum_distance(script: contents))
    let part2 = " part 2: " + String(try solver.minimum_steps(script: contents))
    return part1 + part2
}
