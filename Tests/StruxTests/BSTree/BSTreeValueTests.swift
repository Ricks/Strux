//
//  BSTreeValueTests.swift
//  StruxTests
//
//  Created by Richard Clark on 5/4/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSTreeValueTests: XCTestCase {

    func testFromScratch() {
        let tree = BSTree<Int>()
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.totalCount, 0)
        XCTAssertNil(tree.firstIndex)
        XCTAssertNil(tree.lastIndex)
        XCTAssertNil(tree.firstValue)
        XCTAssertNil(tree.lastValue)
        XCTAssertEqual(tree.medianIndices.count, 0)
        XCTAssertEqual(tree.medianValues.count, 0)
        XCTAssertEqual(tree.sum, 0)
        XCTAssertEqual(tree.toValueArray(), [])

        tree.insert(1)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree[tree.firstIndex!].value, 1)
        XCTAssertEqual(tree.firstValue, 1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [1])
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [1])

        tree.insert(-1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree[tree.firstIndex!].value, -1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [-1, 1])
        XCTAssertEqual(tree.medianValues, [-1, 1])
        XCTAssertEqual(tree.sum, 0)
        XCTAssertEqual(tree.toValueArray(), [-1, 1])

        tree.insert(1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 3)
        XCTAssertEqual(tree[tree.firstIndex!].value, -1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [1])
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 1])

        tree.insert(5)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 4)
        XCTAssertEqual(tree[tree.firstIndex!].value, -1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 5)
        XCTAssertEqual(tree.lastValue, 5)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [1])
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 6)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 1, 5])

        tree.remove(1)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 3)
        XCTAssertEqual(tree[tree.firstIndex!].value, -1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 5)
        XCTAssertEqual(tree.lastValue, 5)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [1])
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 5)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 5])

        tree.remove(1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree[tree.firstIndex!].value, -1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 5)
        XCTAssertEqual(tree.lastValue, 5)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [-1, 5])
        XCTAssertEqual(tree.medianValues, [-1, 5])
        XCTAssertEqual(tree.sum, 4)
        XCTAssertEqual(tree.toValueArray(), [-1, 5])

        tree.remove(5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree[tree.firstIndex!].value, -1)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree[tree.lastIndex!].value, -1)
        XCTAssertEqual(tree.lastValue, -1)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [-1])
        XCTAssertEqual(tree.medianValues, [-1])
        XCTAssertEqual(tree.sum, -1)
        XCTAssertEqual(tree.toValueArray(), [-1])

        tree.remove(-1)
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.totalCount, 0)
        XCTAssertNil(tree.firstIndex)
        XCTAssertNil(tree.firstValue)
        XCTAssertNil(tree.lastIndex)
        XCTAssertNil(tree.lastIndex)
        XCTAssertEqual(tree.medianIndices, [])
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
        XCTAssertEqual(tree[tree.firstIndex!].value, 1)
        XCTAssertEqual(tree.firstValue, 1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 1)
        XCTAssertEqual(tree.lastValue, 1)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [1])
        XCTAssertEqual(tree.medianValues, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [1])

        tree.insert(2)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree[tree.firstIndex!].value, 1)
        XCTAssertEqual(tree.firstValue, 1)
        XCTAssertEqual(tree[tree.lastIndex!].value, 2)
        XCTAssertEqual(tree.lastValue, 2)
        XCTAssertEqual(tree.medianIndices.map { tree[$0].value }, [1, 2])
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
        tree.insert(1, 2, 4, 6, 9, 15, 22, -1)
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
        (0 ..< numTestTrees).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count: count)
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
        tree.insert(1, 2, 4, 6, 9, 15, 22, -1)
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
        (0 ..< numTestTrees).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count: count)
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
        tree.insert(1, 2, 4, 6, 9, 15, 22, -1)
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
        (0 ..< numTestTrees).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count: count)
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
        tree.insert(1, 2, 4, 6, 9, 15, 22, -1)
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
        (0 ..< numTestTrees).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count: count)
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
