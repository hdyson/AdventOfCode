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
    // Necessary behaviour:
    // 1. Initial values create a contiguous array
    // 2. Access to value:
    //     1. Check if position in any existing array
    //         If not:
    //              1. creates new array of N elements initialised to 0
    //              2. Store start value and length of new array
    //              3. Check new array not adjacent to existing array (if so, merge - non-zero value wins if overlap)
    var backingStore = [[Int]]()
    var backingStoreStartIndices = [Int]()
    let newArraySize = 40  // Arbitrary - instruction up to 4 integers wide, so gives enough room for at least 10 instructions.

    init (_ values: [Int]) {
        backingStore.append(values)
        backingStoreStartIndices.append(0)
    }

    init () {
        backingStore.append([Int]())
        backingStoreStartIndices.append(0)
    }

    subscript (index: Int) -> Int {
        // Swift magic method to implement [] syntax
        get {
            var result : Int?
            var valueFound = false
            for arrayIndex in 0..<backingStore.count {
                let arrayStart = backingStoreStartIndices[arrayIndex]
                let arrayEnd = arrayStart + backingStore[arrayIndex].count
                if arrayStart <= index && index <= arrayEnd {
                    result = backingStore[arrayIndex][index - backingStoreStartIndices[arrayIndex]]
                    valueFound = true
                    break
                }
            }
            if !valueFound {
                growArray(index)
                result = 0
            }
            return result ?? 0
        }
        set(newValue) {
            if index < backingStore[0].count {
                backingStore[0][index] = newValue
            } else {
                growArray(index)
                let arrayIndex = backingStore.count - 1
                backingStore[arrayIndex][index - backingStoreStartIndices[arrayIndex]] = newValue
            }
        }
    }

    func map (function: (Int) -> Int) -> [Int] {
        return backingStore[0].map(function)
    }

    func map (function: (Int) -> String) -> [String] {
        return backingStore[0].map(function)
    }

    func growArray(_ index: Int) {
        backingStoreStartIndices.append(index)
        let newArray = Array(repeating: 0, count: newArraySize)
        backingStore.append(newArray)
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
            let resultStrings = elements.map {String($0)}
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

            let resultStrings = elements.map {String($0)}
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
        try elements[getAddress(mode: parameterModes.removeLast(), offset: 3)] = operands.firstOperand * operands.secondOperand
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

    func equals() throws {
        // equals
        let result: Int
        let operands = try! getOperands(pointer: instructionPointer)
        if operands.firstOperand == operands.secondOperand {
            result = 1
        } else {
            result = 0
        }
        try elements[getAddress(mode: parameterModes.removeLast(), offset: 3)] = result
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
        let result : ExtensibleArray
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
