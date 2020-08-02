//
//  DayThirteen.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 30/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

struct Pixel: Hashable {
    // We really do mean "x" and "y" for the point locations, so disable linter for those names:
    // swiftlint:disable identifier_name
    var x=0
    var y=0
    // swiftlint:enable identifier_name
    var tileID = 0

    static func == (lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.tileID == rhs.tileID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(tileID)
    }
}

struct DayThirteenSolver {
    var data: String
    let tileIDs = ["empty": 0, "wall": 1, "block": 2, "horizontal_paddle": 3, "ball": 4]

    func solvePartOne() -> Int {
        let computer = Computer()
        do {
            try _ = computer.parseAndExecute(script: data)
        } catch {
            print("Something went wrong parsing the input data")
            exit(-1)
        }
        var pixels = [Pixel]()
        repeat {
            let tileID = computer.output.popLast()
            // We really do mean "x" and "y" for the point locations, so disable linter for those names:
            // swiftlint:disable identifier_name
            let y = computer.output.popLast()
            let x = computer.output.popLast()
            // swiftlint:enable identifier_name
            pixels.append(Pixel(x: x!, y: y!, tileID: tileID!))
        } while computer.output.count > 0

        var blockCount = 0
        for pixel in pixels where pixel.tileID == tileIDs["block"] {
            blockCount += 1
        }
        return blockCount
    }

    func solvePartTwo() -> Int {
        return 0
    }
}

func daythirteen(contents: String) throws -> String {
    let solver = DayThirteenSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(solver.solvePartTwo())"
}
