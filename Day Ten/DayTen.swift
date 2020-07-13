//
//  DayTen.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 13/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayTenSolver {

    var map: [[Int]]

    init(data: String) {
        map = parseInput(data)
    }

    func solve () {

    }

}

func parseInput(_ input: String) -> [[Int]]{
    return [[0]]
}

func dayten(contents: String) throws -> String {
    let solver = DayTenSolver(data: contents)
    return "Part 1: \(solver.solve())"
}
