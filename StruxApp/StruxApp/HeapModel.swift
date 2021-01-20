//
//  HeapModel.swift
//  StruxApp
//
//  Created by Richard Clark on 5/7/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Strux

class HeapModel: ObservableObject {
    @Published var output = ""
    @Published var time: Double = 0.0

    public func startProcessing() {
        let startTime = Date()
        setSeed(12)
        DispatchQueue.global().async {
            (0..<100).forEach { heapIndex in
                DispatchQueue.main.async {
                    self.output = "Heap \(heapIndex) ...\n"
                }
                let initialValues = [44, -12, 3]
                let heapSizish = seededRandom(in: 0..<10000)
                var heap = Heap<Int>(isMin: true, startingValues: initialValues)
                (0..<heapSizish).forEach { _ in
                    let val = seededRandom(in: -5..<100)
                    let choice = seededRandom(in: 0..<10)
                    switch choice {
                    case 0:
                        heap.remove(val)
                    case 1:
                        heap.removeAll(val)
                    case 2:
                        heap.pop()
                    default:
                        heap.push(val)
                    }
                }
            }
            DispatchQueue.main.async {
                self.time = Date().timeIntervalSince(startTime)
            }
        }
    }
}
