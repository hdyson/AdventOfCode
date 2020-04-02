//
//  DayFive.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 28/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayFiveParser: DayTwoParser {

    var input: Int?
    var output: Int?

    override func execute(programme: [Int]) throws -> [Int] {
        var instructionPointer = 0
        var elements = programme

        mainloop: repeat {
            let opcode = elements[instructionPointer]
            switch opcode {
            case 1:
                elements[elements[instructionPointer + 3]] = elements[elements[instructionPointer + 1]]
                    + elements[elements[instructionPointer + 2]]
            case 2:
                elements[elements[instructionPointer + 3]] = elements[elements[instructionPointer + 1]]
                    * elements[elements[instructionPointer + 2]]
            case 3:
                elements[elements[instructionPointer + 1]] = input!
            case 4:
                output = elements[elements[instructionPointer + 1]]
            case 99:
                break mainloop
            default:
                throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
            }
            switch opcode {
            case 1, 2:
                instructionPointer += 4
            case 3, 4:
                instructionPointer += 2
            default:
                throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
            }
        } while true
        return elements
    }

    override func getOpcode(instruction: Int) -> Int {
        let digits = instruction.digits
        let units = digits[digits.count - 1]
        var result = units
        if digits.count > 1 {
            let tens = digits[digits.count - 2]
            result = 10 * tens + units
        }
        return result
    }
}
