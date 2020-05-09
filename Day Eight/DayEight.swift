//
//  DayEight.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 09/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DayEightSolver {

    var layers = [[Int]]()
    var layerWithFewestZeroes = Int.max

    init(data: String, width: Int, height: Int) {
        let data = data.compactMap({ Int(String($0)) })
        let width = width
        let height = height

        let layersize = width * height
        for layerIndex in 0..<(data.count/layersize) {
            layers.append([Int](data[layersize*layerIndex..<layersize*(layerIndex+1)]))
        }
        var minZeroCount = Int.max
        for (index, layer) in layers.enumerated() {
            var thisLayer = layer
            thisLayer.removeAll(where: { $0 != 0 })
            if thisLayer.count < minZeroCount {
                minZeroCount = thisLayer.count
                layerWithFewestZeroes = index
            }
        }
    }

    func solve() -> Int {
        var onesLayer = layers[layerWithFewestZeroes]
        onesLayer.removeAll(where: { $0 != 1 })
        let onesCount = onesLayer.count
        var twosLayer = layers[layerWithFewestZeroes]
        twosLayer.removeAll(where: { $0 != 2 })
        let twosCount = twosLayer.count

        return onesCount * twosCount
    }
}

func dayeight(contents: String) throws -> String {
    let partOne = DayEightSolver(data: contents, width: 25, height: 6)
    let result = partOne.solve()
//    let partTwo = Solver([5, 6, 7, 8, 9])
//    _ = try partTwo.solvePartTwo(script: contents)
    return "Part 1: \(result)"
//Part 2: \(partTwo.getResult())"
}
