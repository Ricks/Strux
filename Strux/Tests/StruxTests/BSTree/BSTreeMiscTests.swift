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
        XCTAssertTrue(tree.contains(4))
        XCTAssertTrue(tree.contains(-9))
        XCTAssertTrue(tree.contains(12))
        XCTAssertTrue(tree.contains(3))
        XCTAssertTrue(tree.contains(0))
        XCTAssertTrue(tree.contains(65))
        XCTAssertTrue(tree.contains(-20))
        XCTAssertTrue(tree.contains(6))
        XCTAssertFalse(tree.contains(99))
        XCTAssertEqual(tree.count(4), 2)
        XCTAssertEqual(tree.count(6), 1)
        XCTAssertEqual(tree.count(99), 0)
        let tree2 = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertEqual(tree, tree2)
        tree2.insert(4, count: 0)
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
        print(tree)
        tree.insert(42, count: 2)
        print(tree)
        tree.removeAll(14)
        print(tree)
        XCTAssertTrue(tree.contains(-2))
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
        XCTAssertEqual(tree.count(42), 2)
        let index = tree.index(42)
        XCTAssertNotNil(index)
        if let index = index {
            let index2 = tree.index(before: index)
            XCTAssertNotNil(index2)
            XCTAssertEqual(tree[index2].value, 32)
            XCTAssertEqual(tree[index2].count, 1)
            print("value = \(tree[index2].value), count = \(tree[index2].count)")
        }
        XCTAssertEqual(tree.ceilingValue(32), 32)
        XCTAssertEqual(tree.floorValue(32), 32)
        XCTAssertEqual(tree.floorValue(35), 32)
        XCTAssertEqual(tree.higherValue(32), 42)
        XCTAssertEqual(tree.lowerValue(32), -2)
        let array = Array(tree)
        XCTAssertTrue(array[0] == (value: -2, count: 1))
        XCTAssertTrue(array[1] == (value: 32, count: 1))
        XCTAssertTrue(array[2] == (value: 42, count: 2))
        for elem in tree {
            print("value = \(elem.value), count = \(elem.count)")
        }
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
        tree.insert(4, count: 4)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 5)
        print(tree)
        tree.remove(4, count: 5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        print(tree)
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

    func testCounts() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertEqual(tree.count, 8)
        XCTAssertEqual(tree.totalCount, 9)
        tree.insert(12)
        XCTAssertEqual(tree.count, 8)
        XCTAssertEqual(tree.totalCount, 10)
        tree.insert(42)
        XCTAssertEqual(tree.count, 9)
        XCTAssertEqual(tree.totalCount, 11)
        tree.insert(65, count: 3)
        XCTAssertEqual(tree.count, 9)
        XCTAssertEqual(tree.totalCount, 14)
        tree.insert(99, count: 4)
        XCTAssertEqual(tree.count, 10)
        XCTAssertEqual(tree.totalCount, 18)
        tree.insertFrom([-9, 17, 33])
        XCTAssertEqual(tree.count, 12)
        XCTAssertEqual(tree.totalCount, 21)
        tree.insert(-9, 66, 310)
        XCTAssertEqual(tree.count, 14)
        XCTAssertEqual(tree.totalCount, 24)
        print(tree)
        tree.remove(12, count: 3)
        XCTAssertEqual(tree.count, 13)
        XCTAssertEqual(tree.totalCount, 22)
        tree.remove(-9, count: 2)
        XCTAssertEqual(tree.count, 13)
        XCTAssertEqual(tree.totalCount, 20)
        tree.remove(-9, count: 2)
        XCTAssertEqual(tree.count, 12)
        XCTAssertEqual(tree.totalCount, 19)
        tree.removeAll(65)
        XCTAssertEqual(tree.count, 11)
        XCTAssertEqual(tree.totalCount, 15)
        print(tree)
        tree.remove(33, 66)
    }

}
