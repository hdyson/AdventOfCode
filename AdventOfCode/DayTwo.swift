//
//  DayTwo.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 16/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case invalidOpcode(opcode: Int)
}

/**
Class to solve the day two puzzle of advent of code 2019

The puzzle involves loading a list of integers, and interpreting them as a list of operators and operands (similar to
a simplified turing machine).
 
See https://adventofcode.com/2019/day/2 for the details of the puzzle being solved.
 */
class DayTwoParser {
    let separator=","
    var instructionPointer = 0

    let noun: Int?
    let verb: Int?
    /**
Basic initialiser
 - Parameter noun: when parsing an instruction set, the first operand is replaced with this value.
 - Parameter verb: when parsing an instruction set, the second operand is replaced with this value.

     */
    init (noun: Int? = nil, verb: Int? = nil) {
        self.noun = noun
        self.verb = verb
    }

    /**
     The bulk of the puzzle.
     
      Loads in a string from disc, sanitises it (removes whitespace, converts to array of Ints), and evaluates it.  The
      first and second operand are over-ridden from the noun and verb values from the initialiser.  All instructions
      use four ints.  The first is the Opcode (1 => addition, 2 => multiplication, 99 => end programme, no other valid
      values), the second and third are the operands.  The final int is the index of element.

     - Parameter script: The script to parse
     - Returns: Result string derived from script
     */
    func parse(script: String) throws -> String {
        let elementString = script.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separator)
        var elements = elementString.map {Int($0)!}

        // 1202 fix (see puzzle text: https://adventofcode.com/2019/day/2 final paragraph):
        if noun != nil {
            elements[1] = noun!
        }
        if verb != nil {
            elements[2] = verb!
        }
        mainloop: repeat {
            let opcode = elements[instructionPointer]
            switch opcode {
            case 1:
                elements[elements[instructionPointer + 3]] = elements[elements[instructionPointer + 1]]
                    + elements[elements[instructionPointer + 2]]
            case 2:
                elements[elements[instructionPointer + 3]] = elements[elements[instructionPointer + 1]]
                    * elements[elements[instructionPointer + 2]]
            case 99:
                break mainloop
            default:
                throw ParseError.invalidOpcode(opcode: elements[instructionPointer])
            }
            instructionPointer += 4
        } while true
        let resultStrings = elements.map {String($0)}
        return resultStrings.joined(separator: separator)
    }
}

func part1(contents: String) throws -> String {
    //Day Two part 1
    let parser = DayTwoParser(noun: 12, verb: 2)
    let result = try parser.parse(script: contents)

    //Only want to print first value (see puzzle text again)
    return result.components(separatedBy: ",")[0]
}

//Day Two part 2
// This reverses the puzzle a little - need to find the noun and verb that yield a particular result in the first
// array element.

func part2(contents: String) throws -> Int {
    let target = 19690720
    var result = 0
    outerloop: for noun in 0 ... 99 {
        for verb in 0 ... 99 {
            let parser = DayTwoParser(noun: noun, verb: verb)
            let output = try parser.parse(script: contents)
            let computed = Int(output.components(separatedBy: ",")[0])
            if computed == target {
                result = 100 * noun + verb
                break outerloop
            }
        }
    }
    return result
}

func daytwo(contents: String) throws -> String {
    var result: String
    result = "Part 1: "
    result += try part1(contents: contents) + " Part2 : " + String(part2(contents: contents))
    return result
}
