//
//  BSTreeMiscTests.swift
//  DataStructures
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
        let tree: BSTree = [4, -9, 12, 3, 0, 65, -20, 4, 6]
        XCTAssertTrue(tree.contains(value: 4))
        XCTAssertTrue(tree.contains(value: -9))
        XCTAssertTrue(tree.contains(value: 12))
        XCTAssertTrue(tree.contains(value: 3))
        XCTAssertTrue(tree.contains(value: 0))
        XCTAssertTrue(tree.contains(value: 65))
        XCTAssertTrue(tree.contains(value: -20))
        XCTAssertTrue(tree.contains(value: 6))
        XCTAssertFalse(tree.contains(value: 99))
        XCTAssertEqual(tree.count(of: 4), 2)
        XCTAssertEqual(tree.count(of: 6), 1)
        XCTAssertEqual(tree.count(of: 99), 0)
        let tree2: BSTree = [4, -9, 12, 3, 0, 65, -20, 4, 6]
        XCTAssertEqual(tree, tree2)
        tree2.insert(4, 0)
        XCTAssertEqual(tree, tree2)
        print(tree)
        XCTAssertEqual(tree.height, 3)
        let tree3 = BSTree<Int>()
        XCTAssertEqual(tree3.height, -1)
    }

    func testDeleteMinNode() {
        let tree: BSTree = [4, -9, 12, 3, 0, 65, -20, 4, 6]
        tree.delete(-20)
        XCTAssertEqual(tree.min!.value, -9)
        tree.delete(65)
        XCTAssertEqual(tree.max!.value, 12)
    }

    func testEmptyTree() {
        let tree: BSTree<Int> = []
        XCTAssertTrue(tree.isEmpty)
        XCTAssertTrue(tree.isBalanced)
        XCTAssertTrue(tree.isValid)
        XCTAssertEqual(tree.height, -1)
        XCTAssertEqual(tree.count, 0)
        XCTAssertNil(tree.min)
        XCTAssertNil(tree.max)
    }

    func testCopy() {
        let tree: BSTree = [4, -9, 12, 3, 0, 65, -20, 4, 6]
        let tree2 = tree.copy() as! BSTree<Int>
        XCTAssertFalse(tree === tree2)
        XCTAssertTrue(tree == tree2)
    }

    func testDocumentation() {
        let tree: BSTree = [14, -2, 32, 14]
        tree.insert(42, 2)
        tree.deleteAll(14)
        XCTAssertTrue(tree.contains(value: -2))
        let expectedDescrip = "   32      \n" +
                              "  /  \\     \n" +
                              "-2    42(2)"
        XCTAssertEqual(tree.description, expectedDescrip)
        XCTAssertEqual(tree.height, 1)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(tree.min?.value, -2)
        XCTAssertEqual(tree.min?.count, 1)
        XCTAssertEqual(tree.max?.value, 42)
        XCTAssertEqual(tree.max?.count, 2)
        let array = Array(tree)
        XCTAssertTrue(array[0] == (value: -2, count: 1))
        XCTAssertTrue(array[1] == (value: 32, count: 1))
        XCTAssertTrue(array[2] == (value: 42, count: 2))
    }
}
