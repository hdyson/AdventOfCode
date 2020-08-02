//
//  IntCode.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 09/06/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

// This file includes the IntCode computer common to several days puzzles, while day-specific functionality is handled
// in sub classes.

import Foundation

enum ParseError: Error {
    case invalidOpcode(opcode: Int)
    case invalidMode(name: String, mode: Int)
}

class Computer {
    let separator=","

    var memory = ExtensibleArray()
    var instructionPointer = 0
    var input: Int?
    var output = [Int]()
    var relativeBase = 0  // Added day 9
    var parameterModes = [Int]()
    var finished = false  // Added day 7, needed for 11 too

    init () {
        instructionPointer = 0
    }

    func parse(script: String) {
        // Interprets script as instructions for IntCode computer
        let cleanedScript = script.trimmingCharacters(in: .whitespacesAndNewlines)
        let elementString = cleanedScript.components(separatedBy: separator)
        memory = ExtensibleArray(elementString.map {Int($0)!})
    }

    func parseAndExecute(script: String) throws -> String {
        // Needed to fit the requirements for day 2, but most usages should call parse and execute
        // individually.  Gives the memory state as a string for output.
        parse(script: script)
        memory = try execute(programme: memory)

        let resultStrings = memory.asStringArray()
        return resultStrings.joined(separator: separator)
    }

    // `execute` has cyclomatic_complexity of 11; default swiftlint limit is 10.  Don't see a good way to reduce
    // complexity further though.
    // swiftlint:disable cyclomatic_complexity
    func execute() throws -> ExtensibleArray {
        // Loops over each instruction, getting the opcodes and parameter modes from the instruction.  Then calls out
        // to relevant function depending on opcode.  Parameter modes is an instance attribute to reduce duplication of
        // passing as parameter to every single method.

        // see opcode methods for description of each; and getModes for description of parameter modes.

        // Note programme can modify itself.

        mainloop: repeat {
            let opcode = getOpcode()
            parameterModes = getModes()
            switch opcode {
            case 1:
                try addition()
            case 2:
                try multiplication()
            case 3:
                if input == nil {
                    break mainloop
                }
                try readInput()
            case 4:
                try setOutput()
            case 5:
                try jumpIfTrue()
            case 6:
                try jumpIfFalse()
            case 7:
                try lessThan()
            case 8:
                try equals()
            case 9:
                try relativeBaseOffset()
            case 99:
                finished = true  // Days 7 and 11 need this
                break mainloop
            default:
                throw ParseError.invalidOpcode(opcode: memory[instructionPointer])
            }
        } while true
        return memory
    }

    func execute(programme: ExtensibleArray) throws -> ExtensibleArray {
        memory = programme
        return try execute()
    }

    func addition() throws {
        // Adds first two operands (after interpretation via parameter modes) and writes result to third operand.
        let operands = try getOperands(pointer: instructionPointer)
        // 0 for parameter mode of last parameter (parameter mdoes are rtl)
        try memory[getAddress(mode: parameterModes[0], offset: 3)] = operands.firstOperand + operands.secondOperand
        instructionPointer += 4
    }

    func multiplication() throws {
        // Multiplies first two operands (after interpretation via parameter modes) and writes result to third operand.
        let operands = try getOperands(pointer: instructionPointer)
        // 0 for parameter mode of last parameter (parameter mdoes are rtl)
        try memory[getAddress(mode: parameterModes[0], offset: 3)] = operands.firstOperand * operands.secondOperand
        instructionPointer += 4
    }

    func readInput() throws {
        // Read only operand (after interpretation via parameter modes) into input instance property

        // Why last element of parameter modes here?  Only one parameter for output, but parameter modes has been padded
        // with initial zeros to handle 3 parameters.  So only the last value is freom the input data.
        try memory[getAddress(mode: parameterModes.removeLast(), offset: 1)]  = input!
        instructionPointer += 2
        input = nil
    }

