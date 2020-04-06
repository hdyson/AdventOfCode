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

    // `execute` has cyclomatic_complexity of 11; default swiftlint limit is 10.  Don't see a good way to reduce
    // complexity further though.
    // swiftlint:disable cyclomatic_complexity
    override func execute(programme: [Int]) throws -> [Int] {
        instructionPointer = 0
        elements = programme

        mainloop: repeat {
            let opcode = getOpcode()
            switch opcode {
            case 1:
                addition()
            case 2:
                multiplication()
            case 3:
                readInput()
            case 4:
                setOutput()
            case 5:
                jumpIfTrue()
            case 6:
                jumpIfFalse()
            case 7:
                lessThan()
            case 8:
                equals()
            case 99:
                break mainloop
            default:
                throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
            }
        } while true

        let result = getResult()

        return result
    }
    // swiftlint:enable cyclomatic_complexity

    func addition() {
        let operands = getOperands(pointer: instructionPointer)
        elements[elements[instructionPointer + 3]] = operands.firstOperand + operands.secondOperand
        instructionPointer += 4
    }

    func multiplication() {
        let operands = getOperands(pointer: instructionPointer)
        elements[elements[instructionPointer + 3]] = operands.firstOperand * operands.secondOperand
        instructionPointer += 4
    }

    func readInput() {
        elements[elements[instructionPointer + 1]] = input!
        instructionPointer += 2
    }

    func setOutput() {
        let modes = getModes()
        if modes.count > 0 && modes[0] == 1 {
            output = elements[instructionPointer + 1]
        } else {
            output = elements[elements[instructionPointer + 1]]
        }
        instructionPointer += 2
    }

    func jumpIfTrue() {
        let operands = getOperands(pointer: instructionPointer)
        if operands.firstOperand != 0 {
            instructionPointer = operands.secondOperand
        } else {
            instructionPointer += 3
        }
    }

    func jumpIfFalse() {
        let operands = getOperands(pointer: instructionPointer)
        if operands.firstOperand == 0 {
            instructionPointer = operands.secondOperand
        } else {
            instructionPointer += 3
        }
    }

    func equals() {
        // equals
        let operands = getOperands(pointer: instructionPointer)
        if operands.firstOperand == operands.secondOperand {
            elements[elements[instructionPointer + 3]] = 1
        } else {
            elements[elements[instructionPointer + 3]] = 0
        }
        instructionPointer += 4
    }

    func getInstruction() -> Int {
        return elements[instructionPointer]
    }

    func lessThan() {
        let operands = getOperands(pointer: instructionPointer)
        if operands.firstOperand < operands.secondOperand {
            elements[elements[instructionPointer + 3]] = 1
        } else {
            elements[elements[instructionPointer + 3]] = 0
        }
        instructionPointer += 4
    }

    func getResult() -> [Int] {
        var result = [Int]()
        if output != nil {
            result = [output!]
        } else {
            // preserve day 2 behaviour
            result = elements
        }
        return result
    }

    override func getOpcode() -> Int {
        let instruction = getInstruction()
        let digits = instruction.digits
        let units = digits[digits.count - 1]
        var result = units
        if digits.count > 1 {
            let tens = digits[digits.count - 2]
            result = 10 * tens + units
        }
        return result
    }

    func getModes() -> [Int] {
        let instruction = getInstruction()
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

    func getOperands(pointer instructionPointer: Int) -> (firstOperand: Int, secondOperand: Int) {
        let parameterModes = getModes()
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
