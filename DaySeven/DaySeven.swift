//
//  DaySeven.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 14/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

func dayseven(contents: String) throws -> String {
    let parser = DaySevenParser()
    parser.parse(inputString: contents)
    return "Part 1: \(parser.getResults())"
}
