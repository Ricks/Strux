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
}
