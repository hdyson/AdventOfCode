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
    case invalidMode(name: String, mode: Int)
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
    var relativeBase = 0
    var parameterModes = [Int]()

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
                parameterModes = getModes()
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
                    try setOutput()
                case 5:
                    jumpIfTrue()
                case 6:
                    jumpIfFalse()
                case 7:
                    lessThan()
                case 8:
                    equals()
                case 9:
                    relativeBaseOffset()
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

    func setOutput() throws {
        // Why last element of parameter modes here?  Only one parameter for output, but parameter modes has been padded
        // with initial zeros to handle 3 parameters.  So only the last value is freom the input data.
        output = [try elements[getAddress(mode: parameterModes.removeLast(), offset: 1)]]
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

    func relativeBaseOffset() {
        // swiftlint:disable force_try
        let operands = try! getOperands(pointer: instructionPointer)
        relativeBase += operands.firstOperand
        instructionPointer += 2
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
            modes = [0, 0, 0]
        }
        while modes.count < 3 {
            modes.insert(0, at: 0)
        }
        return modes
    }

    func getAddress(mode: Int, offset: Int) throws -> Int {
        // mode is integer from puzzle
        // offset is number of addresses from mode/opcodes to operand - so 1 for first operand.
        let modeNames: [Int: String] = [0: "position", 1: "immediate", 2: "relative"]
        let modeName = modeNames[mode]

        let address: Int
        switch modeName {
        case "position":
            address = elements[instructionPointer + offset]
        case "immediate":
            address = instructionPointer + offset
        case "relative":
            address = elements[instructionPointer + offset] + relativeBase
        default:
            throw ParseError.invalidMode(name: modeName ?? "", mode: mode)
        }
        return address
    }

    func getOperands(pointer instructionPointer: Int) throws -> (firstOperand: Int, secondOperand: Int) {
        let firstOperand: Int
        let secondOperand: Int

        // As per puzzle text, parameter modes are rtl while instructions are ltr.
        firstOperand = try elements[getAddress(mode: parameterModes[2], offset: 1)]
        secondOperand = try elements[getAddress(mode: parameterModes[1], offset: 2)]
        return(firstOperand, secondOperand)
    }
}
