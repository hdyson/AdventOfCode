//
//  DayFour.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 23/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

internal extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

class DayFourPart1 {

    let min: Int
    let max: Int

    init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }

    func check (input: Int) -> Bool {
        return check_double(input: input) && check_not_decreasing(input: input)
    }

    func check_double(input: Int) -> Bool {
        var result = false
        for (index, digit) in input.digits.enumerated().dropFirst() where digit == input.digits[index-1] {
            result = true
            break
        }
        return result
    }

    func check_not_decreasing(input: Int) -> Bool {
        var result = true
        for (index, digit) in input.digits.enumerated().dropFirst() where digit < input.digits[index-1] {
            result = false
            break
        }
        return result
    }

    func solve() -> String {
        var result = [Int]()
        for candidate in min ... max {
            if check(input: candidate) {
                result.append(candidate)
            }
        }
        return String(result.count)
    }
}

class DayFourPart2: DayFourPart1 {
    // Part 2 means that doubles shouldn't count if part of a sequence of 3 identical digits.
    override func check_double(input: Int) -> Bool {
        var result = false
        for (index, digit) in input.digits.enumerated().dropFirst() where digit == input.digits[index-1] {
            // If this is not second digit, check it's not third digit of a triple:
            if index != 1 && digit == input.digits[index-2] {
                continue
            }
            // If this is not penultimate digit, check it's not second digit of a triple:
            if index != input.digits.count - 1 && digit == input.digits[index+1] {
                continue
            }
            result = true
            break
        }
        return result
    }
}

func dayfour(min: Int, max: Int) -> String {
    let part1 = DayFourPart1(min: min, max: max)
    let part2 = DayFourPart2(min: min, max: max)
    return "Part 1: " + part1.solve() + " Part 2: " + part2.solve()
}
