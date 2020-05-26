//
//  BSNodeModifyTests.swift
//  StruxTests
//
//  Created by Richard Clark on 4/27/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSNodeModifyTests: XCTestCase {

    func testInsertRemove() {
        setSeed(5)
        (0 ..< 100).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let numInitial = seededRandom(in: 0 ..< 9)
            var initialValues = [Int]()
            for _ in 0 ..< numInitial {
                initialValues.append(seededRandom(in: -5 ..< 100))
            }
            var set = NSCountedSet(array: initialValues)
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree(initialValues)
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                let choice = seededRandom(in: 0 ..< 100)
                switch choice {
                case 0 - 9:
                    tree.removeAll(val)
                    let n = set.count(for: val)
                    for _ in 0 ..< n { set.remove(val) }
                case 10 - 19:
                    tree.remove(val)
                    set.remove(val)
                case 20 - 29:
                    tree.remove(val, count)
                    for _ in 0 ..< count { set.remove(val) }
                case 30 - 32:
                    tree.clear()
                    set = NSCountedSet()
                default:
                    if count == 1 {
                        tree.insert(val)
                    } else {
                        tree.insert(val, count)
                    }
                    for _ in 0 ..< count { set.add(val) }
                }
                validateTree(tree, "Tree \(treeIndex)")
                if tree.toCountedSet() != set {
                    XCTFail("Tree \(treeIndex) has counts \(tree.toCountedSet()), expected \(set)")
                }
                for val in set {
                    let intVal = val as! Int
                    XCTAssertEqual(tree.count(of: intVal), set.count(for: intVal))
                }
                let vals = (set.allObjects as! [Int]).sorted()
                XCTAssertEqual(tree.count, vals.count)
                let treeElements = tree.traverseInOrder()
                XCTAssertEqual(treeElements.count, vals.count)
                if vals.count > 0 {
                    for i in 0 ..< vals.count {
                        XCTAssertEqual(treeElements[i].value, vals[i])
                        XCTAssertEqual(treeElements[i].count, set.count(for: vals[i]))
                    }
                }
                if tree.firstValue != vals.min() {
                    XCTFail("Tree \(treeIndex) has first value of \(valOrNil(tree.firstValue)), " +
                        "expected \(valOrNil(vals.min()))")
                    print(tree)
                }
                if tree.lastValue != vals.max() {
                    XCTFail("Tree \(treeIndex) has last value of \(valOrNil(tree.lastValue)), " +
                        "expected \(valOrNil(vals.max()))")
                    print(tree)
                }
            }
        }
    }

    func testReturnsFromInsert() {
        let tree = BSTree<Int>()
        tree.insert(2)
        let result1 = tree.root!.insert(42, 1)
        XCTAssertEqual(result1.node.value, 42)
        XCTAssertEqual(result1.node.valueCount, 1)
        XCTAssertTrue(result1.new)
        let result2 = tree.root!.insert(42, 1)
        XCTAssertEqual(result2.node.value, 42)
        XCTAssertEqual(result2.node.valueCount, 2)
        XCTAssertFalse(result2.new)
    }

    func testInsertMultipleValues() {
        let tree = BSTree<Int>()
        tree.insert([1, 5, 3])
        tree.insertMultiple(4, 9, -1)
        XCTAssertEqual(tree.count, 6)
        XCTAssertEqual(tree.totalCount, 6)
        XCTAssertEqual(tree.sum, 21)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 9)
        XCTAssertEqual(tree.medianValues, [3, 4])
        XCTAssertTrue(tree.containsValue(1))
        XCTAssertTrue(tree.containsValue(5))
        XCTAssertTrue(tree.containsValue(3))
        XCTAssertTrue(tree.containsValue(4))
        XCTAssertTrue(tree.containsValue(9))
        XCTAssertTrue(tree.containsValue(-1))
        XCTAssertFalse(tree.containsValue(42))
        print(tree)
    }

    func testRemoveNonExistentValue() {
        let tree = BSTree<Int>()
        tree.insert([1, 5, 3])
        tree.insertMultiple(4, 9, -1)
        XCTAssertEqual(tree.count, 6)
        XCTAssertEqual(tree.totalCount, 6)
        XCTAssertEqual(tree.sum, 21)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 9)
        XCTAssertEqual(tree.medianValues, [3, 4])
        XCTAssertTrue(tree.containsValue(1))
        XCTAssertTrue(tree.containsValue(5))
        XCTAssertTrue(tree.containsValue(3))
        XCTAssertTrue(tree.containsValue(4))
        XCTAssertTrue(tree.containsValue(9))
        XCTAssertTrue(tree.containsValue(-1))
        XCTAssertFalse(tree.containsValue(42))

        tree.remove(5, 2)
        XCTAssertEqual(tree.count, 5)
        XCTAssertEqual(tree.totalCount, 5)
        XCTAssertEqual(tree.sum, 16)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 9)
        XCTAssertEqual(tree.medianValues, [3])
        XCTAssertTrue(tree.containsValue(1))
        XCTAssertFalse(tree.containsValue(5))
        XCTAssertTrue(tree.containsValue(3))
        XCTAssertTrue(tree.containsValue(4))
        XCTAssertTrue(tree.containsValue(9))
        XCTAssertTrue(tree.containsValue(-1))
        XCTAssertFalse(tree.containsValue(42))
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 3, 4, 9])

        tree.remove(5)
        XCTAssertEqual(tree.count, 5)
        XCTAssertEqual(tree.totalCount, 5)
        XCTAssertEqual(tree.sum, 16)
        XCTAssertEqual(tree.firstValue, -1)
        XCTAssertEqual(tree.lastValue, 9)
        XCTAssertEqual(tree.medianValues, [3])
        XCTAssertTrue(tree.containsValue(1))
        XCTAssertFalse(tree.containsValue(5))
        XCTAssertTrue(tree.containsValue(3))
        XCTAssertTrue(tree.containsValue(4))
        XCTAssertTrue(tree.containsValue(9))
        XCTAssertTrue(tree.containsValue(-1))
        XCTAssertFalse(tree.containsValue(42))
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 3, 4, 9])
    }
}
