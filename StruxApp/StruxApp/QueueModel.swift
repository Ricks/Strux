//
//  QueueModel.swift
//  StruxApp
//
//  Created by Richard Clark on 5/7/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Strux

class QueueModel: ObservableObject {
    @Published var output = ""
    @Published var time: Double = 0.0

    public func startProcessing() {
        let startTime = Date()
        setSeed(12)
        DispatchQueue.global().async {
            (0..<100).forEach { queueIndex in
                DispatchQueue.main.async {
                    self.output = "Queue \(queueIndex) ...\n"
                }
                let queueSizish = seededRandom(in: 0..<100000)
                var queue: Queue = [44, -12, 3]
                (0..<queueSizish).forEach { _ in
                    let val = seededRandom(in: -5..<100)
                    let choice = seededRandom(in: 0..<10)
                    switch choice {
                    case 0...2:
                        queue.remove()
                    default:
                        queue.add(val)
                    }
                }
            }
            DispatchQueue.main.async {
                self.time = Date().timeIntervalSince(startTime)
            }
        }
    }
}
