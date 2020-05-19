//
//  File.swift
//  
//
//  Created by Richard Clark on 5/5/20.
//

import Foundation

public func setSeed(_ seed: Int) {
    srand48(seed)
}

public func seededRandom(in range: Range<Int>) -> Int {
    let rand = Double(range.upperBound - range.lowerBound) * drand48()
    return min(range.upperBound - 1, Int(floor(rand)) + range.lowerBound)
}

public func seededRandom(prob: Double) -> Bool {
    return drand48() < prob
}
