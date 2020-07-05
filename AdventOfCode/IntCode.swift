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

class ExtensibleArray {

    // A dict with an array-like interface.

    var backingStore: [Int: Int] = [:]

    init (_ values: [Int]) {
        for (index, value) in values.enumerated() {
            backingStore[index] = value
        }
    }

    init () {
    }

    subscript (index: Int) -> Int {
        // Swift magic method to implement [] syntax
        get {
            var result: Int
            result = backingStore[index, default: 0]
            return result
        }
        set(newValue) {
            backingStore[index] = newValue
        }
    }

    func asStringArray () -> [String] {
        var maxKey = 0
        for key in backingStore.keys where key > maxKey {
            maxKey = key
        }
        var result = Array(repeating: "0", count: maxKey + 1)
        for (key, value) in backingStore {
            result[key] = String(value)
        }
        return result
    }
}

class Computer {
    let separator=","

    let noun: Int?
    let verb: Int?
    var elements = ExtensibleArray()
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
            let resultStrings = elements.asStringArray()
            return resultStrings.joined(separator: separator)
        } else {
            let elementString = script.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separator)
            elements = ExtensibleArray(elementString.map {Int($0)!})

            // 1202 fix (see puzzle text: https://adventofcode.com/2019/day/2 final paragraph):
            if noun != nil {
                elements[1] = noun!
            }
            if verb != nil {
                elements[2] = verb!
            }
            elements = try execute(programme: elements)

            let resultStrings = elements.asStringArray()
            return resultStrings.joined(separator: separator)
        }
    }

    // `execute` has cyclomatic_complexity of 11; default swiftlint limit is 10.  Don't see a good way to reduce
    // complexity further though.
    // swiftlint:disable cyclomatic_complexity
    func execute(programme: ExtensibleArray) throws -> ExtensibleArray {
        elements = programme

        if finished == false {
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
                    jumpIfTrue()
                case 6:
                    jumpIfFalse()
                case 7:
                    try lessThan()
                case 8:
                    try equals()
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
    func addition() throws {
        let operands = try getOperands(pointer: instructionPointer)
        // 0 for parameter mode of last parameter (parameter mdoes are rtl)
        try elements[getAddress(mode: parameterModes[0], offset: 3)] = operands.firstOperand + operands.secondOperand
        instructionPointer += 4
    }

    func multiplication() throws {
        let operands = try getOperands(pointer: instructionPointer)
        try elements[getAddress(mode: parameterModes[0], offset: 3)] = operands.firstOperand * operands.secondOperand
        instructionPointer += 4
    }

    func readInput() throws {
        if phaseUsed == false {
            try elements[getAddress(mode: parameterModes.removeLast(), offset: 1)]  = phase!
            instructionPointer += 2
            phaseUsed = true
        } else {
            try elements[getAddress(mode: parameterModes.removeLast(), offset: 1)]  = input!
            instructionPointer += 2
            input = nil
        }
    }

    func setOutput() throws {
        // Why last element of parameter modes here?  Only one parameter for output, but parameter modes has been padded
        // with initial zeros to handle 3 parameters.  So only the last value is freom the input data.
        output.append(try elements[getAddress(mode: parameterModes.removeLast(), offset: 1)])
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

    func equals() throws {
        // equals
        let result: Int
        let operands = try! getOperands(pointer: instructionPointer)
        if operands.firstOperand == operands.secondOperand {
            result = 1
        } else {
            result = 0
        }
        try elements[getAddress(mode: parameterModes[0], offset: 3)] = result
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

    func lessThan() throws {
        let result: Int
        let operands = try! getOperands(pointer: instructionPointer)
        if operands.firstOperand < operands.secondOperand {
            result = 1
        } else {
            result = 0
        }
        // 0 for parameter mode of last parameter (parameter mdoes are rtl)
        let address = try getAddress(mode: parameterModes[0], offset: 3)
        elements[address] = result
        instructionPointer += 4
    }

    func getResult() -> ExtensibleArray {
        let result: ExtensibleArray
        if output.count != 0 {
            result = ExtensibleArray(output)
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
