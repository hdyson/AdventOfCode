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

struct Asteroid : Equatable {
    let x : Int
    let y : Int

    static func == (left: Asteroid, right: Asteroid) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
}

class DayTenSolver {

    var asteroids: [Asteroid]

    init(data: String) {
        asteroids = try! parseInput(data)
    }

    func solve () {

    }

}

func parseInput(_ input: String) throws -> [Asteroid] {

    var result = [Asteroid]()
    var row = 0
    var column = 0

    for character in input {
        switch character {
        case ".":
            column += 1
        case "#":
            result.append(Asteroid(x: column, y: row))
        case "\n":
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
