//
//  BSTreeConstructorTests.swift
//  StruxTests
//
//  Created by Richard Clark on 5/2/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSTreeConstructorTests: XCTestCase {

    func testBasicConstructor() {
        let tree = BSTree<Int>()
        XCTAssertEqual(tree.count, 0)
        XCTAssertNil(tree.firstValue)
        XCTAssertNil(tree.lastValue)
        tree.insert(4)
        tree.insert(5, count: 2)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.firstValue!, 4)
        XCTAssertEqual(tree.lastValue!, 5)
    }

    func testInitWithCountedSet() {
        let set = NSCountedSet(array: [-12, 4, 42, 66, 4])
        let tree = BSTree<Int>(countedSet: set)
        let set2 = tree.toCountedSet()
        XCTAssertEqual(set, set2)
    }

    func testInitWithArray() {
        let set = NSCountedSet(array: [-12, 4, 42, 66, 4])
        let tree = BSTree([-12, 4, 42, 66, 4])
        let set2 = tree.toCountedSet()
        XCTAssertEqual(set, set2)
    }

    func testInitWithLiteral() {
        let set = NSCountedSet(array: [-12, 4, 42, 66, 4])
        let tree = BSTree(-12, 4, 42, 66, 4)
        let set2 = tree.toCountedSet()
        XCTAssertEqual(set, set2)
    }

}
