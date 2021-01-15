//
//  DisjointSetModel.swift
//  
//
//  Created by Richard Clark on 1/14/21.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation
import SwiftUI
import Combine
import Strux

class DisjointSetModel: ObservableObject {
    @Published var output = ""
    @Published var time: Double = 0.0

    public func startProcessing() {
        let startTime = Date()
        setSeed(33)
        DispatchQueue.global().async {
            (0..<100).forEach { dsIndex in
                DispatchQueue.main.async {
                    self.output = "DisjointSet \(dsIndex) ...\n"
                }
                let setSize = seededRandom(in: 1 ..< 100000)
                let numSubsets = seededRandom(in: 1 ..< 100)
                var subsets = [Set<Int>](repeating: Set<Int>(), count: numSubsets)
                var subsetMap = [Int: Int]()
                for val in 0 ..< setSize {
                    let subsetIndex = seededRandom(in: 0 ..< numSubsets)
                    subsets[subsetIndex].insert(val)
                    subsetMap[val] = subsetIndex
                }

                let ds = DisjointSet<Int>()
                for subsetIndex in 0 ..< numSubsets {
                    let subsetArray = Array(subsets[subsetIndex])
                    if subsetArray.count > 0 {
                        let val1 = subsetArray[0]
                        for valIndex in 1 ..< subsetArray.count {
                            let val2 = subsetArray[valIndex]
                            ds.union(val1, val2)
                        }
                    }
                }

                var subsetRoots = [Int: Int]()
                for subsetIndex in 0 ..< numSubsets {
                    let subsetArray = Array(subsets[subsetIndex])
                    if subsetArray.count > 0 {
                        subsetRoots[subsetIndex] = ds.find(subsetArray[0])
                    }
                }

                // All have the correct root?
                for val in 0 ..< setSize {
                    let subsetIndex = subsetMap[val]!
                    let root = subsetRoots[subsetIndex]
                    if ds.find(val) != root {
                        print("*** Value \(val) has root \(ds.find(val)), should be \(String(describing: root))")
                    }
                }
            }
            DispatchQueue.main.async {
                self.time = Date().timeIntervalSince(startTime)
            }
        }
    }
}
