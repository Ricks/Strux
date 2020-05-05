//
//  BSTreeTraversalTests.swift
//  DataStructures
//
//  Created by Richard Clark on 5/3/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

import XCTest
import Foundation
@testable import Strux

class BSTreeTraversalTests: XCTestCase {

    // In-order traversal tested in BSNodeModifyTests

//          __9(2)_
//         /       \
//       _2_        44
//      /   \         \
//    -1     5         99
//          /
//         4
    func testTraversePreOrder() {
        let tree1: BSTree<Int> = [2, 5, 9, 4, -1, 44, 99, 9]
        let elements1 = tree1.traversePreOrder()
        XCTAssertEqual(elements1.count, 7)
        XCTAssertTrue(elements1[0] == (9, 2))
        XCTAssertTrue(elements1[1] == (2, 1))
        XCTAssertTrue(elements1[2] == (-1, 1))
        XCTAssertTrue(elements1[3] == (5, 1))
        XCTAssertTrue(elements1[4] == (4, 1))
        XCTAssertTrue(elements1[5] == (44, 1))
        XCTAssertTrue(elements1[6] == (99, 1))
    }

    func testTraversePostOrder() {
        let tree1: BSTree<Int> = [2, 5, 9, 4, -1, 44, 99, 9]
        let elements1 = tree1.traversePostOrder()
        XCTAssertEqual(elements1.count, 7)
        XCTAssertTrue(elements1[0] == (-1, 1))
        XCTAssertTrue(elements1[1] == (4, 1))
        XCTAssertTrue(elements1[2] == (5, 1))
        XCTAssertTrue(elements1[3] == (2, 1))
        XCTAssertTrue(elements1[4] == (99, 1))
        XCTAssertTrue(elements1[5] == (44, 1))
        XCTAssertTrue(elements1[6] == (9, 2))
    }

    func testTraverseLevelNodes() {
        let tree1: BSTree<Int> = [2, 5, 9, 4, -1, 44, 99, 9]
        let elements1 = tree1.traverseLevelNodes()
        XCTAssertEqual(elements1.count, 7)
        XCTAssertTrue(elements1[0] == (9, 2))
        XCTAssertTrue(elements1[1] == (2, 1))
        XCTAssertTrue(elements1[2] == (44, 1))
        XCTAssertTrue(elements1[3] == (-1, 1))
        XCTAssertTrue(elements1[4] == (5, 1))
        XCTAssertTrue(elements1[5] == (99, 1))
        XCTAssertTrue(elements1[6] == (4, 1))
    }
}
