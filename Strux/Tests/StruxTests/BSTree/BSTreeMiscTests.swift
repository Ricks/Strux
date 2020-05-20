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

    func testDeleteMinNode() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        tree.delete(-20)
        XCTAssertEqual(tree.minimum, -9)
        tree.delete(65)
        XCTAssertEqual(tree.maximum, 12)
    }

    func testEmptyTree() {
        let tree = BSTree<Int>()
        XCTAssertTrue(tree.isEmpty)
        XCTAssertTrue(tree.isBalanced)
        XCTAssertTrue(tree.isValid)
        XCTAssertEqual(tree.height, -1)
        XCTAssertEqual(tree.count, 0)
        XCTAssertNil(tree.minimum)
        XCTAssertNil(tree.maximum)
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
        tree.deleteAll(14)
        XCTAssertTrue(tree.containsValue(-2))
        let expectedDescrip = "   32      \n" +
                              "  /  \\     \n" +
                              "-2    42(2)"
        XCTAssertEqual(tree.description, expectedDescrip)
        XCTAssertEqual(tree.height, 1)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 4)
        XCTAssertEqual(tree.minimum, -2)
        XCTAssertEqual(tree.maximum, 42)
        XCTAssertEqual(tree.medians, [32, 42])
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

    func testDeleteMoreThanThereAre() {
        let tree = BSTree<Int>()
        tree.insert(2)
        tree.insert(42, 4)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 5)
        tree.delete(42, 5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
    }

    func testClear() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        XCTAssertFalse(tree.isEmpty)
        tree.clear()
        XCTAssertTrue(tree.isEmpty)
        XCTAssertEqual(tree.height, -1)
        XCTAssertNil(tree.minimum)
        XCTAssertNil(tree.maximum)
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.totalCount, 0)
        XCTAssertTrue(tree.medians.isEmpty)

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
        XCTAssertEqual(tree.minimum, 1)
        XCTAssertEqual(tree.maximum, 1)
        XCTAssertEqual(tree.medians, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [1])

        tree.insert(-1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree.minimum, -1)
        XCTAssertEqual(tree.maximum, 1)
        XCTAssertEqual(tree.medians, [-1, 1])
        XCTAssertEqual(tree.sum, 0)
        XCTAssertEqual(tree.toValueArray(), [-1, 1])

        tree.insert(1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 3)
        XCTAssertEqual(tree.minimum, -1)
        XCTAssertEqual(tree.maximum, 1)
        XCTAssertEqual(tree.medians, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 1])

        tree.insert(5)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 4)
        XCTAssertEqual(tree.minimum, -1)
        XCTAssertEqual(tree.maximum, 5)
        XCTAssertEqual(tree.medians, [1])
        XCTAssertEqual(tree.sum, 6)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 1, 5])

        tree.delete(1)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.totalCount, 3)
        XCTAssertEqual(tree.minimum, -1)
        XCTAssertEqual(tree.maximum, 5)
        XCTAssertEqual(tree.medians, [1])
        XCTAssertEqual(tree.sum, 5)
        XCTAssertEqual(tree.toValueArray(), [-1, 1, 5])

        tree.delete(1)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree.minimum, -1)
        XCTAssertEqual(tree.maximum, 5)
        XCTAssertEqual(tree.medians, [-1, 5])
        XCTAssertEqual(tree.sum, 4)
        XCTAssertEqual(tree.toValueArray(), [-1, 5])

        tree.delete(5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree.minimum, -1)
        XCTAssertEqual(tree.maximum, -1)
        XCTAssertEqual(tree.medians, [-1])
        XCTAssertEqual(tree.sum, -1)
        XCTAssertEqual(tree.toValueArray(), [-1])

        tree.delete(-1)
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.totalCount, 0)
        XCTAssertNil(tree.minimum)
        XCTAssertNil(tree.maximum)
        XCTAssertEqual(tree.medians, [])
        XCTAssertEqual(tree.sum, 0)
        XCTAssertEqual(tree.toValueArray(), [])
        XCTAssertTrue(tree.isEmpty)
    }

    func testFromScratch2() {
        let tree = BSTree<Int>()
        tree.insert(1)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
        XCTAssertEqual(tree.minimum, 1)
        XCTAssertEqual(tree.maximum, 1)
        XCTAssertEqual(tree.medians, [1])
        XCTAssertEqual(tree.sum, 1)
        XCTAssertEqual(tree.toValueArray(), [1])

        tree.insert(2)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 2)
        XCTAssertEqual(tree.minimum, 1)
        XCTAssertEqual(tree.maximum, 2)
        XCTAssertEqual(tree.medians, [1, 2])
        XCTAssertEqual(tree.sum, 3)
        XCTAssertEqual(tree.toValueArray(), [1, 2])
    }
}
