//
//  DayFour.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 23/02/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

class DayFour{
    
    let min : Int
    let max : Int
    
    init(min: Int, max: Int){
        self.min = min
        self.max = max
    }
    
    func check (input: Int) -> Bool {
        return check_double(input: input) && check_not_decreasing(input: input)
    }

    func check_double(input: Int) -> Bool{
        var result = false
        for (index, digit) in input.digits.enumerated().dropFirst() {
            if digit == input.digits[index-1]{
                result = true
                break
            }
        }
        return result
    }
    
    func check_not_decreasing(input: Int) -> Bool{
        var result = true
        for (index, digit) in input.digits.enumerated().dropFirst() {
            if digit < input.digits[index-1]{
                result = false
                break
            }
        }
        return result
    }
    
    func solve() -> String {
        var result = [Int]()
        for i in min ... max {
            if check(input: i) {
                result.append(i)
            }
        }
        return String(result.count)
    }
}

func dayfour(min: Int, max: Int) -> String {
    let dayfour = DayFour(min: min, max: max)
    return dayfour.solve()
}
