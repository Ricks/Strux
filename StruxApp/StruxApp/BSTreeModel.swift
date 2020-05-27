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
                    let choice = seededRandom(in: 0..<100)
                    switch choice {
                    case 0-9:
                        tree.removeAll(val)
                    case 10-19:
                        tree.remove(val)
                    case 20-29:
                        tree.remove(val, count)
                    case 30-34:
                        tree.clear()
                    default:
                        if count == 1 {
                            tree.insert(val)
                        } else {
                            tree.insert(val, count)
                        }
                    }
                }
                let tree2 = tree.copy() as! BSTree<Int>
                if tree2 != tree {
                    print("*** tree copy not equal to tree, index = \(treeIndex)")
                }
                if tree2.firstValue != tree.firstValue {
                    print("*** tree copy firstValue not equal to tree firstValue, index = \(treeIndex)")
                }
//                if tree2.height != tree.height {
//                    print("*** tree copy height not equal to tree height, index = \(treeIndex)")
//                    print("tree:\n\(tree.descriptionWithHeight)")
//                    print("\ntree2:\n\(tree2.descriptionWithHeight)")
//                }
                if tree2.last?.value != tree.last?.value {
                    print("*** tree copy tree2.last?.value not equal to tree tree2.last?.value, index = \(treeIndex)")
                }
                if tree2.lastValue != tree.lastValue {
                    print("*** tree copy lastValue not equal to tree lastValue, index = \(treeIndex)")
                }
                if tree2.medianValues != tree.medianValues {
                    print("*** tree copy medianValues not equal to tree medianValues, index = \(treeIndex)")
                }
                if tree2.count != tree.count {
                    print("*** tree copy count not equal to tree count, index = \(treeIndex)")
                }
                if tree2.totalCount != tree.totalCount {
                    print("*** tree copy totalCount not equal to tree totalCount, index = \(treeIndex)")
                }
                var index = tree.startIndex
                var index2 = tree2.startIndex
                while index != tree.endIndex {
                    if tree[index] != tree2[index2] {
                        print("*** tree[index] != tree2[index2], forward dir, index = \(treeIndex)")
                    }
                    index = tree.index(after: index)
                    index2 = tree2.index(after: index2)
                }
                index = tree.endIndex
                index2 = tree2.endIndex
                repeat {
                    index = tree.index(before: index)
                    index2 = tree2.index(before: index2)
                    if tree[index] != tree2[index2] {
                        print("*** tree[index] != tree2[index2], backward dir, index = \(treeIndex)")
                    }
                } while index != tree.startIndex
                var s = tree.description
                s = tree.descriptionWithNext
                s = tree.descriptionWithHeight
                s = tree.descriptionWithNodeCount
                s = tree.descriptionWithTotalCount
                _ = s
                let sum = tree.toValueArray().reduce(0, +)
                if sum != tree.sum {
                    print("*** tree sum not equal to sum of array, index = \(treeIndex)")
                }
                let set = tree.toCountedSet()
                let tree3 = BSTree<Int>(countedSet: set)
                if tree3 != tree {
                    print("*** tree3 not equal to tree, index = \(treeIndex)")
                }
                let arr1 = tree.traverseInOrder()
                let arr2 = tree.traversePreOrder()
                let arr3 = tree.traversePostOrder()
                let arr4 = tree.traverseByLevel()
                if arr1.count != arr2.count || arr2.count != arr3.count || arr3.count != arr4.count {
                    print("*** traversal counts not same, index = \(treeIndex)")
                }
                if !tree.isValid {
                    print("*** tree not valid, index = \(treeIndex)")
                }
                if !tree.isBalanced {
                    print("*** tree not balanced, index = \(treeIndex)")
                }
            }
            let tree1 = BSTree<Int>()
            tree1.insert(44)
            tree1.insert(-12)
            tree1.insert(3)
            let tree2 = BSTree<Int>([44, -12, 3])
            let tree3 = BSTree<Int>(44, -12, 3)
            if tree1 != tree2 {
                print("*** tree1 not equal to tree2")
            }
            if tree2 != tree3 {
                print("*** tree1 not equal to tree2")
            }
            if tree1.indexOf(44) == nil {
                print("*** Can't get index of 44")
            }
            if !tree1.containsValue(44) {
                print("*** Doesn't contain")
            }
            if tree2.count(of: 44) != 1 {
                print("*** Count of 44 not 1")
            }
            DispatchQueue.main.async {
                self.time = Date().timeIntervalSince(startTime)
            }
        }
    }
}
