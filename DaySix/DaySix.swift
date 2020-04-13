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
    var astronomicalObjects = Set<AstronomicalObject>()

    func parse(inputString: String) {
        input = inputString
        let lineSeparator = "\n"
        let orbitSeparator = ")"
        for line in input.components(separatedBy: lineSeparator) {
            let bodies = line.components(separatedBy: orbitSeparator)
            let planet_name = bodies[0]
            let planet = AstronomicalObject(planet: nil, satellite: planet_name)
            let satellite = bodies[1]
            astronomicalObjects.insert(AstronomicalObject(planet: planet, satellite: satellite))
            if !astronomicalObjects.contains(planet) {
                astronomicalObjects.insert(AstronomicalObject(planet: nil, satellite: planet_name))
            }
        }
    }
}

class AstronomicalObject: Hashable {
    let name: String
    let orbits: AstronomicalObject?
    var totalOrbits: Int?

    init(planet: AstronomicalObject?, satellite: String) {
        name = satellite
        orbits = planet
        totalOrbits = nil
    }

    func countOrbits() -> Int {
        if totalOrbits == nil {
            if orbits == nil {
                totalOrbits = 0
            } else {
                totalOrbits = orbits!.countOrbits() + 1
            }
        }
        return totalOrbits!
    }

    static func == (lhs: AstronomicalObject, rhs: AstronomicalObject) -> Bool {
        return lhs.name == rhs.name && lhs.orbits == rhs.orbits
    }

    func hash(into hasher: inout Hasher) {
        // Need manual hasher for a class (can be auto for struct, but can't use a struct recursively)
        hasher.combine(name)
        hasher.combine(orbits)
    }
}
