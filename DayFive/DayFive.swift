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
    var result = [Int]()

    override func execute(programme: [Int]) throws -> [Int] {
        var instructionPointer = 0
        var elements = programme

        mainloop: repeat {
            let opcode = elements[instructionPointer]
            switch opcode {
            case 1:
                elements[elements[instructionPointer + 3]] = elements[elements[instructionPointer + 1]]
                    + elements[elements[instructionPointer + 2]]
                instructionPointer += 4
            case 2:
                elements[elements[instructionPointer + 3]] = elements[elements[instructionPointer + 1]]
                    * elements[elements[instructionPointer + 2]]
                instructionPointer += 4
            case 3:
                elements[elements[instructionPointer + 1]] = input!
                instructionPointer += 2
            case 4:
                output = elements[elements[instructionPointer + 1]]
                instructionPointer += 2
            case 99:
                break mainloop
            default:
                throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
            }
        } while true
        if output != nil {
            result = [output!]
        } else{
            // preserve day 2 behaviour
            result = elements
        }
        return result
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

    func getModes(instruction: Int) -> [Int] {
        var modes: [Int]
        if instruction.digits.count > 2 {
            modes = instruction.digits
            modes.removeLast()
            modes.removeLast()
        } else {
            modes = []
        }
        return modes
    }
}
