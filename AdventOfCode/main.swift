//
//  main.swift
//  Advent of Code
//
//  Created by Harold Dyson on 12/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation


if CommandLine.arguments.count < 4 {
    print("Needs to be called with an argument for each day (currently, 3 arguments)")
    exit(1)
}
let filenames = CommandLine.arguments
var source_data = [Int: String]()
for (index, filename) in filenames.enumerated() {
    // filenames[0] is executable name
    if index == 0 {
        continue
    }
    source_data[index] = try String(contentsOfFile: filename)
}
print("Day one: ", dayone(contents: source_data[1]!))
print("Day two: ", daytwo(contents: source_data[2]!))
print("Day three: ", daythree(contents: source_data[3]!))
print("Day four: ", dayfour(min: 136760, max: 595730))
