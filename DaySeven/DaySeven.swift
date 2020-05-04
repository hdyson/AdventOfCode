//
//  DaySeven.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 14/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class Solver {
    var input: Int
    var maximumSignal: Int
    var maximumPhase: [Int]
    var potentialPhases: [[Int]]
    var initialPhase: [Int]

    init (_ phases: [Int] = [0, 1, 2, 3, 4]) {
        input = 0
        maximumSignal = 0
        maximumPhase = [0, 1, 2, 3, 4]
        potentialPhases = []
        initialPhase = phases
    }

    func solvePartOne(script: String) throws {
        permute(initialPhase.count, &initialPhase)
        var output = input
        for phases in potentialPhases {
            var amplifiers: [DaySevenParser]
            amplifiers = []
            for index in 0...4 {
                let amplifier = DaySevenParser()
                amplifier.input = output  // input for next amplifier is output from previous
                amplifier.phase = phases[index]
                _ = try amplifier.parse(script: script)
                output = amplifier.output!
                amplifiers.append(amplifier)
            }
            if output > maximumSignal {
                maximumSignal = output
                maximumPhase = phases
            }
            output = input
        }
    }

    func solvePartTwo(script: String) throws {
        permute(initialPhase.count, &initialPhase)
        var output = 0
        for phases in potentialPhases {
            var amplifiers: [DaySevenParser]
            amplifiers = []
            for index in 0...4 {
                let amplifier = DaySevenParser()
                amplifier.name = String(index)
                amplifier.input = output  // input for next amplifier is output from previous
                amplifier.phase = phases[index]
                _ = try amplifier.parse(script: script)
                output = amplifier.output!
                amplifiers.append(amplifier)
            }
            var count = 0
            while amplifiers[amplifiers.count-1].finished == false {
                count += 1
                for amplifier in amplifiers {
                    amplifier.input = output
                    _ = try amplifier.parse()
                    output = amplifier.output!
                }
            }
            if output > maximumSignal {
                maximumSignal = output
                maximumPhase = phases
            }
            output = input
        }
    }
    func getResult() -> Int {
        return  maximumSignal
    }
    // Following adapted from:
    // https://stackoverflow.com/questions/34968470/calculate-all-permutations-of-a-string-in-swift#34969212
    // Keeping similar names, so let's disable the swiftlint name check:
    // swiftlint:disable identifier_name
    func permute(_ n: Int, _ a: inout [Int]) {
        if n == 1 {potentialPhases.append(a); return}
        for i in 0..<n-1 {
            permute(n-1, &a)
            a.swapAt(n-1, (n%2 == 1) ? 0 : i)
        }
        permute(n-1, &a)
    }
    // swiftlint:enable identifier_name
}

class DaySevenParser: DayFiveParser {

    var phase: Int?
    var phaseUsed = false
    var finished = false
    var name: String

    override init(noun: Int? = nil, verb: Int? = nil) {
        name = "undefined"
        super.init(noun: noun, verb: verb)
        instructionPointer = 0
    }

    func parse() throws -> String {
        elements = try execute(programme: elements)
        let resultStrings = elements.map {String($0)}
        return resultStrings.joined(separator: separator)
    }

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

    override func readInput() {
        if phaseUsed == false {
            elements[elements[instructionPointer + 1]] = phase!
            instructionPointer += 2
            phaseUsed = true
        } else {
            super.readInput()
            input = nil
        }
    }
}

func dayseven(contents: String) throws -> String {
    let partOne = Solver()
    _ = try partOne.solvePartOne(script: contents)
    let partTwo = Solver([5, 6, 7, 8, 9])
    _ = try partTwo.solvePartTwo(script: contents)
    return "Part 1: \(partOne.getResult()) Part 2: \(partTwo.getResult())"
}
