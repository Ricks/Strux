//
//  BSTCollectionTests.swift
//  DataStructures
//
//  Created by Richard Clark on 5/3/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

// first, last, isEmpty

class BSTCollectionTests: XCTestCase {

    func testBasic() {
        let tree: BSTree<Int> = []
        XCTAssertTrue(tree.isEmpty)
        XCTAssertNil(tree.first)
        XCTAssertNil(tree.last)
        tree.insert(4)
        tree.insert(5)
        XCTAssertFalse(tree.isEmpty)
        XCTAssertTrue(tree.first! == (4, 1))
        XCTAssertTrue(tree.last! == (5, 1))
    }

    func testIndexEquality() {
        let tree = BSTree([4, -9, 12, 3, 0, 65, -20, 4, 6])
        var i1 = tree.startIndex
        var i2 = tree.startIndex
        var n = 0
        while i1 < tree.endIndex {
            n += 1
            XCTAssertEqual(i1, i2)
            i1 = tree.index(after: i1)
            i2 = tree.index(after: i2)
        }
        XCTAssertEqual(n, 8)
    }

}
