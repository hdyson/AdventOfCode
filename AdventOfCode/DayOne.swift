//
//  DayOne.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 16/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayOneRocket{

    var total_fuel : Int
    var module_masses : String
    
    init(masses : String) {
        module_masses = masses
        total_fuel = 0
    }
    
    func calculate_module_fuel(mass:Int) -> Int {
        var result = Int(Float(mass)/3.0) - 2
        if result < 0 {
            result = 0
        }
        return result
    }
    
    func calculate_gross_module_fuel(mass: Int) -> Int {
        var gross_module_fuel = calculate_module_fuel(mass: mass)
        var additional_fuel = calculate_module_fuel(mass: gross_module_fuel)
        while additional_fuel > 0 {
            let previous_fuel = gross_module_fuel
            gross_module_fuel += additional_fuel
            additional_fuel = calculate_module_fuel(mass: gross_module_fuel - previous_fuel)
        }
        return gross_module_fuel
    }

    func calculate_total_fuel() {
        for line in module_masses.components(separatedBy: "\n") {
            let mass = Int(line) ?? 0
            total_fuel += calculate_gross_module_fuel(mass: mass)
        }
    }
}


func dayone(contents:String) -> Int {
    let rocket = DayOneRocket(masses: contents)
    rocket.calculate_total_fuel()
    return rocket.total_fuel
}
