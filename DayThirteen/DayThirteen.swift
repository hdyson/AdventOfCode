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

class DayThirteenComputer: Computer {
    var score = 0
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

    func solvePartTwo() throws -> Int {
        let computer = DayThirteenComputer()
        computer.parse(script: data)
        // Memory address 0 represents the number of quarters that have been inserted; set it to 2 to play
        // for free:
        computer.memory[0] = 2
        var pixels = [Pixel]()
        repeat {
            // The arcade cabinet has a joystick that can move left and right. The software reads the
            // position of the joystick with input instructions:
            // If the joystick is in the neutral position, provide 0.
            // If the joystick is tilted to the left, provide -1.
            // If the joystick is tilted to the right, provide 1.
            //

            // i.e. this loop continues until the computer finishes.  Initial steps parse the current
            // display to work out which way to move the joystick, then wipes the display, and finally has
            // a nested loop to redraw the display.

            // First pass: point joystick in direction of ball (only care about x coordinate)
            // Find centre of paddle:
            var xPaddles = [Int]()
            for pixel in pixels where pixel.tileID == tileIDs["horizontal_paddle"] {
                xPaddles.append(pixel.x)
            }
            let xPaddle = mean(xPaddles)
            // Assume single pixel for ball:
            var xBall: Int?
            for pixel in pixels where pixel.tileID == tileIDs["ball"] {
                xBall = pixel.x
                break
            }
            if xBall != nil {
                if Double(xBall!) > xPaddle {
                    computer.input = 1
                } else if Double(xBall!) < xPaddle {
                    computer.input = -1
                } else {
                    computer.input = 0
                }
            } else {
                computer.input = 0
            }
            pixels = [Pixel]() // reset display before refreshing
            repeat {
                // This loop redraws the display in response to the new input
                try _ = computer.execute()
                // We really do mean "x" and "y" for the point locations, so disable linter for those names:
                // Similarly, we don't know what "z" represents yet, so a generic name works.
                // swiftlint:disable identifier_name
                let z = computer.output.popLast() // z may be a tileID or a score, depending on x, y
                let y = computer.output.popLast()
                let x = computer.output.popLast()
                // swiftlint:enable identifier_name

                // When three output instructions specify X=-1, Y=0, the third output instruction is not a
                // tile; the value instead specifies the new score to show in the segment display.
                // So this defines how we interpret z.
                if x == -1 && y == 0 {
                    computer.score = z!
                } else {
                    pixels.append(Pixel(x: x!, y: y!, tileID: z!))
                }
            } while computer.output.count > 0
        } while computer.finished == false
        return computer.score
    }
}

func mean (_ data: [Int]) -> Double {
    var sum = 0.0
    for datum in data {
        sum += Double(datum)
    }
    return sum/Double(data.count)
}

func daythirteen(contents: String) throws -> String {
    let solver = DayThirteenSolver(data: contents)
    return "Part 1: \(solver.solvePartOne()) Part 2: \(try solver.solvePartTwo())"
}
