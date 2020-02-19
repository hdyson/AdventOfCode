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
            let instructions = input_line.components(separatedBy: ",")
            for var instruction in instructions{
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
    
    func solve(script:String) -> Int {
        return 0
    }
    
}

func daythree(contents:String) -> String {
    return contents
}

