//
//  BSNodeTraversalTests.swift
//  StruxTests
//
//  Created by Richard Clark on 5/4/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSNodeTraversalTests: XCTestCase {

    func testTraverseInOrderNodes() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        let elements = tree.traverseInOrder()
        let nodes = tree.root!.traverseInOrderNodes()
        XCTAssertEqual(elements.count, nodes.count)
        for i in 0 ..< elements.count {
            XCTAssertTrue(elements[i] == nodes[i].element)
        }
    }

    func testTraverseEmptyTree() {
        let tree = BSTree<Int>()
        XCTAssertTrue(tree.traverseInOrder().isEmpty)
        XCTAssertTrue(tree.traversePreOrder().isEmpty)
        XCTAssertTrue(tree.traversePostOrder().isEmpty)
        XCTAssertTrue(tree.traverseByLevel().isEmpty)
    }
}
