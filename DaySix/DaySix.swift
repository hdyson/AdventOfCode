//
//  DaySix.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 12/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DaySixParser {
    var input = ""
    var astronomicalObjects = [String: String]()

    func parse(inputString: String) {
        input = inputString
        let lineSeparator = "\n"
        let orbitSeparator = ")"
        for line in input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: lineSeparator) {
            let bodies = line.components(separatedBy: orbitSeparator)
            let planet = bodies[0]
            let satellite = bodies[1]
            astronomicalObjects[satellite] = planet
        }
    }

    func countOrbits() -> Int {
        var total = 0
        for (satellite, _) in astronomicalObjects {
            var nextPlanet = astronomicalObjects[satellite]
            while nextPlanet != nil {
                nextPlanet = astronomicalObjects[nextPlanet!]
                total+=1
            }
        }
        return total
    }

    func countTransfers() -> Int {
        var total = 0
        return total
    }
}

func daysix(contents: String) throws -> String {
    let part1 = DaySixParser()
    part1.parse(inputString: contents)
    return "Part 1: \(part1.countOrbits())"
}
