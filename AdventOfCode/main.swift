//
//  main.swift
//  Advent of Code
//
//  Created by Harold Dyson on 12/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation


if CommandLine.arguments.count < 3 {
    print("Needs to be called with an argument for each day (currently, 2 arguments)")
    exit(1)
}
let filenames = CommandLine.arguments
// filenames[0] is executable name
var source_data = [Int: String]()
for (index, filename) in filenames.enumerated() {
    if index == 0 {
        continue
    }
    source_data[index] = try String(contentsOfFile: filename)
}
print("Day one: ", dayone(contents: source_data[1]!))
print("Day two: ", daytwo(contents: source_data[2]!))
