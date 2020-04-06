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
            let opcode = getOpcode(instruction: elements[instructionPointer])
            switch opcode {
            case 1:
                // Addition
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                elements[elements[instructionPointer + 3]] = operands.firstOperand + operands.secondOperand
                instructionPointer += 4
            case 2:
                // Multiplication
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                elements[elements[instructionPointer + 3]] = operands.firstOperand * operands.secondOperand
                instructionPointer += 4
            case 3:
                // Read input
                elements[elements[instructionPointer + 1]] = input!
                instructionPointer += 2
            case 4:
                // Set output
                let modes = getModes(instruction: elements[instructionPointer])
                if modes.count > 0 && modes[0] == 1 {
                    output = elements[instructionPointer + 1]
                } else {
                    output = elements[elements[instructionPointer + 1]]
                }
                instructionPointer += 2
            case 5:
                // Jump if true
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                if operands.firstOperand != 0 {
                    instructionPointer = operands.secondOperand
                } else {
                    instructionPointer += 3
                }
            case 6:
                // Jump if false
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                if operands.firstOperand == 0 {
                    instructionPointer = operands.secondOperand
                } else {
                    instructionPointer += 3
                }
            case 7:
                // less than
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                if operands.firstOperand < operands.secondOperand {
                    elements[elements[instructionPointer + 3]] = 1
                } else {
                    elements[elements[instructionPointer + 3]] = 0
                }
                instructionPointer += 4
            case 8:
                // equals
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                if operands.firstOperand == operands.secondOperand {
                    elements[elements[instructionPointer + 3]] = 1
                } else {
                    elements[elements[instructionPointer + 3]] = 0
                }
                instructionPointer += 4
            case 99:
                break mainloop
            default:
                throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
            }
        } while true
        if output != nil {
            result = [output!]
        } else {
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

    func getOperands(pointer instructionPointer: Int, elements: [Int]) -> (firstOperand: Int, secondOperand: Int) {
        let parameterModes = getModes(instruction: elements[instructionPointer])
        var firstOperand = 0
        var secondOperand = 0
        if parameterModes.count == 0 {
            firstOperand = elements[elements[instructionPointer + 1]]
            secondOperand = elements[elements[instructionPointer + 2]]
        } else if parameterModes.count == 1 {
            if parameterModes[0] == 0 {
                firstOperand = elements[elements[instructionPointer + 1]]
            } else {
                firstOperand = elements[instructionPointer + 1]
            }
            secondOperand = elements[elements[instructionPointer + 2]]
        } else if parameterModes.count >= 2 {
            if parameterModes[1] == 0 {
                firstOperand = elements[elements[instructionPointer + 1]]
            } else {
                firstOperand = elements[instructionPointer + 1]
            }
            if parameterModes[0] == 0 {
                secondOperand = elements[elements[instructionPointer + 2]]
            } else {
                secondOperand = elements[instructionPointer + 2]
            }
        }
        return(firstOperand, secondOperand)
    }
}

func dayfive(partOneInput: Int, partTwoInput: Int, contents: String) throws -> String {
    let part1 = DayFiveParser()
    part1.input = partOneInput
    _ = try part1.parse(script: contents)
    let part2 = DayFiveParser()
    part2.input = partTwoInput
    _ = try part2.parse(script: contents)
    return "Part 1: \(part1.output!)  Part 2: \(part2.output!)"
}