    func setOutput() throws {
        // Write only operand (after interpretation via parameter modes) into output instance property

        // Why last element of parameter modes here?  Only one parameter for output, but parameter modes has been padded
        // with initial zeros to handle 3 parameters.  So only the last value is freom the input data.
        output.append(try memory[getAddress(mode: parameterModes.removeLast(), offset: 1)])
        instructionPointer += 2
    }

    func jumpIfTrue() throws {
        // Jump (by setting instruction pointer) to second operand if first operand is non-zero
        let operands = try getOperands(pointer: instructionPointer)
        if operands.firstOperand != 0 {
            instructionPointer = operands.secondOperand
        } else {
            instructionPointer += 3
        }
    }

    func jumpIfFalse() throws {
        // Jump (by setting instruction pointer) to second operand if first operand is zero
        let operands = try getOperands(pointer: instructionPointer)
        if operands.firstOperand == 0 {
            instructionPointer = operands.secondOperand
        } else {
            instructionPointer += 3
        }
    }

    func equals() throws {
        // After interpreting all operands via parameter modes, if first two operands are equal, write 1 to third
        // operand.  Otherwise, write 0 to third operand.
        let result: Int
        let operands = try getOperands(pointer: instructionPointer)
        if operands.firstOperand == operands.secondOperand {
            result = 1
        } else {
            result = 0
        }
        try memory[getAddress(mode: parameterModes[0], offset: 3)] = result
        instructionPointer += 4
    }

    func relativeBaseOffset() throws {
        // Add only operand (after interpretation via parameter modes) to relative base property (-ve offset values
        // are allowed).
        let operands = try getOperands(pointer: instructionPointer)
        relativeBase += operands.firstOperand
        instructionPointer += 2
    }

    func getInstruction() -> Int {
        return memory[instructionPointer]
    }

    func lessThan() throws {
        // After interpreting all operands via parameter modes, if first operands less than second, write 1 to third
        // operand.  Otherwise, write 0 to third operand.
        let result: Int
        let operands = try getOperands(pointer: instructionPointer)
        if operands.firstOperand < operands.secondOperand {
            result = 1
        } else {
            result = 0
        }
        // 0 for parameter mode of last parameter (parameter mdoes are rtl)
        let address = try getAddress(mode: parameterModes[0], offset: 3)
        memory[address] = result
        instructionPointer += 4
    }

    func getResult() -> ExtensibleArray {
        let result: ExtensibleArray
        if output.count != 0 {
            result = ExtensibleArray(output)
        } else {
            // preserve day 2 behaviour
            result = memory
        }
        return result
    }

    func getOpcode() -> Int {
        // trailing 2 digits of instruction where there's 2 or more digits in the instruction are the
        // opcode.  If only one digit in instruction, that's the opcode.
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
        // Parameter modes affect how the operands are interpreted.  If 1 (i.e. immediate mode), the value itself is
        // used.  If 0 (i.e. position mode), the value at the memory address pointed to by the parameter is used.
        // If 2 (i.e. relative mode), the value at the memory address pointed to by the
        // (parameter + the relative base property) is used.

        // Note parametermodes is rtl, and is zero padded to always be three values.
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
        // offset is number of addresses from mode/opcodes to operand - so 1 for first operand, N for Nth operand.
        let modeNames: [Int: String] = [0: "position", 1: "immediate", 2: "relative"]
        let modeName = modeNames[mode]

        let address: Int
        switch modeName {
        case "position":
            address = memory[instructionPointer + offset]
        case "immediate":
            address = instructionPointer + offset
        case "relative":
            address = memory[instructionPointer + offset] + relativeBase
        default:
            throw ParseError.invalidMode(name: modeName ?? "", mode: mode)
        }
        return address
    }

    func getOperands(pointer instructionPointer: Int) throws -> (firstOperand: Int, secondOperand: Int) {
        let firstOperand: Int
        let secondOperand: Int

        // As per puzzle text, parameter modes are rtl while instructions are ltr.
        firstOperand = try memory[getAddress(mode: parameterModes[2], offset: 1)]
        secondOperand = try memory[getAddress(mode: parameterModes[1], offset: 2)]
        return(firstOperand, secondOperand)
    }
}
