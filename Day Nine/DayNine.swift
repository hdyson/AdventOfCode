//
//  DayNine.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 30/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayNineParser: Computer {

}

func daynine(contents: String) throws -> String {
    let partOne = DayNineParser()
    partOne.input = 1
    _ = try partOne.parseAndExecute(script: contents)
    let partTwo = DayNineParser()
    partTwo.input = 2
    _ = try partTwo.parseAndExecute(script: contents)
    return "Part 1: \(partOne.output) Part 2: \(partTwo.output)"
}
