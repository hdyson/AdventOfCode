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

    func parse(inputString: String) {
        input = inputString
    }
}

class AstronomicalObject: Hashable {
    let name: String
    let orbits: AstronomicalObject?

    init(planet: AstronomicalObject?, satellite: String) {
        name = satellite
        orbits = planet
    }

    func countOrbits() -> Int {
        return 0
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
