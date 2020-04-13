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
        let yourPlanet = astronomicalObjects["YOU"]!
        let santasPlanet = astronomicalObjects["SAN"]!
        var youToSun = Set<String>()
        var santaToSun = Set<String>()

        var nextPlanet: String?
        nextPlanet = yourPlanet
        while nextPlanet != nil {
            youToSun.insert(nextPlanet!)
            nextPlanet = astronomicalObjects[nextPlanet!]
        }

        nextPlanet = santasPlanet
        while nextPlanet != nil {
            santaToSun.insert(nextPlanet!)
            nextPlanet = astronomicalObjects[nextPlanet!]
        }

        return youToSun.symmetricDifference(santaToSun).count
    }
}

func daysix(contents: String) throws -> String {
    let parser = DaySixParser()
    parser.parse(inputString: contents)
    return "Part 1: \(parser.countOrbits()) part2: \(parser.countTransfers())"
}
