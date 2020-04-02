//
//  DayFive.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 28/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayFiveParser: DayTwoParser {

    override func getOpcode(instruction: Int) -> Int {
        let digits = instruction.digits
        let units = digits[digits.count - 1]
        var result = units
        if digits.count > 1 {
            let tens = digits[digits.count - 2]
            result = 10 * tens + units
        }
        return result
    }
}
