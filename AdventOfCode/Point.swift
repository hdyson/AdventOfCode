//
//  Point.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 26/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

struct Point: Hashable {
    // Generic "Point" object to store (x, y) coordinates in a way that supports checking for equality and hashing.

    // We really do mean "x" and "y" for the point locations, so disable linter for those names:
    // swiftlint:disable identifier_name
    var x=0
    var y=0
    // swiftlint:enable identifier_name
    var index = 0

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
