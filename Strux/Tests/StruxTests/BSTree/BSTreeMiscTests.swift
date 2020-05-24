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
        XCTAssertEqual(tree.ceilingValue(32), 32)
        XCTAssertEqual(tree.floorValue(32), 32)
        XCTAssertEqual(tree.higherValue(32), 42)
        XCTAssertEqual(tree.lowerValue(32), -2)
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

    func helperTestCeiling(_ tree: BSTree<Int>, _ val: Int, _ expectedCeiling: Int?) {
        if let index = tree.ceilingIndex(val) {
            XCTAssertEqual(tree[index].value, expectedCeiling)
        } else if expectedCeiling != nil {
            XCTFail("Expected \(expectedCeiling!), got nil index")
        }
        XCTAssertEqual(tree.ceilingValue(val), expectedCeiling)
    }

    func testCeiling() {
        let tree = BSTree<Int>()
        helperTestCeiling(tree, 0, nil)
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        helperTestCeiling(tree, -2, -1)
        helperTestCeiling(tree, -1, -1)
        helperTestCeiling(tree, 0, 1)
        helperTestCeiling(tree, 1, 1)
        helperTestCeiling(tree, 2, 2)
        helperTestCeiling(tree, 3, 4)
        helperTestCeiling(tree, 5, 6)
        helperTestCeiling(tree, 14, 15)
        helperTestCeiling(tree, 15, 15)
        helperTestCeiling(tree, 22, 22)
        helperTestCeiling(tree, 23, nil)
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
                    let lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! + 1) / 2
                    helperTestCeiling(tree, lookingFor, val)
                    lastVal = val
                }
                if lastVal != nil {
                    helperTestCeiling(tree, lastVal! + 1, nil)
                }
            }
        }
    }

    func helperTestFloor(_ tree: BSTree<Int>, _ val: Int, _ expectedFloor: Int?) {
        if let index = tree.floorIndex(val) {
            XCTAssertEqual(tree[index].value, expectedFloor)
        } else if expectedFloor != nil {
            XCTFail("Expected \(expectedFloor!), got nil index")
        }
        XCTAssertEqual(tree.floorValue(val), expectedFloor)
    }

    func testFloor() {
        let tree = BSTree<Int>()
        helperTestFloor(tree, 0, nil)
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        helperTestFloor(tree, -2, nil)
        helperTestFloor(tree, -1, -1)
        helperTestFloor(tree, 0, -1)
        helperTestFloor(tree, 1, 1)
        helperTestFloor(tree, 2, 2)
        helperTestFloor(tree, 3, 2)
        helperTestFloor(tree, 5, 4)
        helperTestFloor(tree, 14, 9)
        helperTestFloor(tree, 15, 15)
        helperTestFloor(tree, 22, 22)
        helperTestFloor(tree, 23, 22)
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
                    let lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! - 1) / 2
                    helperTestFloor(tree, lookingFor, lastVal)
                    lastVal = val
                }
                if !tree.isEmpty {
                    helperTestFloor(tree, tree.lastValue! + 1, tree.lastValue)
                }
            }
        }
    }

    func helperTestHigherValue(_ tree: BSTree<Int>, _ val: Int, _ expectedHigherValue: Int?) {
        if let index = tree.higherIndex(val) {
            XCTAssertEqual(tree[index].value, expectedHigherValue)
        } else if expectedHigherValue != nil {
            XCTFail("Expected \(expectedHigherValue!), got nil index")
        }
        XCTAssertEqual(tree.higherValue(val), expectedHigherValue)
    }

    func testHigherValue() {
        let tree = BSTree<Int>()
        helperTestHigherValue(tree, 0, nil)
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        helperTestHigherValue(tree, -2, -1)
        helperTestHigherValue(tree, -1, 1)
        helperTestHigherValue(tree, 0, 1)
        helperTestHigherValue(tree, 1, 2)
        helperTestHigherValue(tree, 2, 4)
        helperTestHigherValue(tree, 3, 4)
        helperTestHigherValue(tree, 5, 6)
        helperTestHigherValue(tree, 14, 15)
        helperTestHigherValue(tree, 15, 22)
        helperTestHigherValue(tree, 22, nil)
        helperTestHigherValue(tree, 23, nil)
    }

    func testHigherValueMonkey() {
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
                    let lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! - 1) / 2
                    helperTestHigherValue(tree, lookingFor, val)
                    lastVal = val
                }
                if lastVal != nil {
                    helperTestHigherValue(tree, lastVal!, nil)
                    helperTestHigherValue(tree, lastVal! + 1, nil)
                }
            }
        }
    }

    func helperTestLowerValue(_ tree: BSTree<Int>, _ val: Int, _ expectedLowerValue: Int?) {
        if let index = tree.lowerIndex(val) {
            XCTAssertEqual(tree[index].value, expectedLowerValue)
        } else if expectedLowerValue != nil {
            XCTFail("Expected \(expectedLowerValue!), got nil index")
        }
        XCTAssertEqual(tree.lowerValue(val), expectedLowerValue)
    }

    func testlowerValue() {
        let tree = BSTree<Int>()
        helperTestLowerValue(tree, 0, nil)
        tree.insertMultiple(1, 2, 4, 6, 9, 15, 22, -1)
        helperTestLowerValue(tree, -2, nil)
        helperTestLowerValue(tree, -1, nil)
        helperTestLowerValue(tree, 0, -1)
        helperTestLowerValue(tree, 1, -1)
        helperTestLowerValue(tree, 2, 1)
        helperTestLowerValue(tree, 3, 2)
        helperTestLowerValue(tree, 5, 4)
        helperTestLowerValue(tree, 14, 9)
        helperTestLowerValue(tree, 15, 9)
        helperTestLowerValue(tree, 22, 15)
        helperTestLowerValue(tree, 23, 22)
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
                    let lookingFor = (lastVal == nil) ? val - 1 : (val + lastVal! + 1) / 2
                    helperTestLowerValue(tree, lookingFor, lastVal)
                    lastVal = val
                }
                if lastVal != nil {
                    let lastIndex = tree.index(before: tree.endIndex)
                    let nextToLastIndex = (lastIndex == tree.startIndex) ? nil : tree.index(before: lastIndex)

                    var index = tree.lowerIndex(lastVal!)
                    XCTAssertEqual(index, nextToLastIndex)
                    let expectedValue = nextToLastIndex == nil ? nil : tree[nextToLastIndex!].value
                    helperTestLowerValue(tree, lastVal!, expectedValue)

                    index = tree.lowerIndex(lastVal! + 1)
                    XCTAssertEqual(index, lastIndex)
                    helperTestLowerValue(tree, lastVal! + 1, lastVal!)
                }
            }
        }
    }

}
