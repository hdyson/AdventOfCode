//
//  DayEight.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 09/05/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

enum LayerError: Error {
    case invalidDimensions
}

class DayEightSolver {

    var layers = [Layer]()
    var layerWithFewestZeroes = Int.max

    init(data: String, width: Int, height: Int) throws {
        let data = data.compactMap({ Int(String($0)) })
        let width = width
        let height = height

        let layersize = width * height
        for layerIndex in 0..<(data.count/layersize) {
            layers.append(try Layer(data: [Int](data[layersize*layerIndex..<layersize*(layerIndex+1)]),
                                width: width, height: height))
        }
        var minZeroCount = Int.max
        for (index, layer) in layers.enumerated() {
            var thisLayer = layer.getFlatArray()
            thisLayer.removeAll(where: { $0 != 0 })
            if thisLayer.count < minZeroCount {
                minZeroCount = thisLayer.count
                layerWithFewestZeroes = index
            }
        }
    }

    func solve() -> Int {
        var onesLayer = layers[layerWithFewestZeroes].getFlatArray()
        onesLayer.removeAll(where: { $0 != 1 })
        let onesCount = onesLayer.count
        var twosLayer = layers[layerWithFewestZeroes].getFlatArray()
        twosLayer.removeAll(where: { $0 != 2 })
        let twosCount = twosLayer.count

        return onesCount * twosCount
    }

    func palimpsest() -> [[Int]] {
        var result = layers[0].data
        for (rowIndex, row) in result.enumerated() {
            for (index, value) in row.enumerated() where value == 2 {
                var colour = value
                var layerIndex = 0
                while colour == 2 {
                    colour = layers[layerIndex].data[rowIndex][index]
                    layerIndex += 1
                }
                result[rowIndex][index] = colour
            }
        }
        return result
    }
}

class Layer {
    var data: [[Int]]
    init(data inputdata: [Int], width: Int, height: Int) throws {
        data = []
        if inputdata.count/width != height {
            throw LayerError.invalidDimensions
        }
        for row in 0..<(height) {
            data.append([Int](inputdata[width*row..<width*(row+1)]))
        }
    }

    func getFlatArray() -> [Int] {
        var result = [Int]()
        for row in data {
            for value in row {
                result.append(value)
            }
        }
        return result
    }
}

func dayeight(contents: String) throws -> String {
    let solver = try DayEightSolver(data: contents, width: 25, height: 6)
    var result = "\n"
    for row in solver.palimpsest() {
        result.append("\(row)")
        result.append("\n")
    }
    return "Part 1: \(solver.solve()) Part 2: \(result)"
}
