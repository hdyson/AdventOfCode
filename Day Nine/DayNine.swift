//
//  DayNine.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 30/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

enum DayNineParseError: Error {
    case invalidMode
}

class DayNineParser: DaySevenParser {
    var relativeBase = 0

    // `execute` has cyclomatic_complexity of 11; default swiftlint limit is 10.  Don't see a good way to reduce
    // complexity further though.
    // swiftlint:disable cyclomatic_complexity
    override func execute(programme: [Int]) throws -> [Int] {

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

    func relativeBaseOffset() {
        // swiftlint:disable force_try
        let operands = try! getOperands(pointer: instructionPointer)
        relativeBase += operands.firstOperand
        instructionPointer += 2
    }

    override func getOperands(pointer instructionPointer: Int) throws -> (firstOperand: Int, secondOperand: Int) {
        let parameterModes = getModes()
        var firstOperand = 0
        var secondOperand = 0
        if parameterModes.count == 0 {
            growElements(newSize: elements[elements[instructionPointer + 1]])
            firstOperand = elements[elements[instructionPointer + 1]]
            growElements(newSize: elements[elements[instructionPointer + 2]])
            secondOperand = elements[elements[instructionPointer + 2]]
        } else if parameterModes.count == 1 {
            if parameterModes[0] == 0 {
                growElements(newSize: elements[elements[instructionPointer + 1]])
                firstOperand = elements[elements[instructionPointer + 1]]
            } else if parameterModes[0] == 1 {
                growElements(newSize: elements[instructionPointer + 1])
                firstOperand = elements[instructionPointer + 1]
            } else if parameterModes[0] == 2 {
                growElements(newSize: elements[relativeBase + elements[instructionPointer + 1]])
                firstOperand = elements[relativeBase + elements[instructionPointer + 1]]
            } else {
                throw DayNineParseError.invalidMode
            }
            growElements(newSize: elements[instructionPointer + 2])
            growElements(newSize: elements[elements[instructionPointer + 2]])
            secondOperand = elements[elements[instructionPointer + 2]]
        } else if parameterModes.count == 2 {
            if parameterModes[1] == 0 {
                growElements(newSize: elements[elements[instructionPointer + 1]])
                firstOperand = elements[elements[instructionPointer + 1]]
            } else if parameterModes[1] == 1 {
                growElements(newSize: elements[instructionPointer + 1])
                firstOperand = elements[instructionPointer + 1]
            } else if parameterModes[1] == 2 {
                growElements(newSize: elements[relativeBase + elements[instructionPointer + 1]])
                firstOperand = elements[relativeBase + elements[instructionPointer + 1]]
            } else {
                throw DayNineParseError.invalidMode
            }
            if parameterModes[0] == 0 {
                growElements(newSize: elements[elements[instructionPointer + 2]])
                secondOperand = elements[elements[instructionPointer + 2]]
            } else if parameterModes[0] == 1 {
                growElements(newSize: elements[instructionPointer + 2])
                secondOperand = elements[instructionPointer + 2]
            } else if parameterModes[0] == 2 {
                growElements(newSize: elements[relativeBase + elements[instructionPointer + 1]])
                firstOperand = elements[relativeBase + elements[instructionPointer + 1]]
            } else {
                throw DayNineParseError.invalidMode
            }
        }
        return(firstOperand, secondOperand)
    }

    func growElements(newSize: Int) {
        if newSize > elements.count {
            let newElements = Array(repeating: 0, count: (newSize - elements.count + 1))
            elements.append(contentsOf: newElements)
        }
    }

    override func setOutput() {
        let modes = getModes()
        var newOutput = 0
        if modes.count > 0 {
            if modes[0] == 1 {
                growElements(newSize: instructionPointer + 1)
                newOutput = elements[instructionPointer + 1]
            } else if modes[0] == 2 {
                growElements(newSize: elements[relativeBase + elements[instructionPointer + 1]])
                newOutput = elements[relativeBase + elements[instructionPointer + 1]]
            } else {
                growElements(newSize: elements[instructionPointer + 1])
                newOutput = elements[elements[instructionPointer + 1]]
            }
        } else {
            growElements(newSize: elements[instructionPointer + 1])
            newOutput = elements[elements[instructionPointer + 1]]
        }
        output.append(newOutput)
        instructionPointer += 2
    }
}

func daynine(contents: String) throws -> String {
    let partOne = DayNineParser()
    partOne.input = 1
    _ = try partOne.parse(script: contents)
    return "Part 1: \(partOne.output)"
}
