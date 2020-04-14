//
//  DaySeven.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 14/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DaySevenParser: DayFiveParser {

}

func dayseven(contents: String) throws -> String {
    let parser = DaySevenParser()
    _ = try parser.parse(script: contents)
    return "Part 1: \(parser.getResult())"
}
