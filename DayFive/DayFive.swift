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
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                elements[elements[instructionPointer + 3]] = operands.firstOperand + operands.secondOperand
                instructionPointer += 4
            case 2:
                let operands = getOperands(pointer: instructionPointer, elements: elements)
                elements[elements[instructionPointer + 3]] = operands.firstOperand * operands.secondOperand
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
    
    func getOperands(pointer instructionPointer: Int, elements: [Int]) -> (firstOperand: Int, secondOperand: Int){
        let parameterModes = getModes(instruction: elements[instructionPointer])
        var firstOperand = elements[elements[instructionPointer + 1]]
        var secondOperand = elements[elements[instructionPointer + 2]]
        if parameterModes.count == 1 {
            // Output parameter is always position mode
            firstOperand = elements[elements[instructionPointer + 1]]
            secondOperand = elements[elements[instructionPointer + 2]]
        }
        else if parameterModes.count == 2 {
            firstOperand = elements[elements[instructionPointer + 1]]
            if parameterModes[0] == 0 {
                secondOperand = elements[elements[instructionPointer + 2]]
            } else {
                secondOperand = elements[instructionPointer + 2]
            }
        }
        else if parameterModes.count == 3 {
            if parameterModes[0] == 0 {
                firstOperand = elements[elements[instructionPointer + 1]]
            } else {
                firstOperand = elements[instructionPointer + 1]
            }
            if parameterModes[1] == 0 {
                secondOperand = elements[elements[instructionPointer + 2]]
            } else {
                secondOperand = elements[instructionPointer + 2]
            }
        }
        return(firstOperand, secondOperand)
    }
}
