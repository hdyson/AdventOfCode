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
    var amplifiers: [DaySevenParser]
    var maximumPhase: [Int]
    var potentialPhases: [[Int]]

    init () {
        input = 0
        amplifiers = Array(repeating: DaySevenParser(), count: 5)
        maximumPhase = [0, 1, 2, 3, 4]
        potentialPhases = []
    }

    func solve(script: String) throws {
        var output = input
        var phases = [0, 1, 2, 3, 4]
        for amplifier in amplifiers {
            amplifier.input = output  // input for next amplifier is output from previous
            amplifier.phase = phases.removeFirst()
            _ = try amplifier.parse(script: script)
            output = amplifier.output!
        }
        return
    }

    func getResult() -> Int {
        return amplifiers[amplifiers.count - 1].output!
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
}

class DaySevenParser: DayFiveParser {

    var phase: Int?
    var phaseUsed = false

    override func readInput() {
        if phaseUsed {
            elements[elements[instructionPointer + 1]] = phase!
            instructionPointer += 2
            phaseUsed = true
        } else {
            super.readInput()
        }
    }
}

func dayseven(contents: String) throws -> String {
    let solver = Solver()
    _ = try solver.solve(script: contents)
    return "Part 1: \(solver.getResult())"
}
