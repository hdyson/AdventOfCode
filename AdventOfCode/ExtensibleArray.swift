//
//  ExtensibleArray.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 05/07/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class ExtensibleArray {

    // A dict with an array-like interface.  Enables changing the underlying storage model without needing to change
    // every call.

    var backingStore: [Int: Int] = [:]

    init (_ values: [Int]) {
        // Enables initialising from an array of Ints
        for (index, value) in values.enumerated() {
            backingStore[index] = value
        }
    }

    init () {
    }

    subscript (index: Int) -> Int {
        // Swift magic method to implement [] syntax
        get {
            var result: Int
            result = backingStore[index, default: 0]  // 0 default from day 9 puzzle text.
            return result
        }
        set(newValue) {
            backingStore[index] = newValue
        }
    }

    func asStringArray () -> [String] {
        // Some days need output of storage array as a string.
        var maxKey = 0
        for key in backingStore.keys where key > maxKey {
            maxKey = key
        }
        var result = Array(repeating: "0", count: maxKey + 1)
        for (key, value) in backingStore {
            result[key] = String(value)
        }
        return result
    }
}
