//
//  DayFive.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 28/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayFiveParser: Computer {

}

func dayfive(partOneInput: Int, partTwoInput: Int, contents: String) throws -> String {
    let part1 = DayFiveParser()
    part1.input = partOneInput
    _ = try part1.parseAndExecute(script: contents)
    let part2 = DayFiveParser()
    part2.input = partTwoInput
    _ = try part2.parseAndExecute(script: contents)
    return "Part 1: \(part1.output)  Part 2: \(part2.output)"
}
