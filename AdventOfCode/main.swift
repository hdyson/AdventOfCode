//
//  main.swift
//  Advent of Code
//
//  Created by Harold Dyson on 12/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case invalidOpcode(opcode: Int)
}

class DayTwoParser{
    let separator=","
    func parse(script:String) throws -> String {
        let elementString = script.components(separatedBy: separator)
        var elements = elementString.map{ Int($0)! }
        if !valid_opcode(value: elements[0]) {
            throw ParseError.invalidOpcode(opcode: elements[0])
        }
        let result_strings = elements.map{ String($0) }
        return result_strings.joined(separator: separator)
    }
    
    func valid_opcode(value: Int) -> Bool {
        let valid_opcodes = [1, 2, 99]
        var result = false
        if valid_opcodes.contains(value)
        {
            result = true
        }
        return result
    }
}

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



if CommandLine.arguments.count < 2 {
    print("Needs to be called with an argument")
    exit(1)
}
let filename = CommandLine.arguments[1]
let contents = try String(contentsOfFile: filename)

//Day One
//let rocket = DayOneRocket(masses: contents)
//rocket.calculate_total_fuel()
//let result = rocket.total_fuel

//Day Two
let parser = DayTwoParser()
let result = try! parser.parse(script: contents)

print(result)
