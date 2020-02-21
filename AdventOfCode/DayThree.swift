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


struct Point : Hashable {
    var x=0
    var y=0
    var index = 0
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}


class DayThree{
    var line = [Set<Point>(), Set<Point>()]
    var current_point : Point
    
    init(){
        self.current_point = Point()
    }
    
    func parse (input:String) throws {
        for (index, input_line) in input.components(separatedBy: "\n").enumerated() {
            if index > 2 {
                print("Too many input lines")
                exit(EXIT_FAILURE)
            }
            current_point = Point()
            // split line on , to get each instruction
            let instructions = input_line.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
            var step_count = 1
            for var instruction in instructions{
                if instruction == "" {
                    continue
                }
                let direction = instruction[instruction.startIndex]
                instruction.remove(at: instruction.startIndex)
                let magnitude = Int(instruction)!
                for _ in 0 ... magnitude - 1 {
                    switch direction {
                        case "U":
                            current_point = Point(x: current_point.x, y: current_point.y + 1, index: step_count)
                        case "D":
                            current_point = Point(x: current_point.x, y: current_point.y - 1, index: step_count)
                        case "R":
                            current_point = Point(x: current_point.x + 1, y: current_point.y, index: step_count)
                        case "L":
                            current_point = Point(x: current_point.x - 1, y: current_point.y, index: step_count)
                        default:
                            throw InstructionError.invalidDirection(direction: direction)
                    }
                    line[index].insert(current_point)
                    step_count += 1
                }
            }
        }
    }
    
    func manhattan_distance (input: Point) -> Int {
        return abs(input.y) + abs(input.x)
    }
    
    func minimum_distance(script:String) -> Int {
        try! parse(input: script)
        let crossings = line[0].intersection(line[1])
        let distances = crossings.map( {manhattan_distance(input: $0)} )
        return distances.min()!
    }
    
    func step_distance(input: Point) -> Int {
        return input.index
    }
    
    func get_crossings_with_summed_indices() -> [Point] {
        var result = [Point]()
        let noncrossings = line[0].symmetricDifference(line[1])

        for point1 in line[0].subtracting(noncrossings){
            for point2 in line[1].subtracting(noncrossings){
                if point1 == point2{
                    result.append(Point(x: point1.x, y:point1.y, index: point1.index + point2.index))
                }
            }
        }
        return result
    }
    
    func minimum_steps(script:String) -> Int {
        try! parse(input: script)
        let crossings = get_crossings_with_summed_indices()
        let distances = crossings.map( {step_distance(input: $0)} )
        return distances.min()!
    }
    
}

func daythree(contents:String) -> String {
    let solver = DayThree()
    return "part 1: " + String(solver.minimum_distance(script: contents)) + " part 2: " + String(solver.minimum_steps(script: contents))
}

