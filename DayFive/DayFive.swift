//
//  DayFive.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 28/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation


class DayFiveParser {
    let separator=","
    var instructionPointer = 0

    let noun: Int?
    let verb: Int?

    init (noun: Int? = nil, verb: Int? = nil) {
        self.noun = noun
        self.verb = verb
    }

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
