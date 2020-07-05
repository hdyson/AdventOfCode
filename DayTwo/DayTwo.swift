//
//  DayTwo.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 16/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

/**
Class to solve the day two puzzle of advent of code 2019

The puzzle involves loading a list of integers, and interpreting them as a list of operators and operands (similar to
a simplified turing machine).

See https://adventofcode.com/2019/day/2 for the details of the puzzle being solved.
 */
class DayTwoParser: Computer {

    let noun: Int?
    let verb: Int?

    init (noun: Int? = nil, verb: Int? = nil) {
        self.noun = noun
        self.verb = verb
        super.init()
    }

    override func parse(script: String = "") throws -> String {
        if script == "" {
            elements = try execute(programme: elements)
            let resultStrings = elements.asStringArray()
            return resultStrings.joined(separator: separator)
        } else {
            let cleanedScript = script.trimmingCharacters(in: .whitespacesAndNewlines)
            let elementString = cleanedScript.components(separatedBy: separator)
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
