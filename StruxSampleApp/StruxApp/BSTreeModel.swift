//
//  BSTreeModel.swift
//  
//
//  Created by Richard Clark on 5/5/20.
//

import Foundation
import SwiftUI
import Combine
import Strux

class BSTreeModel: ObservableObject {
    @Published var output = ""
    @Published var time: Double = 0.0

    public func startProcessing() {
        let startTime = Date()
        setSeed(5)
        DispatchQueue.global().async {
            (0..<100).forEach { treeIndex in
                DispatchQueue.main.async {
                    self.output = "Tree \(treeIndex) ...\n"
                }
                let initialValues = [44, -12, 3]
                let treeSizish = seededRandom(in: 0..<100000)
                let tree = BSTree(initialValues)
                (0..<treeSizish).forEach { _ in
                    let val = seededRandom(in: -5..<100)
                    let count = seededRandom(in: 1..<2)
                    let choice = seededRandom(in: 0..<10)
                    switch choice {
                    case 0:
                        tree.deleteAll(val)
                    case 1:
                        tree.delete(val)
                    case 2:
                        tree.delete(val, count)
                    default:
                        if count == 1 {
                            tree.insert(val)
                        } else {
                            tree.insert(val, count)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.time = Date().timeIntervalSince(startTime)
            }
        }
    }
}
