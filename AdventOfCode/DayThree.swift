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
}


class DayThree{
    var line = [Set<Point>(), Set<Point>()]
    var current_point : Point
    
    init(){
        self.current_point = Point(x:0, y:0)
    }
    
    func parse (input:String) throws {
        for (index, input_line) in input.components(separatedBy: "\n").enumerated() {
            if index > 2 {
                print("Too many input lines")
                exit(EXIT_FAILURE)
            }
            current_point = Point(x: 0, y: 0)
            // split line on , to get each instruction
            let instructions = input_line.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
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
                            current_point = Point(x: current_point.x, y: current_point.y + 1)
                        case "D":
                            current_point = Point(x: current_point.x, y: current_point.y - 1)
                        case "R":
                            current_point = Point(x: current_point.x + 1, y: current_point.y)
                        case "L":
                            current_point = Point(x: current_point.x - 1, y: current_point.y)
                        default:
                            throw InstructionError.invalidDirection(direction: direction)
                    }
                    line[index].insert(current_point)
                }
            }
        }
    }
    
    func manhattan_distance (input: Point) -> Int {
        return abs(input.y) + abs(input.x)
    }
    
    func solve(script:String) -> Int {
        try! parse(input: script)
        let crossings = line[0].intersection(line[1])
        let distances = crossings.map( {manhattan_distance(input: $0)} )
        return distances.min()!
    }
    
}

func daythree(contents:String) -> Int {
    let solver = DayThree()
    return solver.solve(script: contents)
}

