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
    var instruction_pointer = 0

    let noun : Int
    let verb : Int
    
    init (noun: Int, verb: Int){
        self.noun = noun
        self.verb = verb
    }
    
    func parse(script:String) throws -> String {
        let elementString = script.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separator)
        var elements = elementString.map{ Int($0)! }
        
        // 1202 fix (see puzzle text: https://adventofcode.com/2019/day/2 final paragraph):
        elements[1] = noun
        elements[2] = verb
        mainloop: repeat{
            let opcode = elements[instruction_pointer]
            switch opcode {
                case 1:
                    elements[elements[instruction_pointer + 3]] = elements[elements[instruction_pointer + 1]] + elements[elements[instruction_pointer + 2]]
                case 2:
                    elements[elements[instruction_pointer + 3]] = elements[elements[instruction_pointer + 1]] * elements[elements[instruction_pointer + 2]]
                case 99:
                    break mainloop
                default:
                    throw ParseError.invalidOpcode(opcode: elements[instruction_pointer])
                }
            instruction_pointer += 4
        } while true
        let result_strings = elements.map{ String($0) }
        return result_strings.joined(separator: separator)
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

//Day Two part 1
//let parser = DayTwoParser(noun: 12, verb: 2)
//let result = try! parser.parse(script: contents)

//Only want to print first value (see puzzle text again)
//print(result.components(separatedBy: ",")[0])

//Day Two part 2
let target = 19690720
outerloop: for noun in 0 ... 99 {
    for verb in 0 ... 99 {
        let parser = DayTwoParser(noun: noun, verb: verb)
        let output = try! parser.parse(script: contents)
        let result = Int(output.components(separatedBy: ",")[0])
        if result == target {
            print(100 * noun + verb)
            break outerloop
        }
    }
}
