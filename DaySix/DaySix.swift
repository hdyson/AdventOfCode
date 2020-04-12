//
//  DaySix.swift
//  AdventOfCode
//
//  Created by Harold Dyson on 12/04/2020.
//  Copyright © 2020 Harold Dyson. All rights reserved.
//

import Foundation

class DaySixParser {
    var input = ""
    
    func parse(_ input_string: String) {
        input = input_string
    }
}

struct Orbit {
    let satellite : String
    let planet : String
    
    init(planet planet_arg: String, satellite satellite_arg: String) {
        satellite = satellite_arg
        planet = planet_arg
    }
}
