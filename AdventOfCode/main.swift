//
//  main.swift
//  Advent of Code
//
//  Created by Harold Dyson on 12/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation


class Rocket{

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

    func calculate_total_fuel() {
        for line in module_masses.components(separatedBy: "\n") {
            let mass = Int(line) ?? 0
            total_fuel += calculate_module_fuel(mass: mass)
        }
    }
}


if CommandLine.arguments.count < 2 {
    print("Needs to be called with an argument")
    exit(1)
}
let filename = CommandLine.arguments[1]
let contents = try String(contentsOfFile: filename)

let rocket = Rocket(masses: contents)
rocket.calculate_total_fuel()
    
print(rocket.total_fuel)
