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

    func solvePartOne() {
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
    }

    func solvePartTwo() {
    }
}

class Robot {
    var x: Int
    var y: Int
    var direction: Int  // 0 => up, 1 => right, 2 => down, 3 => left

    init(x xParameter: Int=0, y yParameter: Int=0, direction directionParameter: Int=0) {
        x = xParameter
        y = yParameter
        direction = directionParameter
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
}

func dayeleven(contents: String) throws -> String {
    let solver = DayElevenSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(solver.solvePartTwo())"
}
