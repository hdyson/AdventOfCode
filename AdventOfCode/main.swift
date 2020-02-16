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
let dayone_contents = try String(contentsOfFile: filenames[1])
let daytwo_contents = try String(contentsOfFile: filenames[2])

print(dayone(contents: dayone_contents))
print(daytwo(contents: daytwo_contents))
