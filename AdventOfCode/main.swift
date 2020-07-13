//
//  main.swift
//  Advent of Code
//
//  Created by Harold Dyson on 12/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

if CommandLine.arguments.count < 8 {
    print("Needs to be called with 8 arguments (one for each day)")
    exit(1)
}
let filenames = CommandLine.arguments
var sourceData = [Int: String]()
for (index, filename) in filenames.enumerated() {
    // filenames[0] is executable name
    if index == 0 {
        continue
    }
    sourceData[index] = try String(contentsOfFile: filename)
}
//print("Day one: ", dayone(contents: sourceData[1]!))
//print("Day two: ", try daytwo(contents: sourceData[2]!))
//print("Day three: ", try daythree(contents: sourceData[3]!))
//print("Day four: ", dayfour(min: 136760, max: 595730))
//print("Day five: ", try dayfive(partOneInput: 1, partTwoInput: 5, contents: sourceData[5]!))
//print("Day six: ", try daysix(contents: sourceData[6]!))
//print("Day seven: ", try dayseven(contents: sourceData[7]!))
//print("Day eight: ", try dayeight(contents: sourceData[8]!))
//print("Day nine: ", try daynine(contents: sourceData[9]!))
print("Day ten: ", try dayten(contents: sourceData[10]!))
