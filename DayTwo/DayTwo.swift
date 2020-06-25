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
