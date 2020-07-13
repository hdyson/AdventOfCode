//
//  DayTen.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 13/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

enum DayTenError: Error {
    case invalidInput(input: Character)
}

class DayTenSolver {

    var map: [[Character]]

    init(data: String) {
        map = try! parseInput(data)
    }

    func solve () {

    }

}

func parseInput(_ input: String) throws -> [[Character]]{

    var result = [[Character]]()
    var row = 0
    var column = 0
    result.append([Character]())

    for character in input {
        switch character {
        case ".", "#":
            result[row].append(character)
            column += 1
        case "\n":
            result.append([Character]())
            column = 0
            row += 1
        default:
            throw DayTenError.invalidInput(input: character)
        }
    }

    return result
}

func dayten(contents: String) throws -> String {
    let solver = DayTenSolver(data: contents)
    return "Part 1: \(solver.solve())"
}
