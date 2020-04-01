//
//  DayOne.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 16/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayOneRocket {

    var totalFuel: Int
    var moduleMasses: String

    init(masses: String) {
        moduleMasses = masses
        totalFuel = 0
    }

    func calculate_module_fuel(mass: Int) -> Int {
        var result = Int(Float(mass)/3.0) - 2
        if result < 0 {
            result = 0
        }
        return result
    }

    func calculate_gross_module_fuel(mass: Int) -> Int {
        var grossModuleFuel = calculate_module_fuel(mass: mass)
        var additionalFuel = calculate_module_fuel(mass: grossModuleFuel)
        while additionalFuel > 0 {
            let previousFuel = grossModuleFuel
            grossModuleFuel += additionalFuel
            additionalFuel = calculate_module_fuel(mass: grossModuleFuel - previousFuel)
        }
        return grossModuleFuel
    }

    func calculate_total_fuel() {
        for line in moduleMasses.components(separatedBy: "\n") {
            let mass = Int(line) ?? 0
            totalFuel += calculate_gross_module_fuel(mass: mass)
        }
    }
}

func dayone(contents: String) -> Int {
    let rocket = DayOneRocket(masses: contents)
    rocket.calculate_total_fuel()
    return rocket.totalFuel
}
