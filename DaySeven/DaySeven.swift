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
        var output = [input]
        for phases in potentialPhases {
            var amplifiers: [DaySevenParser]
            amplifiers = []
            for index in 0...4 {
                let amplifier = DaySevenParser()
                amplifier.input = output[0]  // input for next amplifier is output from previous
                amplifier.phase = phases[index]
                _ = try amplifier.parse(script: script)
                output = amplifier.output
                amplifiers.append(amplifier)
            }
            if output[0] > maximumSignal {
                maximumSignal = output[0]
                maximumPhase = phases
            }
            output[0] = input
        }
    }

    func solvePartTwo(script: String) throws {
        permute(initialPhase.count, &initialPhase)
        var output = [0]
        for phases in potentialPhases {
            var amplifiers: [DaySevenParser]
            amplifiers = []
            for index in 0...4 {
                let amplifier = DaySevenParser()
                amplifier.name = String(index)
                amplifier.input = output[0]  // input for next amplifier is output from previous
                amplifier.phase = phases[index]
                _ = try amplifier.parse(script: script)
                output = amplifier.output
                amplifiers.append(amplifier)
            }
            var count = 0
            while amplifiers[amplifiers.count-1].finished == false {
                count += 1
                for amplifier in amplifiers {
                    amplifier.input = output[0]
                    _ = try amplifier.parse()
                    output = amplifier.output
                }
            }
            if output[0] > maximumSignal {
                maximumSignal = output[0]
                maximumPhase = phases
            }
            output = [input]
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

	class DaySevenParser: Computer {

}

func dayseven(contents: String) throws -> String {
    let partOne = Solver()
    _ = try partOne.solvePartOne(script: contents)
    let partTwo = Solver([5, 6, 7, 8, 9])
    _ = try partTwo.solvePartTwo(script: contents)
    return "Part 1: \(partOne.getResult()) Part 2: \(partTwo.getResult())"
}
