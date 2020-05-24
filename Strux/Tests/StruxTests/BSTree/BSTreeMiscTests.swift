//
//  BSTreeMiscTests.swift
//  StruxTests
//
//  Created by Richard Clark on 5/4/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSTreeMiscTests: XCTestCase {

    func testTraverseInOrderNodes() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertTrue(tree.containsValue(4))
        XCTAssertTrue(tree.containsValue(-9))
        XCTAssertTrue(tree.containsValue(12))
        XCTAssertTrue(tree.containsValue(3))
        XCTAssertTrue(tree.containsValue(0))
        XCTAssertTrue(tree.containsValue(65))
        XCTAssertTrue(tree.containsValue(-20))
        XCTAssertTrue(tree.containsValue(6))
        XCTAssertFalse(tree.containsValue(99))
        XCTAssertEqual(tree.count(of: 4), 2)
        XCTAssertEqual(tree.count(of: 6), 1)
        XCTAssertEqual(tree.count(of: 99), 0)
        let tree2 = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertEqual(tree, tree2)
        tree2.insert(4, 0)
        XCTAssertEqual(tree, tree2)
        print(tree)
        XCTAssertEqual(tree.height, 3)
        let tree3 = BSTree<Int>()
        XCTAssertEqual(tree3.height, -1)
    }

    func testRemovefirstNode() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        tree.remove(-20)
        XCTAssertEqual(tree.firstValue, -9)
        tree.remove(65)
        XCTAssertEqual(tree.lastValue, 12)
    }

    func testEmptyTree() {
        let tree = BSTree<Int>()
        XCTAssertTrue(tree.isEmpty)
        XCTAssertTrue(tree.isBalanced)
        XCTAssertTrue(tree.isValid)
        XCTAssertEqual(tree.height, -1)
        XCTAssertEqual(tree.count, 0)
        XCTAssertNil(tree.firstValue)
        XCTAssertNil(tree.lastValue)
    }

    func testCopy() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        let tree2 = tree.copy() as! BSTree<Int>
        XCTAssertFalse(tree === tree2)
        XCTAssertTrue(tree == tree2)
    }

    func testDocumentation() {
        let tree = BSTree(14, -2, 32, 14)
        tree.insert(42, 2)
        tree.removeAll(14)
        XCTAssertTrue(tree.containsValue(-2))
        let expectedDescrip = "   32      \n" +
                              "  /  \\     \n" +
                              "-2    42(2)"
        XCTAssertEqual(tree.description, expectedDescrip)
        XCTAssertEqual(tree.height, 1)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 4)
        XCTAssertEqual(tree.firstValue, -2)
        XCTAssertEqual(tree.lastValue, 42)
        XCTAssertEqual(tree.medianValues, [32, 42])
        XCTAssertEqual(tree.sum, 114)
        let array = Array(tree)
        XCTAssertTrue(array[0] == (value: -2, count: 1))
        XCTAssertTrue(array[1] == (value: 32, count: 1))
        XCTAssertTrue(array[2] == (value: 42, count: 2))
    }

    func testNodeCheck() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertTrue(tree.root!.isNextCorrect)
        let node6 = tree.root!.right!
        tree.root!.next = node6
        XCTAssertFalse(tree.root!.isNextCorrect)
    }

    func testRemoveMoreThanThereAre() {
        let tree = BSTree<Int>()
        tree.insert(2)
        tree.insert(42, 4)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 5)
        tree.remove(42, 5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
    }

    func testClear() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertFalse(tree.isEmpty)
        tree.clear()
        XCTAssertTrue(tree.isEmpty)
        XCTAssertEqual(tree.height, -1)
        XCTAssertNil(tree.firstValue)
        XCTAssertNil(tree.lastValue)
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.totalCount, 0)
        XCTAssertTrue(tree.medianValues.isEmpty)

        let tree2 = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertEqual(tree2.sum, 65)
        tree2.clear()
        XCTAssertEqual(tree2.sum, 0)
    }

    func testFromScratch() {
        let tree = BSTree<Int>()
        tree.insert(1)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree.firstValue, 1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [1])

        tree.insert(-1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianValues, [-1, 1])
        XCTAssertEqual(tree.sum, 0)
        XCTAssertEqual(tree.toValueArray(), [-1, 1])

        tree.insert(1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 3)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 1])

        tree.insert(5)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 4)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 5)
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 6)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 1, 5])

        tree.remove(1)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 3)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 5)
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 5)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 5])

        tree.remove(1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 5)
        XCTAssertEqual(tree.medianValues, [-1, 5])
        XCTAssertEqual(tree.sum, 4)
        XCTAssertEqual(tree.toValueArray(), [-1, 5])

        tree.remove(5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, -1)
        XCTAssertEqual(tree.medianValues, [-1])
        XCTAssertEqual(tree.sum, -1)
        XCTAssertEqual(tree.toValueArray(), [-1])

        tree.remove(-1)
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.totalCount, 0)
        XCTAssertNil(tree.firstValue)
        XCTAssertNil(tree.lastValue)
        XCTAssertEqual(tree.medianValues, [])
        XCTAssertEqual(tree.sum, 0)
        XCTAssertEqual(tree.toValueArray(), [])
        XCTAssertTrue(tree.isEmpty)
    }

    func testFromScratch2() {
        let tree = BSTree<Int>()
        tree.insert(1)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree.firstValue, 1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [1])

        tree.insert(2)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree.firstValue, 1)
        XCTAssertEqual(tree.lastValue, 2)
        XCTAssertEqual(tree.medianValues, [1, 2])
        XCTAssertEqual(tree.sum, 3)
        XCTAssertEqual(tree.toValueArray(), [1, 2])
    }

    func testCeiling() {
        let tree = BSTree<Int>()
        XCTAssertNil(tree.ceiling(0))
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        var index = tree.ceiling(-2)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.ceiling(-1)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.ceiling(0)
        XCTAssertEqual(tree[index!].value, 1)
        index = tree.ceiling(1)
        XCTAssertEqual(tree[index!].value, 1)
        index = tree.ceiling(2)
        XCTAssertEqual(tree[index!].value, 2)
        index = tree.ceiling(3)
        XCTAssertEqual(tree[index!].value, 4)
        index = tree.ceiling(5)
        XCTAssertEqual(tree[index!].value, 6)
        index = tree.ceiling(14)
        XCTAssertEqual(tree[index!].value, 15)
        index = tree.ceiling(15)
        XCTAssertEqual(tree[index!].value, 15)
        index = tree.ceiling(22)
        XCTAssertEqual(tree[index!].value, 22)
        XCTAssertNil(tree.ceiling(23))
    }

    func testCeilingMonkey() {
        setSeed(5)
        (0 ..< 100).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count)
                var lastVal: Int?
                for (val, _) in tree {
                    var lookingFor: Int
                    let expecting = val
                    lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! + 1) / 2
                    let foundIndex = tree.ceiling(lookingFor)
                    let found = tree[foundIndex!].value
                    if found != expecting {
                        XCTFail("Looking for \(lookingFor), expected \(expecting), got \(valOrNil(found)), val = \(val), lastVal = \(valOrNil(lastVal))")
                        print(tree)
                        exit(1)
                    }
                    lastVal = val
                }
                if lastVal != nil {
                    XCTAssertNil(tree.ceiling(lastVal! + 1))
                }
            }
        }
    }

    func testFloor() {
        let tree = BSTree<Int>()
        XCTAssertNil(tree.floor(0))
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        XCTAssertNil(tree.floor(-2))
        var index = tree.floor(-1)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.floor(0)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.floor(1)
        XCTAssertEqual(tree[index!].value, 1)
        index = tree.floor(2)
        XCTAssertEqual(tree[index!].value, 2)
        index = tree.floor(3)
        XCTAssertEqual(tree[index!].value, 2)
        index = tree.floor(5)
        XCTAssertEqual(tree[index!].value, 4)
        index = tree.floor(14)
        XCTAssertEqual(tree[index!].value, 9)
        index = tree.floor(15)
        XCTAssertEqual(tree[index!].value, 15)
        index = tree.floor(22)
        XCTAssertEqual(tree[index!].value, 22)
        index = tree.floor(23)
        XCTAssertEqual(tree[index!].value, 22)
    }

    func testFloorMonkey() {
        setSeed(5)
        (0 ..< 100).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count)
                var lastVal: Int?
                for (val, _) in tree {
                    var lookingFor: Int
                    let expecting = lastVal
                    lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! - 1) / 2
                    let foundIndex = tree.floor(lookingFor)
                    let found = foundIndex == nil ? nil : tree[foundIndex!].value
                    if found != expecting {
                        XCTFail("Looking for \(lookingFor), expected \(valOrNil(expecting)), got \(valOrNil(found)), val = \(val), lastVal = \(valOrNil(lastVal))")
                        print(tree)
                        exit(1)
                    }
                    lastVal = val
                }
                if !tree.isEmpty {
                    let foundIndex = tree.floor(tree.lastValue! + 1)
                    XCTAssertEqual(tree[foundIndex!].value, tree.lastValue)
                }
            }
        }
    }

    func testHigher() {
        let tree = BSTree<Int>()
        XCTAssertNil(tree.higher(0))
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        var index = tree.higher(-2)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.higher(-1)
        XCTAssertEqual(tree[index!].value, 1)
        index = tree.higher(0)
        XCTAssertEqual(tree[index!].value, 1)
        index = tree.higher(1)
        XCTAssertEqual(tree[index!].value, 2)
        index = tree.higher(2)
        XCTAssertEqual(tree[index!].value, 4)
        index = tree.higher(3)
        XCTAssertEqual(tree[index!].value, 4)
        index = tree.higher(5)
        XCTAssertEqual(tree[index!].value, 6)
        index = tree.higher(14)
        XCTAssertEqual(tree[index!].value, 15)
        index = tree.higher(15)
        XCTAssertEqual(tree[index!].value, 22)
        XCTAssertNil(tree.higher(22))
        XCTAssertNil(tree.higher(23))
    }

    func testHigherMonkey() {
        setSeed(5)
        (0 ..< 100).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count)
                var lastVal: Int?
                for (val, _) in tree {
                    var lookingFor: Int
                    let expecting = val
                    lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! - 1) / 2
                    let foundIndex = tree.higher(lookingFor)
                    let found = tree[foundIndex!].value
                    if found != expecting {
                        XCTFail("Looking for \(lookingFor), expected \(expecting), got \(valOrNil(found)), val = \(val), lastVal = \(valOrNil(lastVal))")
                        print(tree)
                        exit(1)
                    }
                    lastVal = val
                }
                if lastVal != nil {
                    XCTAssertNil(tree.higher(lastVal!))
                    XCTAssertNil(tree.higher(lastVal! + 1))
                }
            }
        }
    }

    func testLower() {
        let tree = BSTree<Int>()
        XCTAssertNil(tree.higher(0))
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        XCTAssertNil(tree.lower(-2))
        XCTAssertNil(tree.lower(-1))
        var index = tree.lower(0)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.lower(1)
        XCTAssertEqual(tree[index!].value, -1)
        index = tree.lower(2)
        XCTAssertEqual(tree[index!].value, 1)
        index = tree.lower(3)
        XCTAssertEqual(tree[index!].value, 2)
        index = tree.lower(5)
        XCTAssertEqual(tree[index!].value, 4)
        index = tree.lower(14)
        XCTAssertEqual(tree[index!].value, 9)
        index = tree.lower(15)
        XCTAssertEqual(tree[index!].value, 9)
        index = tree.lower(22)
        XCTAssertEqual(tree[index!].value, 15)
        index = tree.lower(23)
        XCTAssertEqual(tree[index!].value, 22)
    }

    func testLowerMonkey() {
        setSeed(5)
        (0 ..< 100).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count)
                var lastVal: Int?
                for (val, _) in tree {
                    var lookingFor: Int
                    let expecting = lastVal
                    lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! + 1) / 2
                    let foundIndex = tree.lower(lookingFor)
                    let found = foundIndex == nil ? nil : tree[foundIndex!].value
                    if found != expecting {
                        XCTFail("Looking for \(lookingFor), expected \(valOrNil(expecting)), got \(valOrNil(found)), val = \(val), lastVal = \(valOrNil(lastVal))")
                        print(tree)
                        exit(1)
                    }
                    lastVal = val
                }
                if lastVal != nil {
                    let lastIndex = tree.index(before: tree.endIndex)
                    let nextToLastIndex = (lastIndex == tree.startIndex) ? nil : tree.index(before: lastIndex)

                    var index = tree.lower(lastVal!)
                    XCTAssertEqual(index, nextToLastIndex)

                    index = tree.lower(lastVal! + 1)
                    XCTAssertEqual(index, lastIndex)
                }
            }
        }
    }

}
