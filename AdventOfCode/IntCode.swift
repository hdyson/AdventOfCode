//
//  IntCode.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 09/06/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// swiftlint:disable force_try

import Foundation

enum ParseError: Error {
    case invalidOpcode(opcode: Int)
}

class Computer {
    let separator=","

    let noun: Int?
    let verb: Int?
    var elements = [Int]()
    var instructionPointer = 0
    var input: Int?
    var output = [Int]()
    var phase: Int?
    var phaseUsed = false
    var finished = false
    var name: String

    init (noun: Int? = nil, verb: Int? = nil) {
        self.noun = noun
        self.verb = verb
        name = "undefined"
        instructionPointer = 0
    }

    func parse(script: String = "") throws -> String {
        if script == "" {
            elements = try execute(programme: elements)
            let resultStrings = elements.map {String($0)}
            return resultStrings.joined(separator: separator)
        } else {
            let elementString = script.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separator)
            elements = elementString.map {Int($0)!}

            // 1202 fix (see puzzle text: https://adventofcode.com/2019/day/2 final paragraph):
            if noun != nil {
                elements[1] = noun!
            }
            if verb != nil {
                elements[2] = verb!
            }
            elements = try execute(programme: elements)

            let resultStrings = elements.map {String($0)}
            return resultStrings.joined(separator: separator)
        }
    }

    // `execute` has cyclomatic_complexity of 11; default swiftlint limit is 10.  Don't see a good way to reduce
    // complexity further though.
    // swiftlint:disable cyclomatic_complexity
    func execute(programme: [Int]) throws -> [Int] {
        elements = programme

        if finished == false {
            mainloop: repeat {
                let opcode = getOpcode()
                switch opcode {
                case 1:
                    addition()
                case 2:
                    multiplication()
                case 3:
                    if input == nil {
                        break mainloop
                    }
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
                    finished = true
                    break mainloop
                default:
                    throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
                }
            } while true
        }
        return elements
    }
    // swiftlint:enable cyclomatic_complexity

    func addition() {
        let operands = try! getOperands(pointer: instructionPointer)
        elements[elements[instructionPointer + 3]] = operands.firstOperand + operands.secondOperand
        instructionPointer += 4
    }

    func multiplication() {
        let operands = try! getOperands(pointer: instructionPointer)
        elements[elements[instructionPointer + 3]] = operands.firstOperand * operands.secondOperand
        instructionPointer += 4
    }

    func readInput() {
        if phaseUsed == false {
            elements[elements[instructionPointer + 1]] = phase!
            instructionPointer += 2
            phaseUsed = true
        } else {
            elements[elements[instructionPointer + 1]] = input!
            instructionPointer += 2
            input = nil
        }
    }

    func setOutput() {
        let modes = getModes()
        if modes.count > 0 && modes[0] == 1 {
            output = [elements[instructionPointer + 1]]
        } else {
            output = [elements[elements[instructionPointer + 1]]]
        }
        instructionPointer += 2
    }

    func jumpIfTrue() {
        let operands = try! getOperands(pointer: instructionPointer)
        if operands.firstOperand != 0 {
            instructionPointer = operands.secondOperand
        } else {
            instructionPointer += 3
        }
    }

    func jumpIfFalse() {
        let operands = try! getOperands(pointer: instructionPointer)
        if operands.firstOperand == 0 {
            instructionPointer = operands.secondOperand
        } else {
            instructionPointer += 3
        }
    }

    func equals() {
        // equals
        let operands = try! getOperands(pointer: instructionPointer)
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
        let operands = try! getOperands(pointer: instructionPointer)
        if operands.firstOperand < operands.secondOperand {
            elements[elements[instructionPointer + 3]] = 1
        } else {
            elements[elements[instructionPointer + 3]] = 0
        }
        instructionPointer += 4
    }

    func getResult() -> [Int] {
        var result = [Int]()
        if output.count != 0 {
            result = output
        } else {
            // preserve day 2 behaviour
            result = elements
        }
        return result
    }

    func getOpcode() -> Int {
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

    func getOperands(pointer instructionPointer: Int) throws -> (firstOperand: Int, secondOperand: Int) {
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
